# Feature Landscape

**Domain:** Flutter design token / utility-first styling package
**Researched:** 2026-03-11
**Overall confidence:** HIGH

## Competitive Context

Before mapping features, here is the landscape `tailwind_flutter` enters:

| Package | Pub Score | Likes | Weekly DLs | Approach | Key Weakness |
|---------|-----------|-------|------------|----------|--------------|
| **Mix** | 140 | 405 | 27.1k | Full design system framework, Spec/Styler DSL, code-gen | Steep learning curve, custom DSL, requires `build_runner` |
| **VelocityX** | 150 | 1.47k | High | Kitchen-sink framework (state mgmt, routing, UI) | `.make()` footgun, 6 external deps, scope creep |
| **styled_widget** | 130 | 912 | 8.1k | Widget extension chaining only | Unmaintained (last update Nov 2022), no tokens, no theme |
| **Niku** | 130 | 68 | 536 | Cascade notation property builder | Niche adoption, no design tokens |
| **tailwind_cli** | 135 | 34 | 294 | Code-gen CLI, custom widgets | `.render()` terminal method, early stage |
| **flutter_twind** | 160 | 3 | 207 | String-based className parsing | Stringly-typed (no compile-time safety), tiny adoption |
| **tailwind_standards** | 150 | 28 | 61 | Color/size/weight constants + TText widget | Minimal scope, string-based TText classes |

**The gap:** No package combines (1) complete Tailwind v4 token parity, (2) idiomatic Dart type safety, (3) Flutter ThemeExtension integration, and (4) a layered API with progressive disclosure -- all with zero external dependencies.

---

## Table Stakes

Features users expect from any Flutter styling/design-token package. Missing any of these and users will not adopt.

| # | Feature | Why Expected | Complexity | Confidence | Notes |
|---|---------|-------------|------------|------------|-------|
| TS-1 | **Complete color palette** | Every competitor provides colors. Tailwind's 22-family palette is the baseline expectation for a Tailwind-branded package. Partial palettes feel amateur. | Medium | HIGH | 242 colors + black/white/transparent. All competitors have some color system. Mix has theming, VelocityX has direct colors, tailwind_standards has full palette. |
| TS-2 | **Spacing scale** | Spacing is the single most-used design token. Every competitor offers spacing utilities. Without it, the package has no practical value for layout work. | Low | HIGH | 37 values, 4px base unit. VelocityX has `.p16`-style shortcuts, Mix has `$box.padding()`. |
| TS-3 | **Typography scale** (font sizes, weights, line heights, letter spacing) | Typography is the second-most-used token category. Users expect at minimum font sizes and weights. | Medium | HIGH | 13 sizes with paired line-heights, 9 weights, 6 letter spacing values, 6 line height ratios. Mix has TextSpec, VelocityX has `.text.xl4.bold`. |
| TS-4 | **Border radius scale** | Rounded corners are ubiquitous in modern UI. Every competitor offers this. | Low | HIGH | 10 values from none to full. |
| TS-5 | **Box shadow presets** | Elevation/shadow is a core visual layer. Material has elevation, Tailwind has shadow scale. | Low | HIGH | 7 levels + inner + none. Convert CSS box-shadow to Flutter's `BoxShadow`. |
| TS-6 | **Widget extension methods** (padding, background, rounded, opacity, shadow, sizing) | This is the DX that sells the package. styled_widget proved the market for chaining. VelocityX built its entire brand on it. Without `.p()`, `.bg()`, `.rounded()`, the package is just a constants file. | Medium | HIGH | Must cover: padding (p/px/py/pt/pb/pl/pr), margin, bg, rounded, opacity, shadow, width/height/size, center/align, clip. |
| TS-7 | **Text-specific extensions** (bold, italic, fontSize, textColor) | Text styling is the highest-frequency styling operation. Both VelocityX and styled_widget offer text-specific chaining. | Low | HIGH | Extensions on `Text` widget, not just generic `Widget`. |
| TS-8 | **Dark mode support** | Standard expectation in 2026. Every non-trivial Flutter app ships light + dark themes. A design token package without dark mode is incomplete. | Medium | HIGH | Mix has `.onDark()` variant. Flutter's `ThemeData` has `darkTheme`. Must integrate with platform brightness. |
| TS-9 | **ThemeData integration** | Flutter developers already use `ThemeData`. A token package that fights it will not be adopted. Must enhance, not replace. | Medium | HIGH | `ThemeExtension<T>` is the standard mechanism. Provides `copyWith` and `lerp` for free. Mix uses its own `MixTheme` instead. |
| TS-10 | **Const token values** | Performance-conscious Flutter developers expect compile-time constants. Tokens that allocate at runtime lose to hand-written `const Color(0xFF...)` values. | Low | HIGH | Extension types (Dart 3.3) compile to literal values. Zero runtime cost. This is a unique advantage over competitors that use class instances. |
| TS-11 | **Zero external dependencies** | Dependency-free packages have lower adoption friction and fewer version conflicts. VelocityX's 6 deps are a pain point. | Low | HIGH | Flutter SDK only. No `meta`, no `build_runner`, no nothing. |
| TS-12 | **Comprehensive documentation** | pub.dev scores penalize poor docs. Users evaluating packages check dartdoc coverage, README quality, and examples before adopting. | Medium | HIGH | 80%+ dartdoc coverage, README with quick-start, API overview, comparison. |
| TS-13 | **Example app** | pub.dev requires `example/` for full score. Users want to see the package in action before committing. | Low | HIGH | Single showcase app demonstrating all three tiers. |
| TS-14 | **Opacity scale** | Standard Tailwind token. Used for overlays, disabled states, hover effects. | Low | HIGH | 21 values (0, 5, 10, 15...95, 100). |

---

## Differentiators

Features that set `tailwind_flutter` apart from competitors. Not expected by default, but create competitive advantage.

| # | Feature | Value Proposition | Complexity | Confidence | Notes |
|---|---------|-------------------|------------|------------|-------|
| D-1 | **Three-tier layered API with progressive disclosure** | No competitor offers this. Mix forces you into its full DSL. VelocityX is all-or-nothing. tailwind_flutter lets you adopt one `TwColors.blue500` constant today and grow into full style composition later. Reduces adoption risk to zero. | High | HIGH | Tier 1 (tokens) -> Tier 2 (extensions) -> Tier 3 (styles). Each tier is independently useful. This is the single biggest differentiator. |
| D-2 | **Extension types for zero-cost token abstraction** | No competitor uses Dart 3.3 extension types. `TwSpace implements double` means tokens work everywhere a `double` is expected -- no `.value` extraction, no wrapper allocation, compiles to literals. Performance-equivalent to hand-written constants but with type safety. | Medium | HIGH | Dart 3.3+ requirement. Verified: extension types are zero-cost at runtime per official Dart docs. |
| D-3 | **Explicit `.apply()` terminal method** (vs VelocityX's `.make()`) | VelocityX's `.make()` is a documented footgun -- forgetting it produces no widget and no compile error (GitHub Issue #112). `.apply()` on `TwStyle` is an explicit rendering step that can't be silently omitted because TwStyle is not a Widget. | Low | HIGH | Addressing a known competitor weakness directly. |
| D-4 | **TwStyle composable style objects with variant support** | Reusable, mergeable, context-aware style definitions. Define once, use everywhere. Mix has this via Spec/Styler but requires code generation. tailwind_flutter achieves it with plain Dart -- no `build_runner`. | High | HIGH | `TwStyle.merge()`, `TwStyle.resolve(context)`, variant map. styled_widget has zero style reuse. VelocityX has none. |
| D-5 | **Complete Tailwind v4 token parity** | No Flutter package offers full Tailwind v4 parity. `tailwind_standards` comes closest with colors but lacks spacing/typography/radius/shadows. Being the canonical Tailwind-for-Flutter package creates strong positioning. | Medium | HIGH | 22 color families x 11 shades, 37 spacing values, 13 font sizes, 10 radii, 7 shadow levels, 21 opacity values, 5 breakpoints. |
| D-6 | **EdgeInsets convenience getters on spacing tokens** | `TwSpace.s4.all` returns `EdgeInsets.all(16)` directly. Eliminates the `EdgeInsets.all(TwSpace.s4)` boilerplate that every other token package requires. Small DX win with outsized ergonomic impact. | Low | HIGH | `.all`, `.x`, `.y`, `.top`, `.bottom`, `.left`, `.right` getters. |
| D-7 | **`context.tw` unified accessor** | Single entry point: `context.tw.colors.blue500`, `context.tw.spacing.s4`. Discoverability is excellent -- autocomplete shows all token categories. Mix uses `MixTheme.of(context)` which is less ergonomic. | Low | HIGH | `BuildContext` extension returning `TwThemeData`. Includes `maybeOf` for null safety. |
| D-8 | **Light and dark theme presets out of the box** | `TwThemeData.light()` and `TwThemeData.dark()` -- zero config to get started. Mix requires manual `MixThemeData` setup. Reduces time-to-first-styled-widget to under 60 seconds. | Medium | MEDIUM | Defaults based on Tailwind v4's color recommendations. Users can `copyWith` to customize. |
| D-9 | **Animated theme transitions via `lerp`** | `ThemeExtension<T>.lerp()` enables smooth animated transitions when switching themes. Material does this, but most third-party token packages skip `lerp` implementation. | Medium | MEDIUM | All token ThemeExtensions must implement `lerp` correctly. |
| D-10 | **Incremental adoption -- works alongside Material/Cupertino** | One `TwColors.blue500` in an existing MaterialApp works immediately. No wrapper widget required for Tier 1. No migration cost. VelocityX requires learning its entire framework. Mix requires `MixTheme` wrapper. | Low | HIGH | This is an adoption strategy, not a feature -- but it manifests as a technical capability (no required root widget for basic usage). |

---

## Anti-Features

Features to explicitly NOT build. These are traps that competitors fell into or that would dilute the package's focus.

| # | Anti-Feature | Why Avoid | What to Do Instead |
|---|-------------|-----------|-------------------|
| AF-1 | **Component library** (buttons, cards, modals, navigation bars) | VelocityX went down this path and became a kitchen-sink framework with 6 dependencies. Mix went further with full design system components requiring code generation. Components belong in separate packages that DEPEND on token packages, not inside them. Scope creep is how packages die. | Provide tokens and utilities that make building components trivial. Let the community (or a separate `tailwind_flutter_ui` package) handle components. |
| AF-2 | **String-based class parsing** (`"bg-blue-500 p-4"`) | `flutter_twind` and `fluttersdk_wind` use this approach. It throws away Dart's type system entirely. No autocomplete, no compile-time errors, runtime string parsing overhead. This is CSS-in-Dart, which the project explicitly rejects. | Always typed Dart: `TwColors.blue500`, not `"blue-500"`. |
| AF-3 | **State management integration** | VelocityX bundles `vxstate`. State management is a solved, opinionated domain. Coupling styling to state management alienates users who use Riverpod/Bloc/Provider. | Zero opinion on state management. Tokens are just values. |
| AF-4 | **Layout utilities** (VStack, HStack, grid) | VelocityX provides `VStack`/`HStack`/`ZStack`. Flutter already has `Row`/`Column`/`Stack`/`Flex`/`Expanded`/`Wrap`. Reimplementing these adds surface area without adding value and confuses new developers who learn non-standard widget names. | Use Flutter's built-in layout widgets. |
| AF-5 | **Navigation / routing** | VelocityX includes navigation. This has nothing to do with styling. | Out of scope. Period. |
| AF-6 | **Required `build_runner` / code generation for consumers** | Mix requires `dart run build_runner build` for custom Specs. This is a significant adoption barrier -- slower builds, more dependencies, configuration overhead. | Ship pre-generated tokens. The package consumer never runs `build_runner`. |
| AF-7 | **Custom DSL that replaces Flutter idioms** | Mix's `$box.color.purple()` and `$text.style.fontSize(16)` is a new language to learn. It's powerful but creates a learning cliff. | Use standard Flutter types (`Color`, `EdgeInsets`, `TextStyle`, `BoxShadow`). Extension methods add convenience without replacing knowledge. |
| AF-8 | **`.make()` / `.render()` terminal methods on widget chains** | VelocityX's `.make()` is a silent footgun -- forgetting it compiles fine but renders nothing. `tailwind_cli`'s `.render()` has the same problem. | Widget extensions return `Widget` directly. Only `TwStyle.apply()` has a terminal step, and `TwStyle` is not a `Widget` so the mistake is type-system-enforced. |
| AF-9 | **Dart macros** | Paused indefinitely by the Dart team as of Jan 2025. Building on macros means building on vapor. | Use extension types (stable in Dart 3.3) and standard `ThemeExtension<T>`. |
| AF-10 | **Swiper, Toast, Rating, Stepper, and other "Super VX" utilities** | VelocityX includes animated carousels, toast notifications, rating widgets, and steppers. These are unrelated to styling tokens and inflate package scope. | Styling primitives only. Composition-enabling, not feature-accumulating. |

---

## Feature Dependencies

```
Tier 1: Design Tokens (no dependencies)
  TwColors ─────────────────┐
  TwSpace ──────────────────┤
  TwFontSize/Weight/etc ────┤
  TwRadius ─────────────────┼──> ThemeExtension<T> classes ──> TwThemeData
  TwShadows ────────────────┤                                      │
  TwOpacity ────────────────┤                                      │
  TwBreakpoint ─────────────┘                                      │
                                                                   v
Tier 2: Widget Extensions (depends on Tier 1 types)            TwTheme widget
  .p() / .px() / .bg() / .rounded() etc ────────┐                 │
  .bold() / .fontSize() / .textColor() etc ──────┤                 │
  context.tw accessor ───────────────────────────┘                 │
                                                                   │
Tier 3: Style Composition (depends on Tier 1 + TwThemeData)        │
  TwStyle ──────────> TwStyle.merge() ─────────┐                   │
  TwVariant ────────> TwStyle.resolve(ctx) ────┼──> TwStyle.apply()│
                                               │                   │
                                               └───────────────────┘

V2 features (deferred):
  Responsive variants ──> depends on TwBreakpoint + MediaQuery
  Hover/press variants ──> depends on TwVariant + gesture detection
  Animated styles ──> depends on TwStyle + implicit animation controller
  Lint rules ──> companion package, depends on stable public API
```

---

## MVP Recommendation

### Must ship (V1 -- all table stakes + key differentiators):

1. **Tier 1: All design tokens** (TS-1 through TS-6, TS-10, TS-14) -- This is the foundation. Without complete tokens, nothing else works. Relatively mechanical work.
2. **ThemeExtension integration + TwTheme + context.tw** (TS-9, D-7, D-8) -- Makes tokens theme-aware and accessible via context. Critical for dark mode (TS-8).
3. **Tier 2: Widget extensions** (TS-7, TS-6) -- The DX selling point. This is what users will show in tweets and blog posts.
4. **Tier 3: TwStyle + variants** (D-3, D-4) -- The "why not just use styled_widget?" answer. Style reuse and composition is the power-user tier.
5. **Infrastructure** (TS-11, TS-12, TS-13) -- 160/160 pub.dev score, example app, tests, CI.

### Defer to V2:

- **Responsive variants** (`TwVariant.sm()`, `.md()`, etc.): Adds MediaQuery dependency to style resolution. Valuable but not MVP-blocking. Complexity: High.
- **Hover/press interaction variants**: Desktop/web-specific. Requires GestureDetector/MouseRegion integration. Complexity: High.
- **Animated styles** (`TwAnimatedStyle`): Implicit animation support with duration/curve. Nice-to-have but significant complexity.
- **Companion lint package**: Requires stable public API first. Separate package.
- **Widgetbook catalog**: Separate example project for visual testing.
- **VS Code / Android Studio snippets**: Developer tooling, not core package.
- **Token generation CLI**: Automation for tracking upstream Tailwind releases.

### Defer indefinitely:

- **Component library** (AF-1): Separate package concern.
- **String-based parsing** (AF-2): Antithetical to project philosophy.
- **State/nav integration** (AF-3, AF-5): Out of scope forever.

---

## Sources

### Competitor Packages (pub.dev)
- [Mix](https://pub.dev/packages/mix) -- v1.7.0, 140 points, 405 likes, 27.1k weekly downloads
- [VelocityX](https://pub.dev/packages/velocity_x) -- v4.3.1, 150 points, 1.47k likes
- [styled_widget](https://pub.dev/packages/styled_widget) -- v0.4.1, 130 points, 912 likes, last updated Nov 2022
- [Niku](https://pub.dev/packages/niku) -- v2.4.3, 130 points, 68 likes
- [tailwind_cli](https://pub.dev/packages/tailwind_cli) -- v0.7.7, 135 points, 34 likes
- [flutter_twind](https://pub.dev/packages/flutter_twind) -- v0.4.2, 160 points, 3 likes
- [tailwind_standards](https://pub.dev/packages/tailwind_standards) -- v1.1.1, 150 points, 28 likes
- [fluttersdk_wind](https://pub.dev/packages/fluttersdk_wind) -- v0.0.4, 130 points, 4 likes

### Competitor Documentation
- [Mix Design Tokens Guide](https://www.fluttermix.com/docs/guides/design-token) -- MixTheme, MixThemeData, token categories
- [Mix Introduction](https://www.fluttermix.com/documentation/overview/introduction) -- Core concepts, Style/Variant system
- [Mix Widget Modifiers](https://www.fluttermix.com/documentation/guides/widget-modifiers) -- Modifier wrapping system
- [Mix Creating a Widget Tutorial](https://www.fluttermix.com/documentation/tutorials/creating-a-widget) -- Spec/Styler code-gen pattern
- [VelocityX GitHub](https://github.com/iampawan/VelocityX) -- Issues including [#112 .make() crash](https://github.com/iampawan/VelocityX/issues/112)
- [styled_widget GitHub](https://github.com/ReinBentdal/styled_widget) -- 1.3k stars, 20 open issues, unmaintained
- [Niku vs VelocityX comparison](https://niku.saltyaom.com/velocity-x) -- Documented VelocityX API inconsistencies

### Flutter Platform
- [ThemeExtension pattern](https://docs.flutter.dev/cookbook/design/themes) -- Official Flutter theming docs
- [Dart Extension Types](https://dart.dev/language/extension-types) -- Zero-cost abstraction spec
- [Dart 3.3 announcement](https://blog.dart.dev/dart-3-3-325bf2bf6c13) -- Extension types feature
- [Flutter const performance](https://dev.to/pedromassango/flutter-performance-tips-1-const-constructors-4j41) -- Compile-time constant benefits
- [Widget tree depth performance](https://github.com/flutter/flutter/issues/94585) -- Nesting performance implications

### Tailwind CSS
- [Tailwind CSS v4.0 announcement](https://tailwindcss.com/blog/tailwindcss-v4) -- Design tokens as CSS variables, @theme block
- [Tailwind v4 design tokens guide](https://medium.com/@sureshdotariya/tailwind-css-4-theme-the-future-of-design-tokens-at-2025-guide-48305a26af06) -- Token architecture

### Design Systems
- [Flutter ThemeExtension design tokens pattern](https://vibe-studio.ai/insights/creating-reusable-design-system-tokens-in-flutter-with-theme-extensions) -- Best practices
- [Building Flutter design systems](https://medium.com/@tiger.chirag/build-a-reusable-flutter-design-system-7d2ef7e004f6) -- Semantic tokens, CI golden tests
- [Builder pattern anti-pattern in widget trees](https://blog.flutterbountyhunters.com/the-builder-pattern-is-a-terrible-idea-for-your-widget-tree/) -- Why extension methods over builder pattern
