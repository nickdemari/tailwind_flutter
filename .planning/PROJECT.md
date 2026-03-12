# tailwind_flutter

## What This Is

A pub.dev-published Flutter package that brings Tailwind CSS's design philosophy — constraint-based tokens, composable utilities, progressive disclosure — to Flutter as idiomatic Dart. It provides a three-tier API (raw tokens → widget extensions → composable styles) that reduces styling boilerplate while preserving 100% of Dart's type safety and Flutter's widget model. Built for incremental adoption alongside existing Material/Cupertino code.

## Core Value

Complete Tailwind v4 design token parity expressed as type-safe, const Dart values with a composable utility API that enhances — never replaces — Flutter's existing ThemeData system.

## Requirements

### Validated

- ✓ Complete Tailwind v4 color palette (22 families × 11 shades = 242 colors) as extension types — v1.0
- ✓ Full spacing scale (35 values, 4px base unit) with EdgeInsets convenience getters — v1.0
- ✓ Typography scale (13 sizes with paired line-heights, 9 font weights, letter spacing, line height) — v1.0
- ✓ Border radius scale (10 values) and box shadow presets (7 levels) — v1.0
- ✓ Opacity scale and breakpoint constants — v1.0
- ✓ ThemeExtension<T> classes with copyWith and lerp for all token categories — v1.0
- ✓ TwTheme widget + TwThemeData resolver via context.tw with light/dark presets — v1.0
- ✓ Widget extensions (padding, margin, bg, rounded, opacity, shadow, sizing, alignment, clip) — v1.0
- ✓ Text-specific extensions (bold, italic, fontSize, textColor, etc.) — v1.0
- ✓ TwStyle immutable class with merge, resolve (dark/light variants), and apply — v1.0
- ✓ Package infrastructure: 160/160 pub.dev points, example app, tests, docs, CI/CD — v1.0

### Active

(None yet — next milestone will define new requirements)

### Out of Scope

- Component library (buttons, cards, modals) — this is a styling primitive package
- Layout utilities — Flutter's Row/Column/Flex are sufficient
- String-based class parsing ("bg-blue-500") — always typed Dart
- CSS-in-Dart or stylesheet abstraction layers
- Build-time code generation required from consumers
- State management / navigation integration
- Dart macros (paused by Dart team as of Jan 2025)

## Context

- **Current state:** v1.0 shipped — 7,854 LOC Dart, 321 tests (98.9% coverage), 160/160 pana score
- **Tech stack:** Dart 3.3+ / Flutter 3.19+, zero third-party deps, very_good_analysis 5.1.0
- **Competitive landscape:** Mix (complex DSL, high learning curve), VelocityX (kitchen-sink, .make() footgun), styled_widget (unmaintained, no tokens)
- **Target audience:** Flutter developers who want Tailwind-like DX without leaving Dart's type system
- **Adoption strategy:** Incremental — one spacing constant works in an existing project without rewriting anything
- **Publication target:** pub.dev with Flutter Favorite candidacy
- **Author:** Nick
- **Known tech debt:** 12 non-critical items (info-level analyzer warnings in tests, example app doesn't demo all token categories, EdgeInsets narrowing from EdgeInsetsGeometry)

## Constraints

- **Tech Stack**: Dart 3.3+ / Flutter 3.19+, all 6 platforms — locked decision
- **Dependencies**: Zero third-party deps beyond Flutter SDK
- **Const-everything**: All tokens must be compile-time constants
- **Extension types**: `implements` base type (e.g., TwSpace implements double) for zero-cost abstraction
- **Analysis**: flutter analyze zero warnings with strict lints
- **Coverage**: Test coverage ≥ 85% for all non-generated code
- **Docs**: Dartdoc coverage ≥ 80% on all public APIs
- **License**: MIT

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Extension types (Dart 3.3) for tokens | Zero-runtime-cost typed tokens, compile to literals | ✓ Good — TwColorFamily, TwSpace, TwFontSize, TwRadius all work as zero-cost wrappers |
| ThemeExtension<T> for theme integration | Standard Flutter mechanism, works with existing ThemeData | ✓ Good — 7 category-specific extensions with full copyWith/lerp |
| Three-tier layered API | Progressive disclosure: use what you need, ignore what you don't | ✓ Good — tokens, extensions, and styles are independently usable |
| No build_runner for consumers | Ship pre-generated tokens, lower adoption friction | ✓ Good — zero setup cost for consumers |
| Terminal .apply() for TwStyle | Explicit rendering step, avoids VelocityX's .make() footgun | ✓ Good — resolve-then-apply is clear two-step pattern |
| Widget extensions wrap in parent widgets | Flutter-idiomatic, each .p() wraps in Padding, etc. | ✓ Good — chaining produces correct widget trees |
| Manual == / hashCode over equatable | Zero external deps for 8-field TwStyle class | ✓ Good — keeps zero-dep constraint |
| Letter spacing as em multipliers | Matches CSS/Tailwind convention | ⚠️ Revisit — users must multiply by fontSize for absolute value |
| EdgeInsets? not EdgeInsetsGeometry? for TwStyle | Simpler API, covers 95% of use cases | ⚠️ Revisit — excludes EdgeInsetsDirectional for RTL |

---
*Last updated: 2026-03-12 after v1.0 milestone*
