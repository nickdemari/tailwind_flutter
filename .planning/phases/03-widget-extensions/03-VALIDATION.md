---
phase: 3
slug: widget-extensions
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-11
---

# Phase 3 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter_test (SDK) |
| **Config file** | none (standard `flutter test` setup) |
| **Quick run command** | `flutter test test/src/extensions/` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test test/src/extensions/`
- **After every plan wave:** Run `flutter test`
- **Before `/gsd:verify-work`:** Full suite must be green + `flutter analyze` zero warnings
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | EXT-01 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-02 | 01 | 1 | EXT-02 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-03 | 01 | 1 | EXT-03 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-04 | 01 | 1 | EXT-04 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-05 | 01 | 1 | EXT-05 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-06 | 01 | 1 | EXT-06 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-07 | 01 | 1 | EXT-07 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-08 | 01 | 1 | EXT-08 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-01-09 | 01 | 1 | EXT-09 | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | ❌ W0 | ⬜ pending |
| 03-02-01 | 02 | 1 | EXT-10 | unit (widget test) | `flutter test test/src/extensions/text_extensions_test.dart` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/src/extensions/widget_extensions_test.dart` — stubs for EXT-01 through EXT-09
- [ ] `test/src/extensions/text_extensions_test.dart` — stubs for EXT-10
- No framework install needed — flutter_test already in dev_dependencies

*Existing infrastructure covers framework requirements.*

---

## Manual-Only Verifications

*All phase behaviors have automated verification.*

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
