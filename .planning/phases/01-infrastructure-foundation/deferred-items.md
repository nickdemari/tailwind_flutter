# Phase 1: Deferred Items

## Missing .gitignore

- **Discovered during:** 01-02 Task 2 (local CI validation)
- **Issue:** No `.gitignore` exists. `dart pub publish --dry-run` includes `build/` (43 MB) and `mvp.md` in the archive. Not a blocking issue (0 warnings), but the published package would be bloated.
- **Recommendation:** Add `.gitignore` with standard Dart/Flutter entries (`build/`, `.dart_tool/`, etc.) before first real publish. Could also add a `.pubignore` for finer control.
- **Scope:** Plan 01 (package scaffold) or pre-publish checklist in Phase 5.
