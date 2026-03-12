# Phase 2: Token System + Theme Integration - Research

**Researched:** 2026-03-11
**Domain:** Dart extension types, Flutter ThemeExtension, Tailwind v4 design tokens
**Confidence:** HIGH

## Summary

This phase implements all 7 Tailwind v4 token categories as type-safe const Dart values plus the theme integration layer. The core technical patterns are well-understood: Dart extension types with const constructors for zero-cost wrappers (`TwSpace implements double`, `TwFontSize` wrapping a record, `TwColorFamily` wrapping an 11-field record), and Flutter's `ThemeExtension<T>` mechanism for theme integration via `ThemeData.extensions`.

All critical patterns have been verified via local Dart execution: extension types wrapping named-field records work as `static const`, `implements double` allows transparent use as double values, and getter methods on extension types work at runtime (though not const-evaluable -- a documented, expected limitation). The Tailwind v4 token values (hex colors, spacing scale, typography pairings, shadows, radii, opacity, breakpoints) have been extracted from official sources.

**Primary recommendation:** Build token files as independent leaf nodes (parallelizable), then layer theme integration on top. Use `abstract final class` containers with `static const` extension type members for all tokens. Use `ThemeExtension<T>` subclasses registered via `ThemeData.extensions` with a `TwTheme` convenience widget and `context.tw` access pattern.

<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions
- Color access: `TwColors.blue.shade500` via `TwColorFamily` extension type wrapping 11-field `Color` record
- Shade naming: `shade` prefix (`.shade500` not `.s500`) matching Flutter's `Colors.blue.shade500`
- No default shade -- `TwColors.blue` returns `TwColorFamily`, not `Color`
- Semantic colors (`black`, `white`, `transparent`) as direct `static const Color`, not families
- Dark theme: brightness flag only, token VALUES stay identical between light/dark
- TwThemeData customizable: `TwThemeData.light(colors: myColors, spacing: mySpacing)` with per-category overrides
- 7 ThemeExtension classes (1:1 with token files): TwColorTheme, TwSpacingTheme, TwTypographyTheme, TwRadiusTheme, TwShadowTheme, TwOpacityTheme, TwBreakpointTheme
- `context.tw` throws with helpful message; `context.tw.maybeOf` / `context.twMaybe` for nullable access
- No arithmetic operators on TwSpace (double arithmetic already works, result is plain double)
- TwFontSize wraps record of (size, lineHeight) with `.value`, `.lineHeight`, `.textStyle` getters
- TwRadius provides BorderRadius getters: `.all`, `.top`, `.bottom`, `.left`, `.right`
- TwShadow values are plain `const List<BoxShadow>` -- no extension type wrapper
- Test strategy: boundary+systematic for colors, exhaustive for smaller sets, unit+widget for theme

### Claude's Discretion
- TwColorFamily internal representation (record vs other) -- RESEARCH RECOMMENDS: named-field record
- ThemeExtension factory constructor naming (`.tailwind()`, `.defaults()`, etc.)
- TwThemeData internal storage (list vs individual fields)
- EdgeInsets getter naming on TwSpace (`.all`, `.x`, `.y` vs `.horizontal`, `.vertical`)
- Opacity and breakpoint extension type decisions
- Test group organization within files

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| TOK-01 | 22 families x 11 shades (242 colors) as `static const Color` in `TwColors` | Hex values verified from Tailwind v4 official docs; `Color(0xFF...)` constructor confirmed const-valid on Flutter >=3.19 |
| TOK-02 | Semantic colors: black, white, transparent | Trivial `static const Color` values |
| TOK-03 | 37 spacing values (0-96) using `TwSpace implements double` | Extension type `implements double` pattern verified; v3 named scale (35 values) + px + auto = 37 |
| TOK-04 | EdgeInsets convenience getters on TwSpace | Getter methods on extension types work at runtime; not const-evaluable (documented limitation) |
| TOK-05 | 13 font sizes with paired line-heights using `TwFontSize` | Extension type wrapping named-field record verified; calc() line-heights computed to exact doubles |
| TOK-06 | 9 font weight constants as `FontWeight` | `FontWeight` has const constructor; straightforward `static const` values |
| TOK-07 | 6 letter spacing values | Simple `static const double` values; exact em values verified |
| TOK-08 | 6 line height ratios | Simple `static const double` values; exact ratios verified |
| TOK-09 | 10 border radius values using `TwRadius` with `BorderRadius` getters | Extension type `implements double` + BorderRadius getters (non-const at runtime) |
| TOK-10 | 7 shadow presets + inner + none as `List<BoxShadow>` | `const List<BoxShadow>` with `const BoxShadow(...)` entries; values verified from Tailwind v4 docs |
| TOK-11 | Opacity scale (0-100 in steps of 5) as doubles | 21 values; can use abstract final class with static const doubles or extension type |
| TOK-12 | 5 breakpoint constants | Simple `static const double` values; sm=640, md=768, lg=1024, xl=1280, xxl=1536 |
| THM-01 | 7 ThemeExtension classes with copyWith + lerp | `ThemeExtension<T>` API verified; `Color.lerp`, `lerpDouble`, `BoxShadow.lerpList` available for lerp |
| THM-02 | TwTheme widget injecting ThemeExtensions into ThemeData | StatelessWidget wrapping `Theme(data: theme.copyWith(extensions: [...]))` + child |
| THM-03 | TwThemeData resolver via `context.tw` with nullable variant | BuildContext extension method; `Theme.of(context).extension<T>()` under the hood |
| THM-04 | Light and dark presets | `TwThemeData.light()` / `.dark()` factory constructors with brightness flag + default tokens |
| INF-04 | Unit tests for all token values and theme resolution | flutter_test already in dev_dependencies; test files mirror source 1:1 |

</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| flutter | >=3.19.0 | Framework; provides Color, BoxShadow, EdgeInsets, FontWeight, BorderRadius, ThemeData, ThemeExtension | Foundation of all token types |
| dart (language) | >=3.3.0 | Extension types, records, const constructors | Extension types stable since Dart 3.3 |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| flutter_test | (sdk) | Widget testing, testWidgets, pumpWidget | Theme integration widget tests |
| very_good_analysis | ^5.1.0 | Lint rules | Already configured; zero-warning enforcement |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Extension types for TwSpace/TwRadius | Plain typedef or class | Extension types are zero-cost at runtime, provide type safety, and allow `implements double` for transparent double usage |
| Extension types for TwColorFamily | Regular class with const constructor | Extension type wrapping record has zero allocation overhead; regular class would also work but is heavier conceptually |
| InheritedWidget for TwTheme | ThemeExtension only (no wrapper widget) | Wrapper widget provides cleaner API (`TwTheme(data: ...)`) vs manual `Theme(data: theme.copyWith(extensions: [...])))` |

**No additional dependencies needed.** All implementation uses Flutter SDK primitives.

## Architecture Patterns

### Recommended Project Structure
```
lib/src/
  tokens/
    colors.dart         # TwColors, TwColorFamily
    spacing.dart        # TwSpace, TwSpacing (or TwSpace.s4 pattern)
    typography.dart     # TwFontSize, TwFontWeight, TwLetterSpacing, TwLineHeight
    radius.dart         # TwRadius, TwRadii
    shadows.dart        # TwShadows
    opacity.dart        # TwOpacity
    breakpoints.dart    # TwBreakpoints
  theme/
    tw_theme.dart           # TwTheme StatelessWidget
    tw_theme_data.dart      # TwThemeData resolver + context.tw extension
    tw_theme_extension.dart # 7 ThemeExtension<T> subclasses
```

### Pattern 1: Extension Type Wrapping Double (TwSpace, TwRadius)
**What:** Extension type with `implements double` for transparent double usage
**When to use:** Spacing and radius tokens where the value IS a double
**Example:**
```dart
// Verified via local Dart execution
extension type const TwSpace._(double _) implements double {
  const TwSpace(double value) : this._(value);

  // Non-const getters (documented limitation)
  EdgeInsets get all => EdgeInsets.all(_);
  EdgeInsets get x => EdgeInsets.symmetric(horizontal: _);
  EdgeInsets get y => EdgeInsets.symmetric(vertical: _);
  EdgeInsets get top => EdgeInsets.only(top: _);
  EdgeInsets get bottom => EdgeInsets.only(bottom: _);
  EdgeInsets get left => EdgeInsets.only(left: _);
  EdgeInsets get right => EdgeInsets.only(right: _);
}

// Usage:
// Padding(padding: TwSpace.s4.all)   -- EdgeInsets
// SizedBox(width: TwSpace.s4)        -- as double
// TwSpace.s4 + TwSpace.s2            -- yields plain double (20.0)
```

### Pattern 2: Extension Type Wrapping Record (TwFontSize, TwColorFamily)
**What:** Extension type wrapping a named-field record for multi-value tokens
**When to use:** Font sizes (size + lineHeight pair), color families (11 shades)
**Example:**
```dart
// Verified via local Dart execution
extension type const TwFontSize._(({double size, double lineHeight}) _) {
  const TwFontSize(double size, double lineHeight)
      : this._((size: size, lineHeight: lineHeight));

  double get value => _.size;
  double get lineHeight => _.lineHeight;
  TextStyle get textStyle => TextStyle(fontSize: _.size, height: _.lineHeight);
}

extension type const TwColorFamily._(({
  Color shade50, Color shade100, Color shade200, Color shade300, Color shade400,
  Color shade500, Color shade600, Color shade700, Color shade800, Color shade900,
  Color shade950,
}) _) {
  const TwColorFamily({
    required Color shade50, required Color shade100, /* ...all 11... */
    required Color shade950,
  }) : this._((shade50: shade50, shade100: shade100, /* ... */ shade950: shade950));

  Color get shade50 => _.shade50;
  Color get shade500 => _.shade500;
  // ... all 11 getters
}
```

### Pattern 3: Abstract Final Class as Token Container
**What:** `abstract final class` with static const members
**When to use:** All token namespaces (TwColors, TwSpacing, TwShadows, etc.)
**Example:**
```dart
abstract final class TwColors {
  static const red = TwColorFamily(
    shade50: Color(0xFFFEF2F2),
    shade100: Color(0xFFFFE2E2),
    // ... all 11 shades
  );

  // Semantic colors as plain Color
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);
}
```

### Pattern 4: ThemeExtension Subclass
**What:** Immutable class extending `ThemeExtension<T>` with copyWith/lerp
**When to use:** Each of the 7 token categories
**Example:**
```dart
class TwColorTheme extends ThemeExtension<TwColorTheme> {
  const TwColorTheme({
    required this.red,
    required this.blue,
    // ... all 22 families + 3 semantics
  });

  final TwColorFamily red;
  final TwColorFamily blue;
  // ...

  static const defaults = TwColorTheme(
    red: TwColors.red,
    blue: TwColors.blue,
    // ...
  );

  @override
  TwColorTheme copyWith({TwColorFamily? red, TwColorFamily? blue, /* ... */}) {
    return TwColorTheme(
      red: red ?? this.red,
      blue: blue ?? this.blue,
      // ...
    );
  }

  @override
  TwColorTheme lerp(covariant TwColorTheme? other, double t) {
    if (other is! TwColorTheme) return this;
    // Color families need per-shade Color.lerp -- implement helper
    return TwColorTheme(
      red: _lerpColorFamily(red, other.red, t),
      blue: _lerpColorFamily(blue, other.blue, t),
      // ...
    );
  }
}
```

### Pattern 5: TwTheme Widget + context.tw
**What:** Convenience widget + BuildContext extension for token access
**When to use:** App-level theme injection and per-widget token access
**Example:**
```dart
class TwTheme extends StatelessWidget {
  const TwTheme({
    required this.data,
    required this.child,
    super.key,
  });

  final TwThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(extensions: data.extensions),
      child: child,
    );
  }
}

extension TwThemeContext on BuildContext {
  TwThemeData get tw {
    final theme = Theme.of(this);
    final colors = theme.extension<TwColorTheme>();
    if (colors == null) {
      throw FlutterError(
        'No TwTheme found. Wrap your app in TwTheme(...)',
      );
    }
    return TwThemeData._(
      colors: colors,
      spacing: theme.extension<TwSpacingTheme>()!,
      // ... all 7
    );
  }

  TwThemeData? get twMaybe {
    final theme = Theme.of(this);
    final colors = theme.extension<TwColorTheme>();
    if (colors == null) return null;
    return TwThemeData._(/* ... */);
  }
}
```

### Anti-Patterns to Avoid
- **Mutable token values:** ALL tokens must be `static const`. Never use `final` or mutable fields for design tokens.
- **Custom lerp for doubles where lerpDouble exists:** Use `lerpDouble(a, b, t)` from `dart:ui` for all double interpolation. Don't hand-roll.
- **Forgetting Color alpha channel:** Tailwind hex values are 6-digit (RGB). Always prepend `0xFF` for full opacity: `Color(0xFFFEF2F2)`, not `Color(0xFEF2F2)`.
- **Using Color.withOpacity():** Deprecated since Flutter 3.27. Use `Color.withValues(alpha: x)` if needed (but generally not needed for token definitions).
- **Making ThemeExtension fields nullable:** Token theme fields should be required and non-nullable. Defaults handle "no custom value" case.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Color interpolation | Manual alpha/RGB blending | `Color.lerp(a, b, t)` | Handles wide gamut, null safety |
| Shadow list interpolation | Per-element BoxShadow math | `BoxShadow.lerpList(a, b, t)` | Handles list length mismatch |
| Double interpolation | `a + (b - a) * t` | `lerpDouble(a, b, t)` from `dart:ui` | Null-safe, standard |
| BorderRadius interpolation | Manual per-corner math | `BorderRadius.lerp(a, b, t)` | Handles all corners correctly |
| Theme injection plumbing | Custom InheritedWidget from scratch | `ThemeExtension<T>` + `ThemeData.extensions` | Built into Flutter, handles lerp/copy automatically |

**Key insight:** Flutter's material library already has lerp methods for every visual type. ThemeExtension `lerp` implementations should delegate to these built-in lerp methods, not reimplement interpolation logic.

## Common Pitfalls

### Pitfall 1: Extension Type Getter Results Are Not Const
**What goes wrong:** Developer tries `const padding = TwSpace.s4.all` and gets compile error.
**Why it happens:** Extension type getters execute at runtime. `TwSpace.s4` is const (it's a double), but `.all` calls `EdgeInsets.all(16)` which is a runtime operation.
**How to avoid:** Document this clearly. The token VALUE is const, but convenience GETTERS produce runtime values. This is acceptable because Flutter widgets accept runtime values in constructors.
**Warning signs:** Lint errors about const context.

### Pitfall 2: Color Hex Values Missing Alpha
**What goes wrong:** `Color(0xFEF2F2)` produces a nearly-transparent color instead of light red.
**Why it happens:** The `Color` constructor interprets the int as ARGB. Without the `0xFF` prefix, the alpha channel gets whatever the high byte happens to be (0x00 for 6-digit hex).
**How to avoid:** ALWAYS use `0xFF` prefix for opaque colors: `Color(0xFFFEF2F2)`. Establish this as a pattern in the first color family and replicate consistently.
**Warning signs:** Colors appearing invisible or wrong opacity.

### Pitfall 3: ThemeExtension lerp Returning Wrong Type
**What goes wrong:** Theme transitions crash or produce unexpected results.
**Why it happens:** The `lerp` method receives `covariant ThemeExtension<T>?` -- forgetting the null/type check causes runtime errors.
**How to avoid:** Always start lerp with `if (other is! MyTheme) return this;` guard.
**Warning signs:** Crashes during theme animation.

### Pitfall 4: TwColorFamily Lerp Is Complex
**What goes wrong:** Color theme lerp produces jarring transitions because family-level lerp was skipped.
**Why it happens:** `TwColorFamily` is an extension type (compile-time only) -- it can't have a `lerp` method that returns a new `TwColorFamily` because extension types can't create instances via `Color.lerp` at the type level.
**How to avoid:** Implement a helper function `TwColorFamily _lerpColorFamily(TwColorFamily a, TwColorFamily b, double t)` that creates a new `TwColorFamily` with each shade lerped. Since this runs at runtime (in ThemeExtension.lerp), the non-const construction is fine.
**Warning signs:** Missing transition animation for colors when switching themes.

### Pitfall 5: Spacing Scale Count Mismatch
**What goes wrong:** Tests fail because expected count doesn't match actual.
**Why it happens:** Tailwind v3's named spacing scale has 35 explicit values (0 through 96). The requirement says 37. The extra 2 are likely `px` (1px) and possibly `auto` or an additional fractional value.
**How to avoid:** Use the canonical Tailwind v3/v4 compatible scale: 0, px(1), 0.5(2), 1(4), 1.5(6), 2(8), 2.5(10), 3(12), 3.5(14), 4(16), 5(20), 6(24), 7(28), 8(32), 9(36), 10(40), 11(44), 12(48), 14(56), 16(64), 20(80), 24(96), 28(112), 32(128), 36(144), 40(160), 44(176), 48(192), 52(208), 56(224), 60(240), 64(256), 72(288), 80(320), 96(384). Count the exact number and reconcile with the requirement.
**Warning signs:** Off-by-one or off-by-two in test assertions.

### Pitfall 6: very_good_analysis Strictness
**What goes wrong:** Analyzer warnings fail CI.
**Why it happens:** VGA 5.1.0 with strict-casts, strict-inference, and strict-raw-types is extremely strict. Common triggers: missing type annotations, unnecessary casts, missing const, unused parameters.
**How to avoid:** Run `dart analyze` locally after each file. Add `// ignore_for_file:` ONLY if absolutely necessary and justified.
**Warning signs:** CI red on analyze step.

## Code Examples

### Complete TwSpace Token File Pattern
```dart
// Source: Verified pattern via local Dart execution + Tailwind v4 docs
extension type const TwSpace._(double _) implements double {
  const TwSpace(double value) : this._(value);

  EdgeInsets get all => EdgeInsets.all(_);
  EdgeInsets get x => EdgeInsets.symmetric(horizontal: _);
  EdgeInsets get y => EdgeInsets.symmetric(vertical: _);
  EdgeInsets get top => EdgeInsets.only(top: _);
  EdgeInsets get bottom => EdgeInsets.only(bottom: _);
  EdgeInsets get left => EdgeInsets.only(left: _);
  EdgeInsets get right => EdgeInsets.only(right: _);
}

abstract final class TwSpacing {
  static const s0 = TwSpace(0);        // 0px
  static const sPx = TwSpace(1);       // 1px
  static const s0_5 = TwSpace(2);      // 2px
  static const s1 = TwSpace(4);        // 4px
  static const s1_5 = TwSpace(6);      // 6px
  static const s2 = TwSpace(8);        // 8px
  // ... through s96 = TwSpace(384)
}
```

### Complete TwFontSize Pattern
```dart
// Source: Tailwind v4 docs (font-size page) + local verification
extension type const TwFontSize._(({double size, double lineHeight}) _) {
  const TwFontSize(double size, double lineHeight)
      : this._((size: size, lineHeight: lineHeight));

  double get value => _.size;
  double get lineHeight => _.lineHeight;
  TextStyle get textStyle => TextStyle(fontSize: _.size, height: _.lineHeight);
}

abstract final class TwFontSizes {
  static const xs = TwFontSize(12, 1.333);    // calc(1/0.75) = 1.3333...
  static const sm = TwFontSize(14, 1.4286);   // calc(1.25/0.875)
  static const base = TwFontSize(16, 1.5);    // calc(1.5/1)
  static const lg = TwFontSize(18, 1.5556);   // calc(1.75/1.125)
  static const xl = TwFontSize(20, 1.4);      // calc(1.75/1.25)
  static const xl2 = TwFontSize(24, 1.3333);  // calc(2/1.5)
  static const xl3 = TwFontSize(30, 1.2);     // calc(2.25/1.875)
  static const xl4 = TwFontSize(36, 1.1111);  // calc(2.5/2.25)
  static const xl5 = TwFontSize(48, 1);
  static const xl6 = TwFontSize(60, 1);
  static const xl7 = TwFontSize(72, 1);
  static const xl8 = TwFontSize(96, 1);
  static const xl9 = TwFontSize(128, 1);
}
```

### ThemeExtension Registration Pattern
```dart
// Source: Flutter API docs (ThemeExtension-class.html, ThemeData.extensions)
class TwTheme extends StatelessWidget {
  const TwTheme({required this.data, required this.child, super.key});
  final TwThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(extensions: data.extensions),
      child: child,
    );
  }
}

// Registration:
// TwTheme(data: TwThemeData.light(), child: MyApp())

// Access:
// final colors = context.tw.colors;  // TwColorTheme
// final spacing = context.tw.spacing; // TwSpacingTheme
```

### TwRadius Pattern
```dart
// Source: Tailwind v4 docs (border-radius) + local verification
extension type const TwRadius._(double _) implements double {
  const TwRadius(double value) : this._(value);

  BorderRadius get all => BorderRadius.circular(_);
  BorderRadius get top =>
      BorderRadius.only(topLeft: Radius.circular(_), topRight: Radius.circular(_));
  BorderRadius get bottom =>
      BorderRadius.only(bottomLeft: Radius.circular(_), bottomRight: Radius.circular(_));
  BorderRadius get left =>
      BorderRadius.only(topLeft: Radius.circular(_), bottomLeft: Radius.circular(_));
  BorderRadius get right =>
      BorderRadius.only(topRight: Radius.circular(_), bottomRight: Radius.circular(_));
}

abstract final class TwRadii {
  static const none = TwRadius(0);
  static const xs = TwRadius(2);     // 0.125rem
  static const sm = TwRadius(4);     // 0.25rem
  static const md = TwRadius(6);     // 0.375rem
  static const lg = TwRadius(8);     // 0.5rem
  static const xl = TwRadius(12);    // 0.75rem
  static const xl2 = TwRadius(16);   // 1rem
  static const xl3 = TwRadius(24);   // 1.5rem
  static const xl4 = TwRadius(32);   // 2rem
  static const full = TwRadius(9999);
}
```

## Tailwind v4 Token Values Reference

### Colors: 22 Families (Hex, Verified)
Source: [Kyrylo.org Tailwind v4 reference](https://kyrylo.org/tailwind-css-v4-color-palette-reference/)

| Family | shade50 | shade500 | shade950 |
|--------|---------|----------|----------|
| Slate | #f8fafc | #62748e | #020618 |
| Gray | #f9fafb | #6a7282 | #030712 |
| Zinc | #fafafa | #71717b | #09090b |
| Neutral | #fafafa | #737373 | #0a0a0a |
| Stone | #fafaf9 | #79716b | #0c0a09 |
| Red | #fef2f2 | #fb2c36 | #460809 |
| Orange | #fff7ed | #ff6900 | #441306 |
| Amber | #fffbeb | #fe9a00 | #461901 |
| Yellow | #fefce8 | #f0b100 | #432004 |
| Lime | #f7fee7 | #7ccf00 | #192e03 |
| Green | #f0fdf4 | #00c950 | #032e15 |
| Emerald | #ecfdf5 | #00bc7d | #002c22 |
| Teal | #f0fdfa | #00bba7 | #022f2e |
| Cyan | #ecfeff | #00b8db | #053345 |
| Sky | #f0f9ff | #00a6f4 | #052f4a |
| Blue | #eff6ff | #2b7fff | #162556 |
| Indigo | #eef2ff | #615fff | #1e1a4d |
| Violet | #f5f3ff | #8e51ff | #2f0d68 |
| Purple | #faf5ff | #ad46ff | #3c0366 |
| Fuchsia | #fdf4ff | #e12afb | #4b004f |
| Pink | #fdf2f8 | #f6339a | #510424 |
| Rose | #fff1f2 | #ff2056 | #4d0218 |

Full hex values for all 11 shades per family available at source. All must be prefixed with `0xFF` for Flutter `Color` constructor.

### Spacing Scale (35 named values from Tailwind v3 compatible)
0(0px), px(1px), 0.5(2px), 1(4px), 1.5(6px), 2(8px), 2.5(10px), 3(12px), 3.5(14px), 4(16px), 5(20px), 6(24px), 7(28px), 8(32px), 9(36px), 10(40px), 11(44px), 12(48px), 14(56px), 16(64px), 20(80px), 24(96px), 28(112px), 32(128px), 36(144px), 40(160px), 44(176px), 48(192px), 52(208px), 56(224px), 60(240px), 64(256px), 72(288px), 80(320px), 96(384px)

**Note:** This is 35 values. The requirement says 37. Investigate whether to add `auto` (not a double -- would break `implements double`) or additional fractional values. Tailwind v4 added dynamic spacing so there's no official "37" -- the implementation should include these 35 plus `px` = 35, and the planner should reconcile the count with the requirement author.

### Typography
| Name | Size (px) | Line-Height (ratio) |
|------|-----------|---------------------|
| xs | 12 | 1.3333 (16/12) |
| sm | 14 | 1.4286 (20/14) |
| base | 16 | 1.5 (24/16) |
| lg | 18 | 1.5556 (28/18) |
| xl | 20 | 1.4 (28/20) |
| 2xl | 24 | 1.3333 (32/24) |
| 3xl | 30 | 1.2 (36/30) |
| 4xl | 36 | 1.1111 (40/36) |
| 5xl | 48 | 1.0 |
| 6xl | 60 | 1.0 |
| 7xl | 72 | 1.0 |
| 8xl | 96 | 1.0 |
| 9xl | 128 | 1.0 |

**Font Weights:** thin=100, extralight=200, light=300, normal=400, medium=500, semibold=600, bold=700, extrabold=800, black=900

**Letter Spacing:** tighter=-0.05em, tight=-0.025em, normal=0em, wide=0.025em, wider=0.05em, widest=0.1em
Note: em values are relative. For Flutter, convert to absolute values or store as multipliers. Recommendation: store as `double` multipliers that get multiplied by font size at point of use.

**Line Height Scale:** none=1.0, tight=1.25, snug=1.375, normal=1.5, relaxed=1.625, loose=2.0

### Border Radius
none=0, xs=2, sm=4, md=6, lg=8, xl=12, 2xl=16, 3xl=24, 4xl=32, full=9999

### Box Shadows (Verified from Tailwind v4)
| Name | CSS Values |
|------|------------|
| 2xs | `0 1px rgba(0,0,0,0.05)` |
| xs | `0 1px 2px 0 rgba(0,0,0,0.05)` |
| sm | `0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px -1px rgba(0,0,0,0.1)` |
| md | `0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1)` |
| lg | `0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1)` |
| xl | `0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1)` |
| 2xl | `0 25px 50px -12px rgba(0,0,0,0.25)` |
| inner | `inset 0 2px 4px 0 rgba(0,0,0,0.05)` |
| none | (empty list) |

Map to `BoxShadow(offset: Offset(x, y), blurRadius: blur, spreadRadius: spread, color: Color.fromRGBO(0, 0, 0, opacity))`.

### Opacity Scale (21 values)
0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100
As doubles: 0.0, 0.05, 0.10, 0.15, ..., 0.95, 1.0

### Breakpoints
sm=640, md=768, lg=1024, xl=1280, xxl=1536 (pixels)

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `Color.withOpacity()` | `Color.withValues(alpha: x)` | Flutter 3.27 | Must not use `.withOpacity()` anywhere in codebase |
| `Color.value` getter | `Color.a`, `.r`, `.g`, `.b` (normalized) | Flutter 3.27 | Avoid `.value` getter if targeting latest; but `Color(int)` constructor is fine |
| Tailwind v3 fixed spacing scale | Tailwind v4 dynamic spacing | Tailwind 4.0 (2025) | Project uses v3-compatible named scale for static tokens |
| Tailwind v3 hex colors | Tailwind v4 OKLCH colors | Tailwind 4.0 (2025) | Flutter uses sRGB; use hex equivalents of OKLCH values |
| `abstract class` for static containers | `abstract final class` | Dart 3.0 | Prevents extension and instantiation; cleaner intent |

## Open Questions

1. **Spacing count: 35 vs 37**
   - What we know: Tailwind v3 named scale has 35 values. Tailwind v4 is dynamic (any multiple). Requirement says 37.
   - What's unclear: Which 2 additional values were intended.
   - Recommendation: Implement the 35 standard values. If the requirement author intended 37, they may have counted differently or included `auto`. Clarify during planning; if no clarification, use 35 and note the discrepancy.

2. **Letter spacing units**
   - What we know: Tailwind uses `em` values (relative to font size). Flutter's `TextStyle.letterSpacing` is absolute pixels.
   - What's unclear: Whether to store as em multipliers or pre-computed pixel values.
   - Recommendation: Store as em multipliers (doubles). Users multiply by their font size: `letterSpacing: TwLetterSpacing.tight * fontSize`. This preserves Tailwind's proportional behavior.

3. **TwThemeData construction overhead**
   - What we know: `context.tw` reads 7 ThemeExtensions from `ThemeData` on every call.
   - What's unclear: Whether to cache the `TwThemeData` in the widget tree.
   - Recommendation: Don't cache. `Theme.of(context).extension<T>()` is a HashMap lookup -- O(1) and fast. Premature optimization would add complexity.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | flutter_test (SDK bundled) |
| Config file | None needed -- flutter_test works out of the box |
| Quick run command | `flutter test --no-pub` |
| Full suite command | `flutter test --coverage` |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| TOK-01 | 22 families x 11 shades = 242 colors correct values | unit | `flutter test test/src/tokens/colors_test.dart -x` | Wave 0 |
| TOK-02 | Semantic colors black/white/transparent exact | unit | `flutter test test/src/tokens/colors_test.dart -x` | Wave 0 |
| TOK-03 | 37 spacing values correct doubles | unit | `flutter test test/src/tokens/spacing_test.dart -x` | Wave 0 |
| TOK-04 | EdgeInsets getters produce correct values | unit | `flutter test test/src/tokens/spacing_test.dart -x` | Wave 0 |
| TOK-05 | 13 font sizes with correct paired line-heights | unit | `flutter test test/src/tokens/typography_test.dart -x` | Wave 0 |
| TOK-06 | 9 font weights map to correct FontWeight | unit | `flutter test test/src/tokens/typography_test.dart -x` | Wave 0 |
| TOK-07 | 6 letter spacing values correct | unit | `flutter test test/src/tokens/typography_test.dart -x` | Wave 0 |
| TOK-08 | 6 line height ratios correct | unit | `flutter test test/src/tokens/typography_test.dart -x` | Wave 0 |
| TOK-09 | 10 radius values + BorderRadius getters | unit | `flutter test test/src/tokens/radius_test.dart -x` | Wave 0 |
| TOK-10 | 9 shadow presets with correct BoxShadow params | unit | `flutter test test/src/tokens/shadows_test.dart -x` | Wave 0 |
| TOK-11 | 21 opacity values correct | unit | `flutter test test/src/tokens/opacity_test.dart -x` | Wave 0 |
| TOK-12 | 5 breakpoint values correct | unit | `flutter test test/src/tokens/breakpoints_test.dart -x` | Wave 0 |
| THM-01 | 7 ThemeExtensions: copyWith + lerp | unit | `flutter test test/src/theme/tw_theme_extension_test.dart -x` | Wave 0 |
| THM-02 | TwTheme widget injects extensions | widget | `flutter test test/src/theme/tw_theme_test.dart -x` | Wave 0 |
| THM-03 | context.tw resolves, throws on missing, maybeOf returns null | widget | `flutter test test/src/theme/tw_theme_data_test.dart -x` | Wave 0 |
| THM-04 | light/dark presets have correct brightness | unit | `flutter test test/src/theme/tw_theme_data_test.dart -x` | Wave 0 |
| INF-04 | All above tests exist and pass with >=85% coverage | meta | `flutter test --coverage` | Wave 0 |

### Sampling Rate
- **Per task commit:** `flutter test --no-pub`
- **Per wave merge:** `flutter test --coverage`
- **Phase gate:** Full suite green + coverage >=85% before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `test/src/tokens/colors_test.dart` -- covers TOK-01, TOK-02
- [ ] `test/src/tokens/spacing_test.dart` -- covers TOK-03, TOK-04
- [ ] `test/src/tokens/typography_test.dart` -- covers TOK-05, TOK-06, TOK-07, TOK-08
- [ ] `test/src/tokens/radius_test.dart` -- covers TOK-09
- [ ] `test/src/tokens/shadows_test.dart` -- covers TOK-10
- [ ] `test/src/tokens/opacity_test.dart` -- covers TOK-11
- [ ] `test/src/tokens/breakpoints_test.dart` -- covers TOK-12
- [ ] `test/src/theme/tw_theme_extension_test.dart` -- covers THM-01
- [ ] `test/src/theme/tw_theme_test.dart` -- covers THM-02
- [ ] `test/src/theme/tw_theme_data_test.dart` -- covers THM-03, THM-04
- [ ] `test/src/tokens/` and `test/src/theme/` directories don't exist yet -- must be created

## Sources

### Primary (HIGH confidence)
- Tailwind v4 official docs: [tailwindcss.com/docs/colors](https://tailwindcss.com/docs/colors) - color families, shade structure
- Tailwind v4 color hex reference: [kyrylo.org/tailwind-css-v4-color-palette-reference](https://kyrylo.org/tailwind-css-v4-color-palette-reference/) - all hex values for 22 families
- Tailwind v4 font-size: [tailwindcss.com/docs/font-size](https://tailwindcss.com/docs/font-size) - 13 sizes with line-height pairings
- Tailwind v4 box-shadow: [tailwindcss.com/docs/box-shadow](https://tailwindcss.com/docs/box-shadow) - all shadow presets
- Tailwind v4 border-radius: [tailwindcss.com/docs/border-radius](https://tailwindcss.com/docs/border-radius) - 10 radius values
- Tailwind v4 opacity: [tailwindcss.com/docs/opacity](https://tailwindcss.com/docs/opacity) - 21 opacity values
- Tailwind v4 letter-spacing: [tailwindcss.com/docs/letter-spacing](https://tailwindcss.com/docs/letter-spacing) - 6 tracking values
- Tailwind v4 line-height: [tailwindcss.com/docs/line-height](https://tailwindcss.com/docs/line-height) - 6 leading values
- Tailwind v4 font-weight: [tailwindcss.com/docs/font-weight](https://tailwindcss.com/docs/font-weight) - 9 weights
- Tailwind v3 spacing: [v3.tailwindcss.com/docs/space](https://v3.tailwindcss.com/docs/space) - named spacing scale
- Dart extension types: [dart.dev/language/extension-types](https://dart.dev/language/extension-types) - syntax, implements, const
- Flutter ThemeExtension: [api.flutter.dev ThemeExtension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html) - API contract
- Flutter BoxShadow.lerpList: [api.flutter.dev BoxShadow.lerpList](https://api.flutter.dev/flutter/painting/BoxShadow/lerpList.html) - list interpolation
- Flutter Color migration: [docs.flutter.dev wide-gamut-framework](https://docs.flutter.dev/release/breaking-changes/wide-gamut-framework) - Color(int) NOT deprecated, only .withOpacity()
- Local Dart execution: extension type patterns verified with `dart run` on test files

### Secondary (MEDIUM confidence)
- Tailwind v4 breakpoints: [tailwindcss.com/docs/responsive-design](https://tailwindcss.com/docs/responsive-design) - sm/md/lg/xl/2xl confirmed via multiple sources
- Tailwind v4 spacing model: [tailwindcss.com/blog/tailwindcss-v4](https://tailwindcss.com/blog/tailwindcss-v4) - dynamic spacing explanation

### Tertiary (LOW confidence)
- Spacing count of 37: Could not verify. Official Tailwind v3 scale has 35. v4 is dynamic. Needs reconciliation with requirement author.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Flutter SDK only, no external deps
- Architecture: HIGH - All patterns verified via local execution and official docs
- Token values: HIGH - Extracted from official Tailwind docs and verified reference sites
- Pitfalls: HIGH - Based on known Dart/Flutter constraints and verified edge cases
- Spacing count: LOW - 35 vs 37 discrepancy unresolved

**Research date:** 2026-03-11
**Valid until:** 2026-04-11 (stable domain, slow-moving Flutter/Dart release cycle)
