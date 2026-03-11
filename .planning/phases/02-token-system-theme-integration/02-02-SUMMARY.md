---
phase: 02-token-system-theme-integration
plan: 02
subsystem: tokens
tags: [typography, font-size, font-weight, letter-spacing, line-height, border-radius, box-shadow, extension-type, tailwind-v4]

# Dependency graph
requires:
  - phase: 01-infrastructure-foundation
    provides: package scaffold, barrel export, CI pipeline
provides:
  - TwFontSize extension type with paired size + lineHeight + textStyle getter
  - TwFontSizes (13 entries), TwFontWeights (9), TwLetterSpacing (6), TwLineHeights (6)
  - TwRadius extension type implementing double with 5 BorderRadius getters
  - TwRadii (10 entries from none to full)
  - TwShadows (9 const List<BoxShadow> presets including inner approximation)
affects: [theme-integration, tw-style, widget-extensions]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Extension type wrapping named-field record for multi-value tokens (TwFontSize)"
    - "Extension type implementing double for transparent usage with convenience getters (TwRadius)"
    - "Abstract final class with static const List<BoxShadow> for shadow presets"
    - "Letter spacing stored as em multipliers, not absolute pixels"

key-files:
  created:
    - lib/src/tokens/typography.dart
    - lib/src/tokens/radius.dart
    - lib/src/tokens/shadows.dart
    - test/src/tokens/typography_test.dart
    - test/src/tokens/radius_test.dart
    - test/src/tokens/shadows_test.dart
  modified: []

key-decisions:
  - "Letter spacing stored as em multipliers -- users multiply by fontSize for absolute value"
  - "Inner shadow is an outer shadow approximation -- Flutter lacks inset BoxShadow support"
  - "TwFontSize line-heights stored as truncated 4-decimal-place ratios matching Tailwind calc() values"

patterns-established:
  - "TDD RED/GREEN flow for token files: failing test commit, then implementation commit"
  - "Extension type wrapping record pattern for compound tokens"
  - "Dartdoc on all public API with usage examples"

requirements-completed: [TOK-05, TOK-06, TOK-07, TOK-08, TOK-09, TOK-10]

# Metrics
duration: 4min
completed: 2026-03-11
---

# Phase 2 Plan 02: Typography, Radius, and Shadow Tokens Summary

**TwFontSize extension type pairing 13 font sizes with line-heights plus TwFontWeights/TwLetterSpacing/TwLineHeights, TwRadius with BorderRadius getters, and TwShadows with 9 const BoxShadow presets**

## Performance

- **Duration:** 4 min
- **Started:** 2026-03-11T22:13:13Z
- **Completed:** 2026-03-11T22:17:32Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments
- 13 font sizes with paired Tailwind v4 line-height ratios, accessible via TwFontSize.textStyle for the "text-lg implies size + line-height" pattern
- 9 font weights, 6 letter spacing em multipliers, and 6 line height ratios as const values
- 10 border radius values with 5 BorderRadius getters each (all, top, bottom, left, right), TwRadius implements double for transparent usage
- 9 shadow presets as const List<BoxShadow> matching Tailwind v4 CSS values, including inner shadow approximation
- 82 new tests across 3 test files, all passing with zero analyzer warnings

## Task Commits

Each task was committed atomically (TDD RED then GREEN):

1. **Task 1: Typography tokens** - `f251a60` (test: RED), `de4d817` (feat: GREEN)
2. **Task 2: Radius and shadow tokens** - `a3bd15a` (test: RED), `ab78e2b` (feat: GREEN)

## Files Created/Modified
- `lib/src/tokens/typography.dart` - TwFontSize extension type, TwFontSizes, TwFontWeights, TwLetterSpacing, TwLineHeights
- `lib/src/tokens/radius.dart` - TwRadius extension type with BorderRadius getters, TwRadii
- `lib/src/tokens/shadows.dart` - TwShadows abstract final class with 9 const List<BoxShadow> presets
- `test/src/tokens/typography_test.dart` - 40 tests covering all font sizes, weights, letter spacing, line heights
- `test/src/tokens/radius_test.dart` - 20 tests covering radius values and BorderRadius getters
- `test/src/tokens/shadows_test.dart` - 22 tests covering all 9 shadow presets with BoxShadow value assertions

## Decisions Made
- Letter spacing values stored as em multipliers (e.g. -0.05) rather than absolute pixels -- users multiply by their font size for Flutter's `TextStyle.letterSpacing`
- Inner shadow preset uses an outer shadow approximation with the same offset/blur/color values, since Flutter's BoxShadow does not support CSS `inset` -- documented in dartdoc
- TwFontSize line-height ratios truncated to 4 decimal places matching Tailwind v4's calc() results (e.g. 16/12 = 1.3333, not 1.333333...)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed dartdoc comment_references lint warning**
- **Found during:** Task 1 (typography implementation)
- **Issue:** Dartdoc `[fontSize]` and `[height]` references in TwFontSize.textStyle not resolvable in scope
- **Fix:** Changed to backtick-quoted ``fontSize`` and ``height`` instead of bracket-linked references
- **Files modified:** lib/src/tokens/typography.dart
- **Verification:** `flutter analyze` reports zero issues
- **Committed in:** de4d817 (part of Task 1 GREEN commit)

---

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** Trivial dartdoc fix required by strict very_good_analysis linting. No scope creep.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Typography, radius, and shadow tokens complete and tested
- Barrel exports still commented in `lib/tailwind_flutter.dart` -- will be uncommented when the barrel export plan executes
- Theme integration (TwTypographyTheme, TwRadiusTheme, TwShadowTheme) can now reference these token types

## Self-Check: PASSED

All 6 files verified present. All 4 commit hashes verified in git log.

---
*Phase: 02-token-system-theme-integration*
*Completed: 2026-03-11*
