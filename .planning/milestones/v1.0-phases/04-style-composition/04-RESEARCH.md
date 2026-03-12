# Phase 4: Style Composition - Research

**Researched:** 2026-03-11
**Domain:** Immutable data classes, sealed class variants, widget tree composition, CSS box model mapping
**Confidence:** HIGH

## Summary

Phase 4 builds the "CSS class" equivalent for Flutter: an immutable `TwStyle` data class that holds 8 optional visual properties, supports right-side-wins merge semantics, resolves dark/light variants via `BuildContext`, and renders a correctly ordered widget tree via `.apply()`. The technical domain is well-understood -- it is pure Dart class design plus Flutter widget composition with no external dependencies, no tricky APIs, and no evolving ecosystem concerns.

The critical design decisions are all locked in CONTEXT.md. The implementation boils down to: (1) an `@immutable` class with 8 nullable final fields plus `copyWith`/`merge`/`apply`/`resolve`, (2) a `sealed class TwVariant` with exactly two subclasses, and (3) correct widget nesting order matching the CSS box model. All Flutter types involved (`EdgeInsets`, `BoxConstraints`, `BoxDecoration`, `DefaultTextStyle`, `Opacity`, etc.) are stable, well-documented, and unchanged for years.

**Primary recommendation:** Implement TwVariant first (tiny sealed class, no dependencies), then TwStyle (the bulk of the work), using manual `==`/`hashCode` with `Object.hash` and `listEquals` for shadow list comparison. No external packages needed.

<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions

- TwStyle holds exactly 8 optional properties: `padding`, `margin`, `backgroundColor`, `borderRadius`, `shadows`, `opacity`, `constraints`, `textStyle`
- No alignment or clip properties in TwStyle
- `padding` and `margin` typed as `EdgeInsets`
- `constraints` typed as `BoxConstraints`
- `textStyle` typed as `TextStyle`
- `TwStyle.merge()` uses right-side-wins for all properties including lists
- Shadows are replaced, not appended
- Null properties in right-side style are ignored (left-side values preserved)
- Variants defined via constructor parameter: `variants: {TwVariant.dark: TwStyle(...)}`
- Map type: `Map<TwVariant, TwStyle>`
- TwVariant is a sealed class with exactly two cases: `TwVariant.dark` and `TwVariant.light`
- Resolve returns base style when no variant matches current brightness
- Resolve merges base + matching variant (variant overrides only properties it defines)
- `.resolve(context)` checks platform brightness, returns flat TwStyle (no variants)
- Base style is the fallback
- `.apply()` on a style with variants uses base only (ignores variants without resolve)
- Widget tree order (outermost first): margin -> constraints -> opacity -> decoration -> padding -> textStyle -> child
- Null properties are skipped
- `backgroundColor`, `borderRadius`, and `shadows` merge into a single `DecoratedBox` with `BoxDecoration`
- `textStyle` wraps in `DefaultTextStyle` between padding and child
- TwStyledWidget dropped -- delete `tw_styled_widget.dart` stub file
- Remove commented export line for tw_styled_widget from barrel file
- Uncomment `tw_style.dart` and `tw_variant.dart` exports in barrel file

### Claude's Discretion

- Internal implementation of `.merge()` (copyWith pattern vs manual null-coalescing)
- `TwStyle.copyWith()` method signature and implementation
- Whether TwStyle implements `==`/`hashCode` manually or uses Dart records/equatable pattern
- Test organization and grouping strategy
- Dartdoc examples beyond the decided API patterns
- Exact DecoratedBox construction logic when only subset of bg/borderRadius/shadow are set

### Deferred Ideas (OUT OF SCOPE)

None -- discussion stayed within phase scope

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| STY-01 | `TwStyle` immutable data class with all visual properties | Immutable class pattern with 8 nullable final fields, `@immutable` annotation, manual `==`/`hashCode` |
| STY-02 | `TwStyle.merge()` for combining styles (right-side wins) | Null-coalescing pattern: `other.field ?? this.field` for each of 8 properties |
| STY-03 | `TwStyle.apply(child: widget)` to render styled widget with CSS box model order | Widget nesting from innermost out: child -> DefaultTextStyle -> Padding -> DecoratedBox -> Opacity -> ConstrainedBox -> Padding(margin). Verified against Flutter Container source |
| STY-04 | `TwVariant` sealed class with `dark`, `light` brightness variants | Dart sealed class (available since Dart 3.0, project uses >=3.3.0). Two final subclasses with factory constructors |
| STY-05 | `TwStyle.resolve(context)` to evaluate variant conditions and return flat style | `Theme.of(context).brightness` for detection, merge base + matching variant, return new TwStyle without variants map |

</phase_requirements>

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| flutter/widgets.dart | SDK | Widget types (Padding, Opacity, DecoratedBox, DefaultTextStyle, ConstrainedBox) | Framework primitives for `.apply()` widget tree |
| flutter/material.dart | SDK | `Theme.of(context).brightness` for variant resolution | Standard brightness detection via ThemeData |
| flutter/foundation.dart | SDK | `listEquals` for `List<BoxShadow>` equality, `@immutable` annotation | Built-in utilities, no external deps needed |

### Supporting

No additional packages required. Everything is in Flutter SDK.

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Manual `==`/`hashCode` | `equatable` package | Adds external dependency for a single class -- not worth it for 8 fields. Manual implementation is ~20 lines |
| Manual `copyWith` | `freezed` code generation | Massive overkill for one class, adds build_runner dependency, violates zero-dep philosophy |
| `MediaQuery.of(context).platformBrightness` | `Theme.of(context).brightness` | Theme.of respects app-level theme override (ThemeMode), while MediaQuery only reads OS setting. Theme.of is correct |

## Architecture Patterns

### Recommended Project Structure

```
lib/src/styles/
  tw_style.dart          # TwStyle immutable class (STY-01, STY-02, STY-03, STY-05)
  tw_variant.dart        # TwVariant sealed class (STY-04)
  [tw_styled_widget.dart -- DELETE]

test/src/styles/
  tw_style_test.dart     # Unit + widget tests for TwStyle
  tw_variant_test.dart   # Unit tests for TwVariant
```

### Pattern 1: Immutable Data Class with Manual Equality

**What:** `@immutable` class with all-final fields, const constructor, manual `==`/`hashCode`, `copyWith`, and domain methods
**When to use:** When you have a small number of fields (8) and no external dependency budget

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class TwStyle {
  const TwStyle({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
    this.opacity,
    this.constraints,
    this.textStyle,
    this.variants,
  });

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final double? opacity;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;
  final Map<TwVariant, TwStyle>? variants;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwStyle &&
          padding == other.padding &&
          margin == other.margin &&
          backgroundColor == other.backgroundColor &&
          borderRadius == other.borderRadius &&
          listEquals(shadows, other.shadows) &&
          opacity == other.opacity &&
          constraints == other.constraints &&
          textStyle == other.textStyle &&
          mapEquals(variants, other.variants);

  @override
  int get hashCode => Object.hash(
        padding,
        margin,
        backgroundColor,
        borderRadius,
        shadows != null ? Object.hashAll(shadows!) : null,
        opacity,
        constraints,
        textStyle,
        variants != null ? Object.hashAll(variants!.entries) : null,
      );
}
```

**Critical note on `listEquals` and `mapEquals`:** Both come from `package:flutter/foundation.dart`. `BoxShadow` extends `Shadow` which already implements `==`/`hashCode`, so `listEquals` works correctly for shadow comparison. `mapEquals` works for `Map<TwVariant, TwStyle>` because TwVariant subclasses will have correct equality (they're singletons via factory constructors) and TwStyle itself implements `==`.

### Pattern 2: Sealed Class with Exhaustive Switching

**What:** `sealed class TwVariant` with exactly two `final` subclasses, enabling exhaustive pattern matching
**When to use:** When you have a fixed, known set of variant types

```dart
sealed class TwVariant {
  const TwVariant._();

  static const dark = TwDarkVariant._();
  static const light = TwLightVariant._();

  bool matches(Brightness brightness);
}

final class TwDarkVariant extends TwVariant {
  const TwDarkVariant._() : super._();

  @override
  bool matches(Brightness brightness) => brightness == Brightness.dark;
}

final class TwLightVariant extends TwVariant {
  const TwLightVariant._() : super._();

  @override
  bool matches(Brightness brightness) => brightness == Brightness.light;
}
```

**Key design choices:**
- Private constructors with `static const` factory -- prevents user-created instances
- `final class` subclasses -- prevents further extension (no custom variants in v1)
- `matches(Brightness)` method -- encapsulates the brightness check logic
- Subclasses are `const` -- can be used as map keys and compared with `identical()`

### Pattern 3: Widget Tree Builder (CSS Box Model Order)

**What:** `.apply()` method that builds a widget tree from innermost to outermost, skipping null properties
**When to use:** Rendering a TwStyle onto a child widget

The decided order (outermost first): **margin -> constraints -> opacity -> decoration -> padding -> textStyle -> child**

In code, build from child outward:

```dart
Widget apply({required Widget child}) {
  Widget current = child;

  // 1. textStyle (innermost wrapper above child)
  if (textStyle != null) {
    current = DefaultTextStyle.merge(
      style: textStyle!,
      child: current,
    );
  }

  // 2. padding
  if (padding != null) {
    current = Padding(padding: padding!, child: current);
  }

  // 3. decoration (backgroundColor, borderRadius, shadows -> single DecoratedBox)
  if (backgroundColor != null || borderRadius != null || shadows != null) {
    current = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: current,
    );
  }

  // 4. opacity
  if (opacity != null) {
    current = Opacity(opacity: opacity!, child: current);
  }

  // 5. constraints
  if (constraints != null) {
    current = ConstrainedBox(constraints: constraints!, child: current);
  }

  // 6. margin (outermost)
  if (margin != null) {
    current = Padding(padding: margin!, child: current);
  }

  return current;
}
```

**Verified against Flutter's Container source:** Flutter's Container builds in this order (innermost to outermost): Align -> Padding -> ColoredBox -> ClipPath -> DecoratedBox -> foregroundDecoration -> ConstrainedBox -> Margin (Padding) -> Transform. Our TwStyle order is consistent: we skip Align/Clip/Transform (not in scope) and consolidate color+borderRadius+shadows into one DecoratedBox.

### Pattern 4: Merge with Right-Side-Wins

**What:** Null-coalescing merge where the right-side (other) style overrides only properties it explicitly sets
**When to use:** Style composition / cascade

```dart
TwStyle merge(TwStyle other) {
  return TwStyle(
    padding: other.padding ?? padding,
    margin: other.margin ?? margin,
    backgroundColor: other.backgroundColor ?? backgroundColor,
    borderRadius: other.borderRadius ?? borderRadius,
    shadows: other.shadows ?? shadows,
    opacity: other.opacity ?? opacity,
    constraints: other.constraints ?? constraints,
    textStyle: other.textStyle ?? textStyle,
    // variants are NOT merged -- merge produces a flat style
  );
}
```

**Important:** `merge` does NOT carry over variants from either side. It produces a flat style. This is consistent with the resolve-then-apply pattern: `baseStyle.merge(cardStyle)` yields a flat result, and variant resolution also strips variants.

### Pattern 5: Variant Resolution

**What:** `.resolve(context)` reads brightness, finds matching variant, merges it over base, returns flat style
**When to use:** Before `.apply()` when a style has dark/light variants

```dart
TwStyle resolve(BuildContext context) {
  if (variants == null || variants!.isEmpty) return this;

  final brightness = Theme.of(context).brightness;

  for (final entry in variants!.entries) {
    if (entry.key.matches(brightness)) {
      return _withoutVariants().merge(entry.value);
    }
  }

  return _withoutVariants();
}

TwStyle _withoutVariants() {
  if (variants == null) return this;
  return TwStyle(
    padding: padding,
    margin: margin,
    backgroundColor: backgroundColor,
    borderRadius: borderRadius,
    shadows: shadows,
    opacity: opacity,
    constraints: constraints,
    textStyle: textStyle,
    // no variants
  );
}
```

**Critical detail:** Uses `Theme.of(context).brightness`, NOT `MediaQuery.of(context).platformBrightness`. `Theme.of` respects the app's `ThemeMode` setting (user-toggled dark mode), while `MediaQuery` only reads the OS-level preference.

### Anti-Patterns to Avoid

- **Mutable TwStyle:** Never use non-final fields. The class is `@immutable` and will be used as map values and compared with `==`. Mutability would break everything.
- **Merging variants:** The `merge()` method must NOT attempt to merge variant maps from both sides. Variants are a property of a style definition, not a composable layer. Merging two variant maps creates ambiguity about precedence.
- **Using Container instead of individual widgets:** Container does too much and makes the widget tree harder to test. Build individual widgets (Padding, DecoratedBox, etc.) for precise control and testability.
- **DefaultTextStyle constructor instead of .merge:** Using `DefaultTextStyle(style: ...)` replaces the inherited text style entirely. Use `DefaultTextStyle.merge(style: ...)` so that the style composes with any ancestor DefaultTextStyle, matching how CSS cascading works.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| List equality for shadows | Manual loop comparison | `listEquals` from `foundation.dart` | Handles null, length, and element equality correctly |
| Map equality for variants | Manual iteration | `mapEquals` from `foundation.dart` | Same reasoning |
| Brightness detection | `MediaQuery.platformBrightness` | `Theme.of(context).brightness` | Respects app ThemeMode, not just OS preference |
| Text style inheritance | `DefaultTextStyle(style: ...)` constructor | `DefaultTextStyle.merge(style: ...)` | Merges with ancestor styles instead of replacing |
| Box model consolidation | Separate ColoredBox + ClipRRect + DecoratedBox | Single `DecoratedBox(decoration: BoxDecoration(...))` | One widget handles color + borderRadius + shadows together |

**Key insight:** The entire phase uses only Flutter SDK classes -- no external packages. The temptation to reach for equatable, freezed, or other codegen is strong but would add dependency weight for a single class with 8 fields.

## Common Pitfalls

### Pitfall 1: Wrong Widget Nesting Order
**What goes wrong:** Decoration appears outside constraints, or opacity clips the shadow, or margin ends up inside padding
**Why it happens:** Building widgets in the wrong order (outermost-first instead of innermost-first in code)
**How to avoid:** In the `.apply()` method, start with child and wrap outward. The first `if` wraps `textStyle` (innermost), the last `if` wraps `margin` (outermost). Test by checking parent-child widget relationships in widget tests.
**Warning signs:** Visual glitches in rendered output, widget tree inspection showing wrong nesting

### Pitfall 2: Forgetting to Strip Variants After Resolve
**What goes wrong:** `.resolve()` returns a TwStyle that still has a variants map, leading to infinite recursion or stale variant data
**Why it happens:** Using `merge` without first creating a variant-free copy of the base style
**How to avoid:** `resolve()` must return a `TwStyle` with `variants: null`. Use a `_withoutVariants()` helper that copies all properties except variants.
**Warning signs:** Stack overflow on `.resolve().resolve()` chaining, or variants persisting through merge chains

### Pitfall 3: DefaultTextStyle Replacement vs Merge
**What goes wrong:** Setting textStyle in `.apply()` using `DefaultTextStyle(style: ...)` overwrites any inherited text style from ancestors
**Why it happens:** Using the constructor instead of `.merge()`
**How to avoid:** Always use `DefaultTextStyle.merge(style: textStyle, child: current)` which composes with ancestor styles
**Warning signs:** Text losing its inherited theme style when wrapped in TwStyle.apply()

### Pitfall 4: Shadows Equality Comparison
**What goes wrong:** Two TwStyles with identical shadow lists are not considered equal
**Why it happens:** Dart `==` on `List` checks reference equality, not element equality
**How to avoid:** Use `listEquals(shadows, other.shadows)` from `foundation.dart` in the `==` operator
**Warning signs:** Style equality tests failing for styles with shadows

### Pitfall 5: DecoratedBox with Only Some Decoration Properties
**What goes wrong:** Wondering whether to use different widgets when only backgroundColor is set vs when all three (bg, borderRadius, shadows) are set
**Why it happens:** Over-optimization impulse
**How to avoid:** Always use a single `DecoratedBox(decoration: BoxDecoration(...))` regardless of which subset of bg/borderRadius/shadows is set. `BoxDecoration` handles null properties gracefully. This was explicitly decided in CONTEXT.md.
**Warning signs:** Multiple branching paths for different decoration combinations

### Pitfall 6: Variants Map Key Equality
**What goes wrong:** `TwVariant.dark` used as a map key doesn't match when looking up
**Why it happens:** If TwVariant subclasses aren't const singletons, each instance is a different object
**How to avoid:** Make TwVariant subclass instances `static const` singletons with private constructors. This ensures `identical()` works and they function correctly as map keys.
**Warning signs:** Variant resolution never finding matches despite correct brightness

## Code Examples

### Complete TwStyle Usage (from CONTEXT.md decisions)

```dart
// Define a reusable style (like a CSS class)
final card = TwStyle(
  padding: TwSpacing.s4.all,
  backgroundColor: TwColors.white,
  borderRadius: TwRadii.lg.all,
  shadows: TwShadows.md,
);

// Merge styles (CSS cascade)
final activeCard = card.merge(TwStyle(
  backgroundColor: TwColors.blue.shade50,
  shadows: TwShadows.lg,
));

// Apply to a widget
card.apply(child: Text('Hello'));

// Dark mode variant
final themed = TwStyle(
  backgroundColor: TwColors.white,
  textStyle: TextStyle(color: TwColors.black),
  variants: {
    TwVariant.dark: TwStyle(
      backgroundColor: TwColors.zinc.shade900,
      textStyle: TextStyle(color: TwColors.white),
    ),
  },
);

// Resolve + apply (the canonical two-step)
themed.resolve(context).apply(child: Text('Hello'));
```

### Widget Tree Produced by .apply()

```dart
// Given:
final style = TwStyle(
  margin: TwSpacing.s4.all,
  constraints: BoxConstraints(maxWidth: 300),
  opacity: 0.9,
  backgroundColor: TwColors.blue.shade500,
  borderRadius: TwRadii.lg.all,
  shadows: TwShadows.md,
  padding: TwSpacing.s4.all,
  textStyle: TextStyle(color: TwColors.white),
);

// style.apply(child: Text('Hello')) produces:
// Padding(margin)
//   ConstrainedBox
//     Opacity
//       DecoratedBox(BoxDecoration(color, borderRadius, boxShadow))
//         Padding(padding)
//           DefaultTextStyle.merge
//             Text('Hello')
```

### copyWith Pattern

```dart
TwStyle copyWith({
  EdgeInsets? padding,
  EdgeInsets? margin,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  List<BoxShadow>? shadows,
  double? opacity,
  BoxConstraints? constraints,
  TextStyle? textStyle,
  Map<TwVariant, TwStyle>? variants,
}) {
  return TwStyle(
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
    opacity: opacity ?? this.opacity,
    constraints: constraints ?? this.constraints,
    textStyle: textStyle ?? this.textStyle,
    variants: variants ?? this.variants,
  );
}
```

**Note on copyWith limitation:** The standard `??` pattern means you cannot explicitly set a property to `null` via copyWith. This is an accepted Dart convention. If the user needs to "unset" a property, they construct a new TwStyle without it.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Freezed for data classes | Manual + sealed classes | Dart 3.0 (May 2023) | No codegen needed for simple immutable classes |
| `@sealed` annotation | `sealed` keyword | Dart 3.0 (May 2023) | Compile-time exhaustiveness checking |
| `MediaQuery.platformBrightness` | `Theme.of(context).brightness` | Always preferred | Respects app-level ThemeMode |
| Multiple decoration widgets | Single `DecoratedBox` with `BoxDecoration` | Always available | Cleaner widget tree, fewer nodes |

## Open Questions

1. **copyWith null-clearing**
   - What we know: Standard `??` pattern can't set properties to null
   - What's unclear: Whether users will need this (e.g., removing a shadow from a merged style)
   - Recommendation: Accept the limitation for v1. Document it. If needed later, add `clearShadows: true` style parameters or a `TwStyle.empty` sentinel pattern.

2. **Variant map ordering when multiple variants match**
   - What we know: With only `dark` and `light`, they're mutually exclusive (brightness is always one or the other)
   - What's unclear: If v2 adds more variant types, iteration order of Map could matter
   - Recommendation: Not a v1 concern. The current design with `for/break` on first match is correct for mutually exclusive brightness variants.

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | flutter_test (SDK) |
| Config file | none (uses default flutter test runner) |
| Quick run command | `flutter test test/src/styles/` |
| Full suite command | `flutter test` |

### Phase Requirements -> Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| STY-01 | TwStyle construction with all property combinations | unit | `flutter test test/src/styles/tw_style_test.dart --name "construction"` | No -- Wave 0 |
| STY-01 | TwStyle equality and hashCode | unit | `flutter test test/src/styles/tw_style_test.dart --name "equality"` | No -- Wave 0 |
| STY-01 | TwStyle copyWith | unit | `flutter test test/src/styles/tw_style_test.dart --name "copyWith"` | No -- Wave 0 |
| STY-02 | merge with right-side-wins | unit | `flutter test test/src/styles/tw_style_test.dart --name "merge"` | No -- Wave 0 |
| STY-02 | merge preserves left-side when right-side is null | unit | `flutter test test/src/styles/tw_style_test.dart --name "merge"` | No -- Wave 0 |
| STY-03 | apply produces correct widget tree order | widget | `flutter test test/src/styles/tw_style_test.dart --name "apply"` | No -- Wave 0 |
| STY-03 | apply skips null properties | widget | `flutter test test/src/styles/tw_style_test.dart --name "apply"` | No -- Wave 0 |
| STY-03 | apply consolidates bg/borderRadius/shadows into DecoratedBox | widget | `flutter test test/src/styles/tw_style_test.dart --name "apply"` | No -- Wave 0 |
| STY-03 | apply wraps textStyle in DefaultTextStyle.merge | widget | `flutter test test/src/styles/tw_style_test.dart --name "apply"` | No -- Wave 0 |
| STY-04 | TwVariant.dark matches Brightness.dark | unit | `flutter test test/src/styles/tw_variant_test.dart` | No -- Wave 0 |
| STY-04 | TwVariant.light matches Brightness.light | unit | `flutter test test/src/styles/tw_variant_test.dart` | No -- Wave 0 |
| STY-04 | TwVariant exhaustive switch | unit | `flutter test test/src/styles/tw_variant_test.dart` | No -- Wave 0 |
| STY-05 | resolve returns matching variant merged over base | widget | `flutter test test/src/styles/tw_style_test.dart --name "resolve"` | No -- Wave 0 |
| STY-05 | resolve returns base when no variant matches | widget | `flutter test test/src/styles/tw_style_test.dart --name "resolve"` | No -- Wave 0 |
| STY-05 | resolve strips variants from result | widget | `flutter test test/src/styles/tw_style_test.dart --name "resolve"` | No -- Wave 0 |

### Sampling Rate

- **Per task commit:** `flutter test test/src/styles/`
- **Per wave merge:** `flutter test`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `test/src/styles/tw_variant_test.dart` -- covers STY-04
- [ ] `test/src/styles/tw_style_test.dart` -- covers STY-01, STY-02, STY-03, STY-05
- [ ] `test/src/styles/` directory creation

## Sources

### Primary (HIGH confidence)

- Flutter SDK `Container.build()` source -- verified exact widget nesting order (Padding -> ColoredBox -> DecoratedBox -> ConstrainedBox -> Margin). Accessed via [api.flutter.dev/flutter/widgets/Container/build.html](https://api.flutter.dev/flutter/widgets/Container/build.html)
- Flutter SDK `DefaultTextStyle.merge` -- [api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html](https://api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html)
- Flutter SDK `listEquals` / `mapEquals` -- [api.flutter.dev/flutter/foundation/listEquals.html](https://api.flutter.dev/flutter/foundation/listEquals.html)
- Dart sealed class documentation -- [dart.dev/language/class-modifiers](https://dart.dev/language/class-modifiers)
- Existing codebase: TwThemeData, TwWidgetExtensions, token classes -- read directly from source files

### Secondary (MEDIUM confidence)

- [Immutable Data Patterns in Dart and Flutter](https://dart.academy/immutable-data-patterns-in-dart-and-flutter/) -- copyWith patterns and equality conventions
- [Flutter Dark Mode detection](https://www.codegenes.net/blog/how-to-implement-dark-mode-and-light-mode-in-flutter/) -- Theme.of vs MediaQuery brightness

### Tertiary (LOW confidence)

None -- all findings verified with primary sources.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- pure Flutter SDK, no external deps, all APIs stable for years
- Architecture: HIGH -- all patterns verified against Flutter Container source and existing codebase conventions
- Pitfalls: HIGH -- derived from direct code analysis and Flutter API documentation

**Research date:** 2026-03-11
**Valid until:** 2026-06-11 (90 days -- extremely stable domain, all Flutter SDK APIs)
