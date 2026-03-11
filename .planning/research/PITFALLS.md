# Pitfalls Research

**Domain:** Flutter design token / utility styling package (pub.dev)
**Researched:** 2026-03-11
**Confidence:** HIGH (most pitfalls verified via official docs, Dart language spec, or Flutter issue tracker)

---

## Critical Pitfalls

### Pitfall 1: Extension Type Instance Getters Cannot Be Used in Const Contexts

**What goes wrong:**
The PRD defines `TwSpace` as `extension type const TwSpace(double value) implements double` with convenience getters like `EdgeInsets get all => EdgeInsets.all(value)`. Consumers will naturally attempt `const padding = TwSpace.s4.all` -- and it will fail with `CONST_EVAL_EXTENSION_TYPE_METHOD`. Extension type instance members (getters, methods) are **not** evaluable in const expressions. Only the constructor itself is const-foldable. This means `const TwSpace(16)` is const, but `TwSpace.s4.all` is a runtime call even though `EdgeInsets.all` has a const constructor. Dart's const evaluator does not inline extension type getter bodies.

**Why it happens:**
Dart's const language subset intentionally does not evaluate instance getters -- not on classes, not on extension types. The Dart team has stated they are not expanding the const sub-language. Extension types are compile-time wrappers but their members are still runtime dispatch.

**How to avoid:**
1. Document clearly that `TwSpace.s4.all` is **not** const and should not be used where const is required (e.g., inside const widget constructors).
2. For consumers who need const EdgeInsets, provide static const helpers: `static const EdgeInsets allS4 = EdgeInsets.all(16)` or a separate `TwEdgeInsets` class with pre-computed const values.
3. Consider whether convenience getters on extension types are worth the const-confusion. The raw `double` value (which IS const since extension types erase to representation type) used directly in `EdgeInsets.all(TwSpace.s4)` is const-compatible since `TwSpace.s4` erases to `16.0` at compile time.

**Warning signs:**
- Analyzer errors `CONST_EVAL_EXTENSION_TYPE_METHOD` in consumer code
- GitHub issues from users saying "I can't use your tokens in const constructors"
- Confusion about what is and isn't const in the API

**Phase to address:**
Phase 1 (Token Design) -- this is a foundational API design decision. Getting this wrong means a breaking change later. Must be decided before any token code is written.

**Confidence:** HIGH -- verified via Dart SDK issue #56148 and official extension types docs.

---

### Pitfall 2: Extension Type Runtime Type Erasure Breaks `is` Checks and Pattern Matching

**What goes wrong:**
Extension types are **completely erased at runtime**. `TwSpace` disappears -- at runtime, it is just a `double`. This means:
- `someValue is TwSpace` will be `true` for ANY double, not just values from the Tailwind scale
- Pattern matching on `TwSpace` matches all doubles
- `List<TwSpace>` is `List<double>` at runtime -- you cannot distinguish them
- Runtime type introspection (`runtimeType`, debugging tools) shows `double`, not `TwSpace`

This matters because if anyone writes code that branches on `is TwSpace` thinking it validates a value is from the Tailwind scale, they will get silent false positives.

**Why it happens:**
Extension types are a zero-cost compile-time-only abstraction. They were designed for FFI interop where runtime erasure is the point. Using them for domain types is ergonomic but loses runtime safety.

**How to avoid:**
1. Document explicitly that extension types provide compile-time safety only, not runtime validation.
2. Never expose APIs where `is TwSpace` checks would be meaningful.
3. For ThemeExtension lerp/copyWith, use raw `double` fields (not `TwSpace`) since theme values may be interpolated to values outside the Tailwind scale.
4. In debug tooling, don't rely on `runtimeType` for extension types.

**Warning signs:**
- Code that uses `is TwSpace` or `is TwColor` checks
- Debugging confusion where DevTools shows `double` instead of `TwSpace`
- Serialization code that attempts to encode/decode based on runtime type

**Phase to address:**
Phase 1 (Token Design) -- inform the decision of where to use extension types vs. classes.

**Confidence:** HIGH -- stated explicitly in Dart official docs: "At run time, there is absolutely no trace of the extension type."

---

### Pitfall 3: ThemeExtension lerp Null Handling and Missing-Extension Crashes

**What goes wrong:**
Flutter's `ThemeExtension<T>.lerp` signature is `ThemeExtension<T> lerp(covariant ThemeExtension<T>? other, double t)`. The `other` parameter can be null when one theme has the extension and another does not. The naive implementation `if (other is! TwColorTheme) return this;` causes:
1. Theme transitions that snap instead of animating (returns `this` at t=0.0 means no interpolation at all)
2. Runtime exceptions if you forget the null check entirely
3. If one theme defines `TwColorTheme` but the other doesn't, the extension silently vanishes during `lerp`

Additionally, Flutter issue #103313 documents that `Theme.of(context).extension<T>()` throws when the extension is missing. Issue #128871 documents extensions getting lost during theme transitions.

**Why it happens:**
ThemeExtension lerp is boilerplate-heavy (every field needs a lerp call), and the null-other edge case is non-obvious. With 7 ThemeExtension classes (colors, spacing, typography, radius, shadows, breakpoints, opacity), each with many fields, the surface area for lerp bugs is enormous.

**How to avoid:**
1. Implement proper three-way null handling in every lerp: `if (other == null) return this; if (this is null) return other;` plus field-by-field interpolation with null fallbacks.
2. Use `TwThemeData.maybeOf(context)` pattern and provide a non-null fallback (light defaults) so missing extensions never crash.
3. Write dedicated lerp tests for each ThemeExtension that verify: (a) lerp at t=0 returns this, (b) lerp at t=1 returns other, (c) lerp with null other returns this, (d) intermediate values interpolate correctly.
4. Consider a base class or mixin that standardizes lerp boilerplate across all 7 extensions.

**Warning signs:**
- Theme switch animations that snap instead of interpolating smoothly
- `Null check operator used on a null value` errors during theme changes
- Extensions resolving to null when accessed via `context.tw`

**Phase to address:**
Phase 2 (Theme Integration) -- must be thoroughly tested. This is the #1 source of runtime errors in ThemeExtension-based packages.

**Confidence:** HIGH -- verified via Flutter issues #103313, #128871, and official ThemeExtension API docs.

---

### Pitfall 4: Static Analysis is the Biggest Scoring Category (50 Points) -- One Warning Costs You

**What goes wrong:**
The "Pass static analysis" category is worth 50 of 160 pub.dev points -- nearly a third of the total. Unlike other categories which are binary (you have a README or you don't), static analysis points are deducted incrementally. The `provider` package (one of the most popular Flutter packages) scores only 40/50 in this category because of just TWO type-parameter naming lint issues. Two warnings. Ten points lost.

For a package with hundreds of `static const` declarations across 7 token files, plus ThemeExtension boilerplate with many lerp/copyWith methods, the surface area for lint warnings is enormous. A single missed `public_member_api_docs` warning on one of 242 color constants costs points.

**Why it happens:**
Pana runs `flutter analyze` with the standard `package:lints` rules. Any info/warning/error in the output deducts points. With 350+ public token constants, 7 ThemeExtension classes (each with ~30 fields), and dozens of extension methods, there are hundreds of opportunities for a lint rule to trigger.

**How to avoid:**
1. Use `very_good_analysis` (stricter than what pana checks) so if your code passes VGA, it definitely passes pana.
2. Enable `public_member_api_docs: true` in analysis_options.yaml and enforce zero warnings in CI.
3. Run `flutter analyze` in CI on every commit, not just before release.
4. Run `pana .` locally regularly during development (not just at publish time).

**Warning signs:**
- `flutter analyze` showing "info" level issues that you ignore because they're "just info"
- Missing dartdoc on even one public constant
- Type parameter naming that doesn't follow Dart conventions

**Phase to address:**
Phase 1 (Infrastructure) -- set up analysis_options.yaml with strict rules from day one. Never allow warnings to accumulate.

**Confidence:** HIGH -- verified against live pub.dev score pages. provider package shows 40/50 for static analysis with only 2 issues.

---

### Pitfall 5: Widget Extension Chaining Order Creates Unintuitive Nesting

**What goes wrong:**
Widget extensions like `.p(16).bg(Colors.blue).rounded(8)` read left-to-right but nest **outside-in**. Each extension wraps the previous result in a new parent widget. So `.bg(Colors.blue).p(16)` produces `Padding(child: DecoratedBox(child: originalWidget))` -- the padding is OUTSIDE the background. But CSS-trained developers (the target audience!) expect padding to be INSIDE the background. This is the opposite of Tailwind CSS where `bg-blue-500 p-4` means padding inside the blue background.

Concretely:
```dart
// This puts padding OUTSIDE the blue box (wrong for CSS mental model)
Text('Hello').bg(TwColors.blue500).p(16)

// This puts padding INSIDE the blue box (matches CSS expectation)
Text('Hello').p(16).bg(TwColors.blue500)
```

**Why it happens:**
Flutter's widget tree is inside-out compared to CSS's property model. In CSS, `padding` and `background-color` are properties on the same element. In Flutter, they are separate widgets wrapping each other. Extension methods cannot merge properties onto a single widget -- each one wraps in a new parent.

**How to avoid:**
1. Document the chaining order extensively with visual examples showing "what you expect vs. what you get."
2. In the README, establish a clear convention: "Chain from inside-out: content properties first (text styling), then inner decoration (padding, background, radius), then outer layout (margin, alignment)."
3. Consider whether the Tier 3 `TwStyle.apply()` pattern (which CAN merge padding + decoration onto a single Container) should be the recommended approach for complex styling, with Tier 2 extensions positioned as quick-and-dirty shortcuts.
4. Add dartdoc examples on every extension method showing correct ordering.

**Warning signs:**
- Users filing issues saying "padding is outside my background"
- Confusion from CSS/Tailwind developers about why results look different
- Reddit/StackOverflow complaints about unintuitive behavior

**Phase to address:**
Phase 3 (Widget Extensions) -- must have excellent documentation and examples. Also Phase 4 (TwStyle) as the recommended solution for complex cases.

**Confidence:** HIGH -- this is fundamental Flutter widget tree semantics, verified via Flutter official docs on Container painting order.

---

### Pitfall 6: Golden Test Brittleness Across Platforms and CI

**What goes wrong:**
Golden tests compare pixel-perfect snapshots. They break when:
1. Running on different OS (macOS vs. Linux CI) -- font rendering differs between platforms
2. Flutter SDK updates change anti-aliasing, text layout, or default fonts
3. Different display scale factors between developer machines and CI
4. System font availability differences (macOS has fonts Linux doesn't)

A package CI that generates goldens on macOS and runs on Linux CI will fail 100% of the time for any test involving text rendering.

**Why it happens:**
Font rasterization is platform-dependent. Flutter's test framework uses the Ahem font (squares only) as a default, but if you load custom fonts or rely on default Material fonts, rendering varies. Shadow rendering, anti-aliasing algorithms, and subpixel positioning all differ across platforms.

**How to avoid:**
1. Use the Ahem font (Flutter test default) for CI golden tests -- it renders identically everywhere.
2. For visual documentation goldens (showing actual styled output), generate on a single platform and commit the files. Run those goldens only on that platform.
3. Set explicit `devicePixelRatio` in test setup: `tester.binding.window.devicePixelRatioTestValue = 1.0`.
4. Bundle a custom font (e.g., Roboto) in the test assets and load it explicitly rather than relying on system fonts.
5. Consider using the `alchemist` package which separates CI goldens (Ahem, platform-independent) from local goldens (real fonts, platform-specific).
6. Add tolerance to golden comparisons if exact pixel matching is too brittle: implement a custom `GoldenFileComparator` with a threshold.

**Warning signs:**
- Goldens pass locally but fail on CI (or vice versa)
- Goldens break after every Flutter SDK update
- PR diffs full of golden file updates that are just rendering differences, not actual bugs

**Phase to address:**
Phase 5 (Testing Infrastructure) -- set up the golden test strategy early. Retroactively fixing golden test infrastructure is painful.

**Confidence:** HIGH -- verified via multiple Flutter community sources and the Alchemist package documentation.

---

### Pitfall 7: VelocityX's .make() Footgun -- and How .apply() Could Repeat It

**What goes wrong:**
VelocityX requires `.make()` to terminate builder chains: `"text".text.xl4.center.make()`. Forgetting `.make()` silently returns a builder object, not a widget. The app compiles, renders nothing (or crashes at runtime), and the error message gives no hint about the missing `.make()`. This is the single most-complained-about VelocityX API issue.

The PRD's `TwStyle.apply(child:)` terminal method has a similar risk: if a developer defines a `TwStyle` but forgets `.apply()`, they pass a `TwStyle` object where a `Widget` is expected. Fortunately, Dart's type system catches this (TwStyle is not a Widget), but the error message `The argument type 'TwStyle' can't be assigned to the parameter type 'Widget'` is confusing for users who expected a widget.

**Why it happens:**
Builder patterns with required terminal operations are inherently footgun-prone. The longer the builder chain, the easier it is to forget the terminal call. VelocityX compounds this by making builder objects that look like they should be widgets.

**How to avoid:**
1. `TwStyle` must NOT implement or extend `Widget` -- the type system must catch forgotten `.apply()` at compile time. This is already in the PRD design, which is correct.
2. Provide clear analyzer error messages via dartdoc: `/// Remember to call .apply(child: widget) to render this style.`
3. Consider a companion lint rule (v2) that warns when a `TwStyle` is constructed but never applied.
4. In documentation, always show `.apply()` in every example -- never show a TwStyle without its terminal application.

**Warning signs:**
- Users asking "why does my TwStyle not render anything?"
- Issues about confusing error messages when TwStyle is used where Widget is expected

**Phase to address:**
Phase 4 (Style Composition) -- API design decision. Phase 6 (Documentation) -- ensure all examples show terminal .apply().

**Confidence:** HIGH -- VelocityX's .make() issues are well-documented in GitHub issues and community discussions.

---

### Pitfall 8: Mix's Learning Curve Trap -- Inventing a DSL Nobody Learns

**What goes wrong:**
Mix requires learning a custom DSL: `$box.color.purple()`, `$text.style.bold()`, annotations, generated code. It is powerful but the learning curve is steep enough that adoption suffers. Developers who already know Flutter's widget model must learn an entirely new abstraction layer. The result: impressive demos, low adoption.

tailwind_flutter could fall into the same trap if the three-tier API adds cognitive overhead instead of reducing it. If Tier 3 (TwStyle + variants + resolve + apply) becomes its own mini-framework that developers must study before being productive, the package fails its core value proposition of "reducing boilerplate."

**Why it happens:**
Package authors confuse expressiveness with usability. The API that makes the demo look impressive is not always the API developers want to learn. Flutter developers have already invested in learning the widget model -- they resist replacing it.

**How to avoid:**
1. Enforce progressive disclosure rigorously: Tier 1 (raw tokens) must be usable in 30 seconds with zero learning. Tier 2 (extensions) in 5 minutes. Tier 3 (TwStyle) only when complexity demands it.
2. A developer should NEVER need Tier 3 to get value from the package. If they only ever use `TwColors.blue500` and `TwSpace.s4`, that is a success.
3. Keep Tier 2 extensions dead simple: one method = one wrapper widget. No hidden state, no builder chains, no required terminal calls.
4. Avoid inventing new vocabulary. Use Tailwind naming that web developers already know. Use Flutter patterns that Flutter developers already know. The package is a bridge, not a destination.

**Warning signs:**
- README requires more than 2 minutes to reach "first working example"
- Users need to understand TwStyle before they can use basic tokens
- GitHub issues asking "what does resolve() do?" or "when do I use apply vs extensions?"

**Phase to address:**
Every phase, but especially Phase 6 (Documentation) -- the README's quick-start must demonstrate Tier 1 in 3 lines, Tier 2 in 5 lines, and position Tier 3 as "advanced."

**Confidence:** MEDIUM -- based on community sentiment about Mix, not direct usage data.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Skipping lerp implementation (returning `this` for all interpolation) | Faster dev, fewer fields to handle | Theme transitions snap instead of animating; looks broken with AnimatedTheme | Never for a theming package -- lerp is table stakes |
| Using `Container` in widget extensions instead of specific widgets (Padding, DecoratedBox, etc.) | Less code per extension method | Performance penalty (Container decomposes into multiple widgets internally), harder to test, masks what is actually being added to the tree | Never -- use specific widgets |
| Hardcoding hex values instead of referencing Tailwind source | Faster initial token generation | Drift from upstream when Tailwind v4 updates colors (it has already changed values between v3 and v4) | Only if you also build a verification script that checks against Tailwind source |
| Putting all ThemeExtension classes in one file | Fewer files to manage | 2000+ line file, merge conflicts, slower IDE navigation | Never -- one extension per file, barrel export |
| Not testing copyWith for all fields | Faster test suite | A missed field in copyWith means theme customization silently fails for that token | Never |

---

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Widget extension chaining creating deep widget trees | Each `.p().bg().rounded().shadow()` chain adds 4 wrapper widgets. 10 styled widgets on screen = 40 extra widgets in the tree. | Document that heavy styling should use TwStyle.apply() which merges into fewer Container/DecoratedBox widgets. Profile in DevTools. | Noticeable jank at ~50+ chained-extension widgets visible simultaneously, especially on low-end Android |
| ThemeExtension lookup on every build | `context.tw.colors.blue500` calls `Theme.of(context).extension<TwColorTheme>()!` which walks the InheritedWidget tree and does a map lookup every time | Cache ThemeExtension lookups in `didChangeDependencies` when accessed frequently. Document this pattern for consumers. | Hundreds of widgets accessing `context.tw` in tight lists/grids |
| Large const token maps preventing tree-shaking | If tokens are organized in `Map<String, Color>` for programmatic access, the entire map is retained even if only one color is used | Use individual `static const` fields, not maps. Let tree-shaking remove unused fields. | Matters primarily for Flutter web where bundle size is critical |
| Color.lerp called for 242 colors in ThemeExtension.lerp | lerp is called on every frame during theme transitions; lerping all 242 colors is wasteful if most are unchanged | Only lerp colors that differ (compare first, lerp if different). Or accept the cost since Color.lerp is cheap. Profile before optimizing. | Only if theme transitions feel sluggish on low-end devices |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| MaterialApp ThemeData | Adding TwThemeData as a single extension instead of individual ThemeExtensions | Each token category (colors, spacing, etc.) must be a separate `ThemeExtension` registered individually in `ThemeData.extensions`. `TwTheme` widget should handle this registration automatically. |
| Existing ThemeData | Overriding user's existing ThemeExtensions when TwTheme wraps MaterialApp | Merge with existing extensions, don't replace. `TwTheme` should read current `Theme.of(context).extensions` and add/merge, not clobber. |
| Dark mode | Assuming brightness detection only happens via `MediaQuery.platformBrightness` | Support both `MediaQuery.platformBrightness` AND manual brightness override via `ThemeData.brightness`. Some apps use `ThemeMode.system`, others hardcode. |
| AnimatedTheme | forgetting that lerp is called during theme transitions, producing intermediate nonsense values | Ensure all lerp implementations produce visually sensible intermediate states, not just mathematically correct ones |

---

## API Design Pitfalls (Competitor Lessons)

| Pitfall | Package | Impact | Lesson for tailwind_flutter |
|---------|---------|--------|-----------------------------|
| Terminal `.make()` required but easy to forget | VelocityX | Silent failures, no widget rendered, confusing runtime errors | Ensure `TwStyle` is NOT a Widget subtype so forgetting `.apply()` is a compile-time error |
| Inconsistent API: some things are getters, some are methods, some need context | VelocityX | `.text .xl4 .center` (no parens) vs `.makeCentered()` (parens) vs `.whHalf(context)` (needs context) -- chaotic | Consistent API: all extensions are methods with parens, context only needed for theme-resolved values |
| Custom DSL that replaces Flutter patterns | Mix | High learning curve, developers must learn `$box.color.purple()` syntax | Use standard Dart/Flutter patterns. Extension methods on Widget, not a custom DSL. |
| Code generation required for consumers | Mix (mix_annotations) | Build_runner setup friction, slower builds, magic that is hard to debug | Zero codegen for consumers. Ship pre-generated tokens. |
| Kitchen-sink scope (state management + routing + styling) | VelocityX | Too broad, every release risks breaking unrelated features | Strict scope: tokens + extensions + styles. No state management, no routing, no components. |
| Unmaintained after initial release | styled_widget | Last update 2022, broken on newer Flutter versions, users stranded | Plan for maintenance: CI on Flutter stable + beta channels, fast response to breaking changes |

---

## "Looks Done But Isn't" Checklist

- [ ] **Extension types:** Verify they work as function arguments where `double`/`Color` is expected -- `implements` must be tested with real Flutter APIs (e.g., `EdgeInsets.all(TwSpace.s4)`)
- [ ] **ThemeExtension.lerp:** Test with null other, test at t=0, t=0.5, t=1.0, test that ALL fields interpolate (not just the first few)
- [ ] **ThemeExtension.copyWith:** Test that overriding ONE field preserves ALL other fields (easy to have a copy-paste bug where field N copies from field N-1)
- [ ] **Dark mode:** Test that dark theme actually uses different values, not just copies of light theme. Verify `context.tw` resolves correctly after brightness change.
- [ ] **Widget extensions:** Test that chaining order matches documentation examples. Verify each extension produces the correct single wrapper widget (not accidentally a Container).
- [ ] **pub.dev readiness:** Run `pana .` locally. Target 160/160 points. The 50-point static analysis category is the highest-value and most fragile -- zero warnings required.
- [ ] **Example app:** Must actually run on all 6 platforms listed in pubspec. "Supports all platforms" without a tested example is a lie that pub.dev will catch.
- [ ] **API documentation:** "80% dartdoc coverage" means 80% of PUBLIC members, not 80% of all members. Verify with `dart doc --validate-links`.
- [ ] **Token accuracy:** Every hex value must match Tailwind v4 source. Spot-checking is not enough -- automate comparison against the Tailwind CSS source files.
- [ ] **Extension method conflicts:** If a consumer imports both tailwind_flutter and another package that adds `.p()` on Widget, Dart's extension resolution fails with ambiguity. Test this scenario.

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Extension type const confusion | MEDIUM | Add static const EdgeInsets helpers alongside extension type getters. Non-breaking addition. |
| ThemeExtension lerp bugs (snapping transitions) | LOW | Fix lerp implementations, add tests. No API change needed. |
| Static analysis point deductions | LOW | Fix lint warnings, re-publish. Immediate score recovery. |
| Widget extension order confusion | HIGH | Cannot fix without breaking API or adding a confusing secondary API. Must document extensively instead. |
| VelocityX-style terminal method confusion | LOW | Already prevented by type system design (TwStyle is not Widget). Just improve error messages and docs. |
| Deep widget tree performance | MEDIUM | Offer TwStyle.apply() as the performant alternative. Cannot change extension method behavior without breaking. |
| Golden test failures in CI | MEDIUM | Switch to Ahem font for CI, separate platform-specific goldens. One-time infrastructure change. |
| Learning curve too steep | HIGH | Requires restructuring docs and possibly simplifying Tier 3 API. Hard to fix after users adopt the complex API. |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Extension type const limitations | Phase 1 (Tokens) | Write a test that attempts `const x = TwSpace.s4.all` and verify it fails with a clear comment explaining why |
| Extension type runtime erasure | Phase 1 (Tokens) | Write tests confirming `is TwSpace` matches any double, document this in dartdoc |
| ThemeExtension lerp null handling | Phase 2 (Theme) | Dedicated lerp test suite for every ThemeExtension, including null-other cases |
| Static analysis 50pt category | Phase 1 (Infrastructure) | Set up analysis_options.yaml with VGA + public_member_api_docs, enforce zero warnings in CI from day one |
| Widget extension chain ordering | Phase 3 (Extensions) | Visual documentation with "Expected vs. Actual" examples, integration tests for common orderings |
| Golden test brittleness | Phase 5 (Testing) | CI runs goldens with Ahem font, local goldens with real fonts, both are committed |
| Terminal .apply() confusion | Phase 4 (Styles) | Type system prevents misuse; add dartdoc example to TwStyle showing .apply() |
| Learning curve / progressive disclosure | Phase 6 (Docs) | README user-test: can a Flutter dev use Tier 1 in under 1 minute? |
| Widget tree depth from extensions | Phase 3 (Extensions) | Profile a screen with 20 chained-extension widgets, document the overhead |
| ThemeExtension copyWith field bugs | Phase 2 (Theme) | Parameterized tests that override each field individually and verify all others unchanged |
| Token accuracy vs Tailwind source | Phase 1 (Tokens) | Automated script that parses Tailwind CSS source and compares against Dart const values |
| Extension method name conflicts | Phase 3 (Extensions) | Test importing tailwind_flutter alongside velocity_x and styled_widget to verify resolution |

---

## Sources

- [Dart official extension types documentation](https://dart.dev/language/extension-types) -- runtime erasure, implements restrictions, const limitations
- [Dart SDK issue #56148](https://github.com/dart-lang/sdk/issues/56148) -- extension type methods in const expressions disagreement between VM and analyzer
- [Flutter issue #103313](https://github.com/flutter/flutter/issues/103313) -- ThemeExtension null crash on theme access
- [Flutter issue #128871](https://github.com/flutter/flutter/issues/128871) -- ThemeExtensions lost during tree navigation
- [pub.dev scoring help page](https://pub.dev/help/scoring) -- official scoring categories
- [pub.dev provider score page](https://pub.dev/packages/provider/score) -- 150/160, lost 10pts in static analysis for 2 lint issues
- [pub.dev getter score page](https://pub.dev/packages/getter/score) -- 140/160, detailed category breakdown confirming 30+20+20+50+40=160
- [pana issue #975](https://github.com/dart-lang/pana/issues/975) -- historical context (2021: max was 130), scoring system since updated to 160
- [Niku comparison to VelocityX](https://niku.saltyaom.com/velocity-x) -- VelocityX API inconsistencies documented
- [VelocityX issue #112](https://github.com/iampawan/VelocityX/issues/112) -- .make() crash issues
- [Alchemist golden test tool](https://github.com/Betterment/alchemist) -- CI vs local golden separation pattern
- [Flutter golden test tolerance guide](https://medium.com/mobilepeople/how-to-add-difference-tolerance-to-golden-tests-on-flutter-2d899c8baad2) -- platform-specific rendering differences
- [Very Good Ventures: Mastering ThemeExtension](https://www.verygood.ventures/blog/mastering-scalable-theming-for-custom-widgets) -- ThemeExtension boilerplate and lerp pitfalls
- [Stream deep dive into pub.dev](https://getstream.io/blog/deep-dive-pub-dev/) -- pub.dev scoring details
- [Dart blog on Dart 3.3](https://blog.dart.dev/dart-3-3-325bf2bf6c13) -- extension types introduction and design intent
- [Dart language issue #2776](https://github.com/dart-lang/language/issues/2776) -- const parameters and type parameters limitations

---
*Pitfalls research for: Flutter design token / utility styling package*
*Researched: 2026-03-11*
