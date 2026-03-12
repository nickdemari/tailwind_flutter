---
phase: 04-style-composition
plan: 01
subsystem: ui
tags: [dart-sealed-class, immutable-data, style-composition, css-box-model]

# Dependency graph
requires:
  - phase: 02-token-system
    provides: "TwSpacing, TwRadii, TwShadows, TwColors token types used as TwStyle property values"
provides:
  - "TwVariant sealed class with dark/light brightness matching"
  - "TwStyle immutable data class with 8 visual properties, copyWith, merge, equality"
  - "Barrel export with styles tier uncommented"
affects: [04-02-PLAN, 05-quality-polish]

# Tech tracking
tech-stack:
  added: []
  patterns: ["sealed class with const singletons for exhaustive switching", "manual == / hashCode with listEquals and mapEquals for collection fields", "right-side-wins merge with null-coalescing"]

key-files:
  created:
    - test/src/styles/tw_variant_test.dart
    - test/src/styles/tw_style_test.dart
  modified:
    - lib/src/styles/tw_variant.dart
    - lib/src/styles/tw_style.dart
    - lib/tailwind_flutter.dart

key-decisions:
  - "Manual == / hashCode over equatable -- zero external deps for 8-field class"
  - "merge strips variants from both sides -- flat output consistent with resolve-then-apply pattern"
  - "Barrel export sorted alphabetically without tier comments per VGA directives_ordering"
  - "Deleted tw_styled_widget.dart stub per CONTEXT.md decision (dropped from requirements)"

patterns-established:
  - "Sealed class + const singletons: private constructors, static const instances, matches() method"
  - "Immutable data class: @immutable, const constructor, copyWith with ?? pattern, manual equality"
  - "Right-side-wins merge: other.field ?? this.field for all properties, variants explicitly null"

requirements-completed: [STY-01, STY-02, STY-04]

# Metrics
duration: 4min
completed: 2026-03-12
---

# Phase 4 Plan 1: Style Data Types Summary

**TwVariant sealed class with dark/light brightness matching and TwStyle immutable data class with 8 visual properties, equality, copyWith, and right-side-wins merge**

## Performance

- **Duration:** 4 min
- **Started:** 2026-03-12T03:19:48Z
- **Completed:** 2026-03-12T03:24:24Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments
- TwVariant sealed class with TwDarkVariant and TwLightVariant enabling exhaustive switch and brightness matching
- TwStyle immutable data class with 8 nullable visual properties plus variants map
- Manual equality with listEquals for shadows and mapEquals for variants
- copyWith (preserves unspecified), merge (right-side-wins, strips variants)
- 23 tests across 5 groups: brightness matching, const identity, construction, equality, copyWith, merge
- Barrel export updated: styles tier uncommented, sorted alphabetically, deleted tw_styled_widget.dart stub

## Task Commits

Each task was committed atomically:

1. **Task 1: RED -- Write failing tests for TwVariant and TwStyle** - `8599744` (test)
2. **Task 2: GREEN -- Implement TwVariant sealed class and TwStyle data class** - `27bfd91` (feat)

## Files Created/Modified
- `lib/src/styles/tw_variant.dart` - TwVariant sealed class with dark/light brightness matching
- `lib/src/styles/tw_style.dart` - TwStyle immutable class with 8 properties, copyWith, merge, equality
- `lib/tailwind_flutter.dart` - Barrel export updated: styles uncommented, sorted, tw_styled_widget removed
- `lib/src/styles/tw_styled_widget.dart` - Deleted (dropped from requirements per CONTEXT.md)
- `test/src/styles/tw_variant_test.dart` - 7 tests for brightness matching, const identity, exhaustive switch
- `test/src/styles/tw_style_test.dart` - 16 tests for construction, equality, copyWith, merge

## Decisions Made
- Manual `==` / `hashCode` over equatable package -- zero external deps for a single 8-field class
- merge strips variants from both sides -- flat output consistent with resolve-then-apply pattern
- Barrel export sorted alphabetically without tier section comments to satisfy VGA `directives_ordering` rule
- Deleted `tw_styled_widget.dart` stub per CONTEXT.md decision (TwStyledWidget dropped from requirements)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed analyzer issues in new files**
- **Found during:** Task 2 (implementation)
- **Issue:** `unnecessary_import` (painting.dart redundant with rendering.dart), `always_use_package_imports` (relative import of tw_variant.dart), `comment_references` (library-level doc refs to out-of-scope types), `directives_ordering` (unsorted barrel exports)
- **Fix:** Removed redundant painting.dart import, used package: import for tw_variant, changed bracket doc refs to backtick for library-level docs, sorted all barrel exports alphabetically
- **Files modified:** lib/src/styles/tw_style.dart, lib/src/styles/tw_variant.dart, lib/tailwind_flutter.dart, test/src/styles/tw_style_test.dart
- **Verification:** `flutter analyze --no-fatal-infos` shows zero errors/warnings in modified files
- **Committed in:** 27bfd91 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking -- analyzer compliance)
**Impact on plan:** Necessary for analyzer-clean output. No scope creep.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- TwVariant and TwStyle data types ready for Plan 02 (apply/resolve methods)
- Equality semantics verified -- safe for use as map values and comparison
- merge behavior confirmed -- Plan 02 can build resolve() on top of merge()

## Self-Check: PASSED

- All 6 expected files found on disk
- tw_styled_widget.dart confirmed deleted
- Both task commits (8599744, 27bfd91) verified in git log

---
*Phase: 04-style-composition*
*Completed: 2026-03-12*
