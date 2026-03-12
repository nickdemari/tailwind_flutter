# tailwind_flutter — Product Requirements Document

> **GSD consumption:** `/gsd:new-project --auto @tailwind_flutter_prd.md`
> **Package name:** `tailwind_flutter`
> **Target:** pub.dev publication, Flutter Favorite candidacy
> **Author:** Nick
> **Date:** 2026-03-07

---

## Vision

Build the definitive Tailwind CSS package for Flutter — a pub.dev-published design token system and utility-first styling API that reduces Flutter styling boilerplate by 60% while preserving 100% of Dart's type safety and Flutter's widget model.

This is **not** CSS-for-Flutter. This is Tailwind's design philosophy — constraint-based tokens, composable utilities, progressive disclosure — expressed as idiomatic Dart. It enhances Flutter's existing `ThemeData` system rather than replacing it. A developer can adopt one spacing constant in an existing project without rewriting anything.

### Core Value Proposition

Flutter developers write 10+ lines of `BoxDecoration` for a styled container. In a typical `TextStyle.copyWith()` call, meaningful values represent only 15% of the characters — the rest is boilerplate. `tailwind_flutter` compresses this into composable, type-safe, theme-aware utilities.

### What Success Looks Like

- 160/160 pub.dev points at launch
- Incremental adoption — works alongside existing Material/Cupertino code
- Complete Tailwind v4 token parity (colors, spacing, typography, radius, shadows, breakpoints)
- Three-tier API: raw tokens → widget extensions → composable styles
- Full dark mode, `ThemeExtension<T>` integration, animated transitions via `lerp`
- Comprehensive documentation website, golden tests, Widgetbook catalog

---

## Technical Decisions (Pre-Resolved)

These decisions are locked. Agents should not re-research or re-debate them.

### Language & Framework
- **Dart 3.3+** (minimum SDK constraint)
- **Flutter 3.19+** (minimum framework constraint)
- **All 6 platforms:** Android, iOS, Web, Windows, macOS, Linux

### Architecture: Three-Tier Layered API

```
┌─────────────────────────────────────────────────────────┐
│  TIER 3: Composable Styles (TwStyle + Variants)         │
│  Context-aware, reusable, mergeable style objects        │
│  Supports dark mode, hover, responsive breakpoints       │
├─────────────────────────────────────────────────────────┤
│  TIER 2: Widget Extensions                               │
│  Extension methods on Widget for reduced nesting         │
│  .p(), .px(), .bg(), .rounded(), .opacity(), .shadow()   │
├─────────────────────────────────────────────────────────┤
│  TIER 1: Design Tokens (const values + ThemeExtension)   │
│  TwColors, TwSpace, TwText, TwRadius, TwShadow,         │
│  TwBreakpoint, TwOpacity — all using extension types     │
└─────────────────────────────────────────────────────────┘
```

### Token Implementation Strategy
- **Extension types** (Dart 3.3) for zero-runtime-cost typed tokens
- **`ThemeExtension<T>`** classes with `copyWith` and `lerp` for theme integration
- **`const` constructors** everywhere — tokens compile to literal values
- **No `build_runner` required** for package consumers — ship pre-generated tokens

### API Philosophy
- Extension methods on `Widget` for Tier 2 (each wraps in parent widget — Flutter-idiomatic)
- Extensions on `BuildContext` for token access: `context.tw.colors.blue500`
- Style composition via `TwStyle` class for Tier 3 (similar to Mix's `Style` but idiomatic)
- Terminal `.apply()` method resolves style into a widget — no silent `.make()` forgetting

### What This Is NOT
- Not a component library (no `TwButton`, `TwCard`)
- Not a layout system (no grid/flex utilities — Flutter has `Row`/`Column`/`Flex`)
- Not responsive-first (breakpoints are Tier 3, not required for Tier 1-2 usage)
- Not string-based (no `"bg-blue-500"` strings — always typed Dart)
- Not a replacement for `ThemeData` — an enhancement that plugs into it

### Competitive Positioning
- **vs Mix:** Idiomatic Dart API (no `$box.color.purple()` DSL), lower learning curve, focused scope (tokens + utilities, not a full design system framework)
- **vs VelocityX:** Design token system, theme integration, no kitchen-sink scope, no `.make()` footgun
- **vs styled_widget:** Design tokens, style composition/reuse, theme awareness, dark mode, active maintenance

---

## Shared Contracts

> **CRITICAL FOR MULTI-AGENT EXECUTION:** All agents must reference these interfaces.
> These contracts are the coordination boundary between parallel work streams.
> Define these FIRST before any implementation begins.

### Package Barrel Export

```dart
// lib/tailwind_flutter.dart
library tailwind_flutter;

// Tokens (Tier 1)
export 'src/tokens/colors.dart';
export 'src/tokens/spacing.dart';
export 'src/tokens/typography.dart';
export 'src/tokens/radius.dart';
export 'src/tokens/shadows.dart';
export 'src/tokens/breakpoints.dart';
export 'src/tokens/opacity.dart';

// Theme (Tier 1 integration)
export 'src/theme/tw_theme.dart';
export 'src/theme/tw_theme_data.dart';
export 'src/theme/tw_theme_extension.dart';

// Widget Extensions (Tier 2)
export 'src/extensions/widget_extensions.dart';
export 'src/extensions/context_extensions.dart';
export 'src/extensions/text_extensions.dart';
export 'src/extensions/edge_insets_extensions.dart';

// Style Composition (Tier 3)
export 'src/styles/tw_style.dart';
export 'src/styles/tw_variant.dart';
export 'src/styles/tw_styled_widget.dart';
```

### Extension Type Interface Pattern

All token types follow this pattern:

```dart
extension type const TwSpace(double value) implements double {
  // Named constructors for the Tailwind scale
  static const s0 = TwSpace(0);        // 0px
  static const s1 = TwSpace(4);        // 4px
  static const s2 = TwSpace(8);        // 8px
  // ... through s96 = TwSpace(384)

  // Convenience getters for EdgeInsets
  EdgeInsets get all => EdgeInsets.all(value);
  EdgeInsets get x => EdgeInsets.symmetric(horizontal: value);
  EdgeInsets get y => EdgeInsets.symmetric(vertical: value);
  EdgeInsets get top => EdgeInsets.only(top: value);
  EdgeInsets get bottom => EdgeInsets.only(bottom: value);
  EdgeInsets get left => EdgeInsets.only(left: value);
  EdgeInsets get right => EdgeInsets.only(right: value);
}
```

### ThemeExtension Interface Pattern

All theme tokens follow this pattern:

```dart
@immutable
class TwSpacingTheme extends ThemeExtension<TwSpacingTheme> {
  final double s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10,
               s11, s12, s14, s16, s20, s24, s28, s32, s36,
               s40, s44, s48, s52, s56, s60, s64, s72, s80, s96;

  const TwSpacingTheme({ /* all with default values from Tailwind scale */ });

  @override
  TwSpacingTheme copyWith({ /* all optional params */ });

  @override
  TwSpacingTheme lerp(covariant TwSpacingTheme? other, double t);
}
```

### BuildContext Extension Interface

```dart
extension TwBuildContext on BuildContext {
  TwThemeData get tw => TwThemeData.of(this);
}

class TwThemeData {
  final TwColorTheme colors;
  final TwSpacingTheme spacing;
  final TwTypographyTheme typography;
  final TwRadiusTheme radius;
  final TwShadowTheme shadows;
  final TwBreakpointTheme breakpoints;
  final TwOpacityTheme opacity;

  static TwThemeData of(BuildContext context);
  static TwThemeData? maybeOf(BuildContext context);
}
```

### Widget Extension Interface

```dart
extension TwWidgetExtensions on Widget {
  // Padding
  Widget p(double value);
  Widget px(double value);
  Widget py(double value);
  Widget pt(double value);
  Widget pb(double value);
  Widget pl(double value);
  Widget pr(double value);

  // Background
  Widget bg(Color color);

  // Border radius
  Widget rounded(double radius);
  Widget roundedFull();

  // Opacity
  Widget opacity(double value);

  // Shadow (takes a TwShadow record)
  Widget shadow(List<BoxShadow> shadows);

  // Sizing constraints
  Widget width(double w);
  Widget height(double h);
  Widget size(double w, double h);

  // Alignment
  Widget center();
  Widget align(Alignment alignment);

  // Clipping
  Widget clipRect();
  Widget clipOval();
}
```

### TwStyle Interface (Tier 3)

```dart
@immutable
class TwStyle {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? shadows;
  final double? opacity;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;
  final Map<TwVariant, TwStyle>? variants;

  const TwStyle({ /* all fields */ });

  // Merge: other's non-null fields override this
  TwStyle merge(TwStyle other);

  // Resolve: apply variant conditions from context
  TwStyle resolve(BuildContext context);

  // Apply: wrap a child widget with resolved style
  Widget apply({required Widget child});
}
```

---

## Requirements

### V1 — Must Ship (Milestone 1)

#### Tier 1: Design Tokens
- **R-T1-01:** Complete Tailwind v4 color palette — 22 families × 11 shades (242 colors) as `const Color` values using extension type `TwColor`
- **R-T1-02:** Full spacing scale — 37 values from 0 to 96 (0px to 384px, 4px base unit) using extension type `TwSpace` with `EdgeInsets` convenience getters
- **R-T1-03:** Typography scale — 13 font sizes (xs/12px through 9xl/128px) each with paired default line-height, using extension type `TwFontSize`
- **R-T1-04:** Font weight constants — 9 weights (thin/100 through black/900) as `FontWeight` values
- **R-T1-05:** Letter spacing scale — 6 named values (tighter/-0.05em through widest/0.1em)
- **R-T1-06:** Line height scale — 6 named ratios (none/1.0 through loose/2.0)
- **R-T1-07:** Border radius scale — 10 values (none/0 through full/9999) using extension type `TwRadius`
- **R-T1-08:** Box shadow presets — 7 elevation levels (2xs through 2xl) plus inner and none as `List<BoxShadow>` records
- **R-T1-09:** Opacity scale — standard Tailwind opacity values (0, 5, 10, 15, 20, 25, 30, ..., 95, 100) as `double` constants
- **R-T1-10:** Breakpoint constants — 5 responsive thresholds (sm/640, md/768, lg/1024, xl/1280, 2xl/1536)
- **R-T1-11:** `ThemeExtension<T>` class for each token category with `copyWith` and `lerp`
- **R-T1-12:** `TwTheme` widget that injects all `ThemeExtension`s into `ThemeData`
- **R-T1-13:** `TwThemeData` resolver accessed via `context.tw` with null-safety (`maybeOf`)
- **R-T1-14:** Default light and dark theme presets (`TwThemeData.light()`, `TwThemeData.dark()`)

#### Tier 2: Widget Extensions
- **R-T2-01:** Padding extensions — `p`, `px`, `py`, `pt`, `pb`, `pl`, `pr` accepting `double`
- **R-T2-02:** Margin extensions — `m`, `mx`, `my`, `mt`, `mb`, `ml`, `mr` (wraps in `Padding` on parent `Container`)
- **R-T2-03:** Background color extension — `.bg(Color)`
- **R-T2-04:** Border radius extension — `.rounded(double)`, `.roundedFull()`
- **R-T2-05:** Opacity extension — `.opacity(double)`
- **R-T2-06:** Shadow extension — `.shadow(List<BoxShadow>)`
- **R-T2-07:** Sizing extensions — `.width(double)`, `.height(double)`, `.size(double, double)`
- **R-T2-08:** Alignment extensions — `.center()`, `.align(Alignment)`
- **R-T2-09:** Clip extensions — `.clipRect()`, `.clipOval()`, `.clipRounded(double)`
- **R-T2-10:** Text-specific extensions on `Text` widget — `.bold()`, `.italic()`, `.fontSize(double)`, `.textColor(Color)`, `.letterSpacing(double)`, `.lineHeight(double)`, `.fontWeight(FontWeight)`

#### Tier 3: Style Composition
- **R-T3-01:** `TwStyle` immutable data class with all visual properties
- **R-T3-02:** `TwStyle.merge()` for combining styles (right-side wins for conflicts)
- **R-T3-03:** `TwStyle.apply(child: widget)` to render styled widget
- **R-T3-04:** `TwVariant` sealed class with `dark`, `light` platform brightness variants
- **R-T3-05:** `TwStyle.resolve(context)` to evaluate variant conditions and return flat style

#### Infrastructure
- **R-INF-01:** Package structure targeting 160/160 pub.dev points (analysis, docs, example, all platforms)
- **R-INF-02:** Barrel export file (`tailwind_flutter.dart`) with organized exports
- **R-INF-03:** Example app in `example/` demonstrating all three tiers
- **R-INF-04:** Unit tests for all token values, extension methods, theme resolution
- **R-INF-05:** Golden tests for styled widgets across light/dark themes
- **R-INF-06:** `README.md` with quick-start guide, API overview, and comparison to Tailwind CSS
- **R-INF-07:** `analysis_options.yaml` with `flutter_lints` + strict mode, zero warnings
- **R-INF-08:** `CHANGELOG.md` following Keep a Changelog format
- **R-INF-09:** CI/CD via GitHub Actions (analyze, test, pana score, coverage)
- **R-INF-10:** Dartdoc coverage ≥ 80% on all public APIs

### V2 — Next Milestone

- **R-V2-01:** Responsive variants — `TwVariant.sm()`, `.md()`, `.lg()`, `.xl()`, `.xxl()` using `MediaQuery`
- **R-V2-02:** Hover/press interaction variants for desktop/web
- **R-V2-03:** `TwAnimatedStyle` with implicit animation support (duration, curve)
- **R-V2-04:** `tailwind_flutter_lint` companion package with custom lint rules
- **R-V2-05:** Widgetbook catalog app as a separate example project
- **R-V2-06:** Dedicated documentation website (likely Astro or Next.js with Starlight)
- **R-V2-07:** VS Code / Android Studio snippets extension
- **R-V2-08:** Token generation CLI from upstream Tailwind CSS releases
- **R-V2-09:** Group/peer-like conditional modifiers (parent state affects child)
- **R-V2-10:** `@apply`-equivalent — named style extraction with `TwStyle` factory constructors

### Out of Scope

- Component library (no buttons, cards, modals — this is a styling primitive package)
- Layout utilities (Flutter's Row/Column/Flex/Expanded are sufficient)
- String-based class parsing (`"bg-blue-500 p-4"` → Widget)
- CSS-in-Dart or stylesheet abstraction layers
- Build-time code generation required from consumers
- State management integration
- Navigation/routing integration
- Dart macros (paused indefinitely by Dart team as of Jan 2025)

---

## Module Boundaries for Parallel Execution

> **AGENT COORDINATION MODEL:** Phases should be designed so that multiple Claude Code
> agents can work on separate modules simultaneously within the same phase.
> The shared contracts above are the integration surface — agents code to contracts, not to each other.

### Module Map

```
MODULE A: tokens/          ← Agent 1 (Pure Dart, zero Flutter dependency)
  colors.dart              ~600 lines (242 colors + extension type)
  spacing.dart             ~150 lines (37 values + EdgeInsets getters)
  typography.dart          ~200 lines (font sizes, weights, letter spacing, line height)
  radius.dart              ~80 lines  (10 values + BorderRadius getters)
  shadows.dart             ~120 lines (7 levels as List<BoxShadow>)
  breakpoints.dart         ~60 lines  (5 values + sealed class)
  opacity.dart             ~80 lines  (21 values)

MODULE B: theme/           ← Agent 2 (Depends on Module A contracts only)
  tw_theme.dart            TwTheme widget (InheritedWidget or Theme wrapper)
  tw_theme_data.dart       TwThemeData composite class
  tw_theme_extension.dart  ThemeExtension<T> for each token category

MODULE C: extensions/      ← Agent 3 (Depends on Module A for type refs only)
  widget_extensions.dart   Extension methods on Widget
  text_extensions.dart     Extension methods on Text
  context_extensions.dart  BuildContext.tw accessor
  edge_insets_extensions.dart  Convenience EdgeInsets builders

MODULE D: styles/          ← Agent 4 (Depends on Module A + B contracts)
  tw_style.dart            TwStyle immutable class + merge + apply
  tw_variant.dart          TwVariant sealed class (dark/light for v1)
  tw_styled_widget.dart    TwStyledWidget convenience wrapper

MODULE E: infrastructure/  ← Agent 5 (Depends on all modules being stub-complete)
  pubspec.yaml, analysis_options.yaml, barrel export
  example/ app
  test/ suite (unit + golden)
  README.md, CHANGELOG.md, LICENSE
  CI/CD (GitHub Actions)
```

### Dependency Graph

```
Module A (tokens)     ← NO DEPENDENCIES — can start immediately
       │
       ├──→ Module B (theme)       ← depends on A
       ├──→ Module C (extensions)  ← depends on A
       │
       └──→ Module D (styles)      ← depends on A + B
                │
                └──→ Module E (infrastructure) ← depends on all
```

### Wave Execution Strategy

```
WAVE 1 (parallel):  Module A — all 7 token files can be written simultaneously
WAVE 2 (parallel):  Module B + Module C — both depend only on A
WAVE 3 (sequential): Module D — depends on A + B being complete
WAVE 4 (sequential): Module E — integration, tests, docs, example app
```

---

## File Structure

```
tailwind_flutter/
├── lib/
│   ├── tailwind_flutter.dart                    # Barrel export
│   └── src/
│       ├── tokens/
│       │   ├── colors.dart                       # TwColors extension type + 22 family classes
│       │   ├── spacing.dart                      # TwSpace extension type + scale
│       │   ├── typography.dart                    # TwFontSize, TwFontWeight, TwLetterSpacing, TwLineHeight
│       │   ├── radius.dart                        # TwRadius extension type + scale
│       │   ├── shadows.dart                       # TwShadows with List<BoxShadow> presets
│       │   ├── breakpoints.dart                   # TwBreakpoint sealed class
│       │   └── opacity.dart                       # TwOpacity extension type + scale
│       ├── theme/
│       │   ├── tw_theme.dart                      # TwTheme widget
│       │   ├── tw_theme_data.dart                 # TwThemeData composite
│       │   └── tw_theme_extension.dart            # All ThemeExtension<T> classes
│       ├── extensions/
│       │   ├── widget_extensions.dart             # Extension on Widget
│       │   ├── text_extensions.dart               # Extension on Text
│       │   ├── context_extensions.dart            # Extension on BuildContext
│       │   └── edge_insets_extensions.dart         # EdgeInsets helpers
│       └── styles/
│           ├── tw_style.dart                      # TwStyle class
│           ├── tw_variant.dart                    # TwVariant sealed class
│           └── tw_styled_widget.dart              # TwStyledWidget wrapper
├── example/
│   └── lib/
│       └── main.dart                              # Showcase app
├── test/
│   ├── tokens/
│   │   ├── colors_test.dart
│   │   ├── spacing_test.dart
│   │   ├── typography_test.dart
│   │   ├── radius_test.dart
│   │   ├── shadows_test.dart
│   │   ├── breakpoints_test.dart
│   │   └── opacity_test.dart
│   ├── theme/
│   │   ├── tw_theme_test.dart
│   │   └── tw_theme_data_test.dart
│   ├── extensions/
│   │   ├── widget_extensions_test.dart
│   │   ├── text_extensions_test.dart
│   │   └── context_extensions_test.dart
│   ├── styles/
│   │   ├── tw_style_test.dart
│   │   └── tw_variant_test.dart
│   └── golden/
│       ├── styled_widgets_light_test.dart
│       └── styled_widgets_dark_test.dart
├── .github/
│   └── workflows/
│       └── ci.yml
├── pubspec.yaml
├── analysis_options.yaml
├── CHANGELOG.md
├── LICENSE                                        # MIT
└── README.md
```

---

## Token Reference (Tailwind v4 Parity)

### Color Families

22 families, each with shades: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950

```
slate, gray, zinc, neutral, stone,
red, orange, amber, yellow, lime,
green, emerald, teal, cyan, sky,
blue, indigo, violet, purple, fuchsia,
pink, rose
```

Plus semantic: `black` (#000), `white` (#FFF), `transparent`

Implementation as extension type:
```dart
extension type const TwColor(Color value) implements Color {
  // Organized by family — each family is a static class or nested namespace
}

abstract final class TwColors {
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  // ... all 242 + black, white, transparent
}
```

### Spacing Scale

4px base unit. Complete scale:

```
0    → 0px       0.5  → 2px       1    → 4px       1.5  → 6px
2    → 8px       2.5  → 10px      3    → 12px      3.5  → 14px
4    → 16px      5    → 20px      6    → 24px      7    → 28px
8    → 32px      9    → 36px      10   → 40px      11   → 44px
12   → 48px      14   → 56px      16   → 64px      20   → 80px
24   → 96px      28   → 112px     32   → 128px     36   → 144px
40   → 160px     44   → 176px     48   → 192px     52   → 208px
56   → 224px     60   → 240px     64   → 256px     72   → 288px
80   → 320px     96   → 384px
```

Dart naming: use `s` prefix, replace `.` with `p` → `s0`, `s0p5`, `s1`, `s1p5`, `s2`, ...

### Typography Scale

| Name | Size | Default Line Height |
|------|------|-------------------|
| xs   | 12px | 16px (1.33)       |
| sm   | 14px | 20px (1.43)       |
| base | 16px | 24px (1.5)        |
| lg   | 18px | 28px (1.56)       |
| xl   | 20px | 28px (1.4)        |
| 2xl  | 24px | 32px (1.33)       |
| 3xl  | 30px | 36px (1.2)        |
| 4xl  | 36px | 40px (1.11)       |
| 5xl  | 48px | 48px (1.0)        |
| 6xl  | 60px | 60px (1.0)        |
| 7xl  | 72px | 72px (1.0)        |
| 8xl  | 96px | 96px (1.0)        |
| 9xl  | 128px| 128px (1.0)       |

### Border Radius Scale

| Name | Value |
|------|-------|
| none | 0     |
| xs   | 2px   |
| sm   | 4px   |
| (default) | 6px |
| md   | 8px   |
| lg   | 12px  |
| xl   | 16px  |
| 2xl  | 24px  |
| 3xl  | 32px  |
| full | 9999px|

### Shadow Scale

Shadows should be `List<BoxShadow>` for Flutter compatibility. Each level maps to Tailwind's CSS box-shadow values converted to Flutter's offset/blur/spread/color model.

### Font Weights

| Name       | Value |
|------------|-------|
| thin       | 100   |
| extraLight | 200   |
| light      | 300   |
| normal     | 400   |
| medium     | 500   |
| semiBold   | 600   |
| bold       | 700   |
| extraBold  | 800   |
| black      | 900   |

---

## Constraints

- **No external dependencies** beyond Flutter SDK — the package must have zero third-party deps
- **Const-everything** — all tokens must be compile-time constants where possible
- **Extension type `implements`** — `TwSpace` should `implements double` so it works wherever `double` is expected without explicit `.value` access
- **No breaking changes** to Flutter's widget tree semantics — extension methods must produce valid widget trees identical to hand-written equivalents
- **Dartdoc on every public API** — no exceptions, this is a pub.dev requirement
- **`flutter analyze` zero warnings** with strict lints enabled
- **Test coverage ≥ 85%** for all non-generated code
- **MIT License**

---

## API Usage Examples

### Tier 1: Direct Token Access
```dart
Container(
  padding: TwSpace.s4.all,          // 16px all sides
  decoration: BoxDecoration(
    color: TwColors.blue500,
    borderRadius: TwRadius.lg.all,  // 12px
    boxShadow: TwShadows.md,
  ),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: TwFontSize.xl.value,    // 20px
      fontWeight: TwFontWeight.bold,     // FontWeight.w700
      letterSpacing: TwLetterSpacing.tight, // -0.025em
      height: TwLineHeight.snug,         // 1.375
    ),
  ),
);
```

### Tier 2: Widget Extensions
```dart
Text('Hello')
    .bold()
    .fontSize(TwFontSize.xl.value)
    .textColor(TwColors.white)
    .p(TwSpace.s4.value)
    .bg(TwColors.blue500)
    .rounded(TwRadius.lg.value)
    .shadow(TwShadows.md)
```

### Tier 3: Composable Styles
```dart
const cardStyle = TwStyle(
  padding: EdgeInsets.all(16),
  backgroundColor: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(12)),
  shadows: TwShadows.md,
  variants: {
    TwVariant.dark(): TwStyle(
      backgroundColor: Color(0xFF1E1E1E),
      shadows: TwShadows.lg,
    ),
  },
);

// In a widget:
cardStyle.resolve(context).apply(
  child: Text('Card content'),
);
```

### Theme Customization
```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      TwThemeData.light().copyWith(
        colors: TwColorTheme.defaults().copyWith(
          // Override specific tokens
        ),
        spacing: TwSpacingTheme(baseUnit: 5), // 5px instead of 4px
      ),
    ],
  ),
);
```

---

## Testing Strategy

### Unit Tests
- Every token value matches its Tailwind v4 equivalent (automated: parse Tailwind source → assert Dart values)
- Extension type `implements` constraints verified (TwSpace is usable as double)
- ThemeExtension `copyWith` produces correct overrides
- ThemeExtension `lerp` interpolates all fields correctly
- TwStyle `merge` follows right-side-wins semantics
- TwStyle `resolve` correctly applies dark/light variants

### Widget Tests
- Each widget extension produces the correct widget tree structure
- Extensions are chainable in any order
- Context extensions resolve tokens from nearest Theme ancestor
- TwTheme widget correctly injects all ThemeExtensions

### Golden Tests
- Styled container in light theme
- Styled container in dark theme
- Typography scale rendering
- Shadow scale rendering
- All border radius values
- Color palette swatch grid

### Integration Tests
- Full app using all three tiers simultaneously
- Theme switching (light ↔ dark) with animated transition
- Custom theme override with `copyWith`

---

## GSD Configuration Recommendations

```json
{
  "mode": "interactive",
  "depth": "comprehensive",
  "workflow": {
    "research": true,
    "plan_check": true,
    "verifier": true
  },
  "parallelization": {
    "enabled": true
  },
  "git": {
    "branching_strategy": "phase",
    "phase_branch_template": "gsd/phase-{phase}-{slug}"
  }
}
```

**Model profile:** `quality` for planning phases, `balanced` for execution phases.

---

## Success Criteria

1. `flutter analyze` returns zero issues
2. `flutter test` passes with ≥ 85% coverage
3. `pana` returns 160/160 points
4. All Tailwind v4 token values are pixel-accurate
5. Example app runs on all 6 platforms
6. README includes working code snippets for all three tiers
7. Every public API has dartdoc with `/// Example:` blocks
8. Package can be added to an existing Flutter project and used alongside Material widgets with zero conflicts
