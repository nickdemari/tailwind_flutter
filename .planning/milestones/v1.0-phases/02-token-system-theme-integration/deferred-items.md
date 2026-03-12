# Phase 2: Deferred Items

## Pre-existing Issues (Out of Scope)

### 1. colors.dart trailing comma in extension type representation field
- **File:** `lib/src/tokens/colors.dart:27`
- **Error:** `The representation field can't have a trailing comma.`
- **Impact:** `colors_test.dart` compilation fails; cascades to `tailwind_flutter_test.dart` when loaded in same test runner process
- **Discovered during:** Plan 02-03 (opacity + breakpoints)
- **Action:** Should be fixed by the plan that owns colors.dart (02-01)
