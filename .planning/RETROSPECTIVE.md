# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.0 — MVP

**Shipped:** 2026-03-12
**Phases:** 5 | **Plans:** 13

### What Was Built
- Complete Tailwind v4 token system (242 colors, 35 spacing, typography, radius, shadows, opacity, breakpoints) as compile-time const extension types
- Theme integration layer with 7 ThemeExtension classes, context.tw resolver, TwTheme widget, light/dark presets
- 30 chainable widget/text extension methods for Tailwind-style utility styling
- TwStyle composable styling with merge, resolve (dark/light), and apply (CSS box model widget tree)
- Publication-ready package: example app (3 tabs), 8 golden tests, 270-line README, 160/160 pana, CI pipeline

### What Worked
- TDD RED/GREEN commit pattern kept each plan clean and incremental — tests failed first, then passed
- Extension types for tokens delivered zero-cost abstractions that compile to literals with full autocomplete
- Barrel export progressive uncommenting — each phase activated its exports without touching prior code
- Yolo mode with auto-advance chained all 13 plans with minimal human intervention
- Phase 2 token parallelization — independent token files built concurrently within the phase

### What Was Inefficient
- ROADMAP.md plan checkboxes got out of sync for Phases 3-5 (showed unchecked despite completion) — bookkeeping overhead
- Phase 4 marked "Not started" in progress table despite being complete — STATE.md was accurate but ROADMAP.md wasn't
- Summary-extract CLI returned null for one_liner fields — had to read summaries manually at milestone completion
- Some info-level analyzer warnings accumulated across phases instead of being cleaned up incrementally

### Patterns Established
- Extension type wrapping named-field records for zero-cost typed tokens (`TwColorFamily`, `TwSpace`, `TwFontSize`, `TwRadius`)
- `resolve-then-apply` two-step pattern for composable styles — resolve variants first, apply to widget tree second
- Manual `==` / `hashCode` over equatable to maintain zero-dependency constraint
- `_copyWith` helper pattern for Text extensions that preserves all 13 constructor parameters
- Ahem font + fixed SizedBox harness for deterministic golden tests across CI environments

### Key Lessons
1. Extension types that `implement double` can't include non-numeric values like "auto" — design around this limitation early
2. `Theme.of(context).brightness` is more reliable than `MediaQuery.platformBrightness` for dark mode resolution
3. VGA (very_good_analysis) version must match SDK constraint — 5.1.0 for Dart >=3.3.0, not latest
4. Golden tests need explicit font loading (Ahem) and fixed dimensions — no ambient theme or flexible layout

### Cost Observations
- Model mix: quality profile throughout (Opus for planning/execution, Sonnet for agents)
- Total execution across 13 plans averaged ~4 minutes per plan
- Notable: 2-day wall clock from empty directory to publication-ready package

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Phases | Plans | Key Change |
|-----------|--------|-------|------------|
| v1.0 | 5 | 13 | Initial milestone — established TDD, extension type, and barrel export patterns |

### Cumulative Quality

| Milestone | Tests | Coverage | LOC | Pana Score |
|-----------|-------|----------|-----|------------|
| v1.0 | 321 | 98.9% | 7,854 | 160/160 |

### Top Lessons (Verified Across Milestones)

1. (Single milestone — lessons above will be cross-validated in future milestones)
