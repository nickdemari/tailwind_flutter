# tailwind_flutter

## What This Is

A pub.dev-published Flutter package that brings Tailwind CSS's design philosophy — constraint-based tokens, composable utilities, progressive disclosure — to Flutter as idiomatic Dart. It provides a three-tier API (raw tokens → widget extensions → composable styles) that reduces styling boilerplate by 60% while preserving 100% of Dart's type safety and Flutter's widget model. Built for incremental adoption alongside existing Material/Cupertino code.

## Core Value

Complete Tailwind v4 design token parity expressed as type-safe, const Dart values with a composable utility API that enhances — never replaces — Flutter's existing ThemeData system.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Complete Tailwind v4 color palette (22 families × 11 shades = 242 colors) as extension types
- [ ] Full spacing scale (37 values, 4px base unit) with EdgeInsets convenience getters
- [ ] Typography scale (13 sizes with paired line-heights, 9 font weights, letter spacing, line height)
- [ ] Border radius scale (10 values) and box shadow presets (7 levels)
- [ ] Opacity scale and breakpoint constants
- [ ] ThemeExtension<T> classes with copyWith and lerp for all token categories
- [ ] TwTheme widget + TwThemeData resolver via context.tw with light/dark presets
- [ ] Widget extensions (padding, margin, bg, rounded, opacity, shadow, sizing, alignment, clip)
- [ ] Text-specific extensions (bold, italic, fontSize, textColor, etc.)
- [ ] TwStyle immutable class with merge, resolve (dark/light variants), and apply
- [ ] Package infrastructure: 160/160 pub.dev points, example app, tests, docs, CI/CD

### Out of Scope

- Component library (buttons, cards, modals) — this is a styling primitive package
- Layout utilities — Flutter's Row/Column/Flex are sufficient
- String-based class parsing ("bg-blue-500") — always typed Dart
- CSS-in-Dart or stylesheet abstraction layers
- Build-time code generation required from consumers
- State management / navigation integration
- Dart macros (paused by Dart team as of Jan 2025)
- Responsive variants (v2)
- Hover/press interaction variants (v2)
- Animated styles (v2)
- Companion lint package (v2)

## Context

- **Competitive landscape:** Mix (complex DSL, high learning curve), VelocityX (kitchen-sink, .make() footgun), styled_widget (unmaintained, no tokens)
- **Target audience:** Flutter developers who want Tailwind-like DX without leaving Dart's type system
- **Adoption strategy:** Incremental — one spacing constant works in an existing project without rewriting anything
- **Publication target:** pub.dev with Flutter Favorite candidacy
- **Author:** Nick

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
| Extension types (Dart 3.3) for tokens | Zero-runtime-cost typed tokens, compile to literals | — Pending |
| ThemeExtension<T> for theme integration | Standard Flutter mechanism, works with existing ThemeData | — Pending |
| Three-tier layered API | Progressive disclosure: use what you need, ignore what you don't | — Pending |
| No build_runner for consumers | Ship pre-generated tokens, lower adoption friction | — Pending |
| Terminal .apply() for TwStyle | Explicit rendering step, avoids VelocityX's .make() footgun | — Pending |
| Widget extensions wrap in parent widgets | Flutter-idiomatic, each .p() wraps in Padding, etc. | — Pending |

---
*Last updated: 2026-03-11 after initialization*
