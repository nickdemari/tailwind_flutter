# Roadmap: tailwind_flutter

## Overview

Deliver a pub.dev-published Flutter package that brings Tailwind CSS's design token system and composable styling to Flutter as idiomatic Dart. The build progresses from package scaffolding through a three-tier API (tokens, widget extensions, composable styles) to publication-ready polish. Each phase delivers a complete, testable capability layer.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Infrastructure Foundation** - Package scaffolding, CI/CD pipeline, linting, barrel exports, and analysis — everything needed before writing a single token (completed 2026-03-11)
- [x] **Phase 2: Token System + Theme Integration** - All 7 token categories as const Dart values with extension types, plus ThemeExtension classes, TwTheme widget, and context.tw resolver (completed 2026-03-11)
- [x] **Phase 3: Widget Extensions** - Padding, margin, background, radius, opacity, shadow, sizing, alignment, clip, and text-specific chaining extensions on Widget/Text (completed 2026-03-11)
- [ ] **Phase 4: Style Composition** - TwStyle immutable class with merge, resolve, and apply — the composable styling tier that ties everything together
- [ ] **Phase 5: Polish + Publication** - Example app, golden tests, README, CHANGELOG, dartdoc coverage audit, and pana score verification for 160/160 pub.dev points

## Phase Details

### Phase 1: Infrastructure Foundation
**Goal**: A Flutter package skeleton that passes CI, scores well on pana conventions, and is ready to receive token code without rework
**Depends on**: Nothing (first phase)
**Requirements**: INF-01, INF-02, INF-07, INF-09
**Success Criteria** (what must be TRUE):
  1. `flutter analyze` runs with zero warnings against strict analysis_options.yaml
  2. `flutter test` executes successfully (even if only a smoke test exists)
  3. GitHub Actions CI pipeline runs analyze + test on every push
  4. `dart pub publish --dry-run` reports no blocking errors (conventions, platforms, analysis all pass)
  5. Barrel export file exists and is structured for organized category exports
**Plans:** 2/2 plans complete

Plans:
- [x] 01-01-PLAN.md — Package scaffold (pubspec, analysis, license, barrel export, stubs, smoke test)
- [x] 01-02-PLAN.md — GitHub Actions CI pipeline + local validation

### Phase 2: Token System + Theme Integration
**Goal**: Developers can import tailwind_flutter and use complete Tailwind v4 design tokens as type-safe const values, either directly (TwColors.blue.shade500) or via theme resolution (context.tw.colors)
**Depends on**: Phase 1
**Requirements**: TOK-01, TOK-02, TOK-03, TOK-04, TOK-05, TOK-06, TOK-07, TOK-08, TOK-09, TOK-10, TOK-11, TOK-12, THM-01, THM-02, THM-03, THM-04, INF-04
**Success Criteria** (what must be TRUE):
  1. All 242 colors + semantic colors are accessible as static const Color values with autocomplete
  2. Spacing values (TwSpace) work as doubles in any Flutter API expecting double, and provide EdgeInsets convenience getters
  3. Typography, radius, shadow, opacity, and breakpoint tokens are all accessible as const values with correct types
  4. Wrapping a widget tree in TwTheme provides token access via context.tw with light and dark presets
  5. All token values and theme resolution have unit test coverage >= 85%
**Plans:** 4/4 plans complete

Plans:
- [x] 02-01-PLAN.md — Colors (242 + semantics) and spacing (35 values + EdgeInsets getters)
- [x] 02-02-PLAN.md — Typography (font sizes, weights, letter spacing, line heights), radius, and shadows
- [x] 02-03-PLAN.md — Opacity scale and breakpoint constants
- [x] 02-04-PLAN.md — 7 ThemeExtension classes, TwThemeData resolver, TwTheme widget, presets, barrel export

### Phase 3: Widget Extensions
**Goal**: Developers can chain Tailwind-style utility methods on any Widget (and Text-specific methods on Text) to apply styling without manually nesting Padding/Container/DecoratedBox widgets
**Depends on**: Phase 2
**Requirements**: EXT-01, EXT-02, EXT-03, EXT-04, EXT-05, EXT-06, EXT-07, EXT-08, EXT-09, EXT-10
**Success Criteria** (what must be TRUE):
  1. Any Widget can be styled with chained calls like `.p(16).bg(TwColors.blue.shade500).rounded(TwRadius.lg)` producing the correct widget tree
  2. Text widget extensions (.bold(), .italic(), .fontSize(), .textColor(), etc.) preserve ALL original Text constructor parameters
  3. Extension methods compose correctly regardless of chaining order
  4. All extension methods have unit test coverage >= 85%
**Plans:** 2/2 plans complete

Plans:
- [ ] 03-01-PLAN.md — TwWidgetExtensions: padding, margin, background, radius, opacity, shadow, sizing, alignment, clip (EXT-01 through EXT-09)
- [ ] 03-02-PLAN.md — TwTextExtensions: text styling methods + barrel export update + stub cleanup (EXT-10)

### Phase 4: Style Composition
**Goal**: Developers can define reusable, composable style objects that merge, resolve dark/light variants, and apply to widgets in a single call — the "CSS class" equivalent for Flutter
**Depends on**: Phase 2, Phase 3
**Requirements**: STY-01, STY-02, STY-03, STY-04, STY-05
**Success Criteria** (what must be TRUE):
  1. TwStyle can be constructed with any combination of visual properties (padding, margin, backgroundColor, borderRadius, shadows, opacity, constraints, textStyle)
  2. Two TwStyles can be merged with right-side-wins semantics, enabling style composition patterns
  3. TwStyle.apply(child: widget) produces a correctly ordered widget tree matching CSS box model expectations
  4. TwStyle with dark/light variants resolves to the correct flat style based on platform brightness
**Plans**: TBD

Plans:
- [ ] 04-01: TBD

### Phase 5: Polish + Publication
**Goal**: The package achieves 160/160 pub.dev points with a polished example app, comprehensive golden tests, and documentation that makes adoption effortless
**Depends on**: Phase 4
**Requirements**: INF-03, INF-05, INF-06, INF-08, INF-10
**Success Criteria** (what must be TRUE):
  1. Example app in example/ demonstrates all three tiers (tokens, extensions, composable styles) and runs without errors
  2. Golden tests verify styled widget rendering across light and dark themes using Ahem font for CI stability
  3. README.md contains quick-start guide, API overview, and Tailwind CSS comparison that a new user can follow to first styled widget in < 5 minutes
  4. `pana` reports 160/160 points (or documents any unavoidable deductions with justification)
  5. Dartdoc coverage >= 80% on all public APIs
**Plans**: TBD

Plans:
- [ ] 05-01: TBD
- [ ] 05-02: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4 -> 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Infrastructure Foundation | 2/2 | Complete    | 2026-03-11 |
| 2. Token System + Theme Integration | 4/4 | Complete | 2026-03-11 |
| 3. Widget Extensions | 1/2 | Complete    | 2026-03-11 |
| 4. Style Composition | 0/1 | Not started | - |
| 5. Polish + Publication | 0/2 | Not started | - |
