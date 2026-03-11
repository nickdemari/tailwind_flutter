---
phase: 2
slug: token-system-theme-integration
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-11
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter_test (SDK bundled) |
| **Config file** | None needed — flutter_test works out of the box |
| **Quick run command** | `flutter test --no-pub` |
| **Full suite command** | `flutter test --coverage` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test --no-pub`
- **After every plan wave:** Run `flutter test --coverage`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 1 | TOK-01, TOK-02 | unit | `flutter test test/src/tokens/colors_test.dart` | ❌ W0 | ⬜ pending |
| 02-01-02 | 01 | 1 | TOK-03, TOK-04 | unit | `flutter test test/src/tokens/spacing_test.dart` | ❌ W0 | ⬜ pending |
| 02-01-03 | 01 | 1 | TOK-05, TOK-06, TOK-07, TOK-08 | unit | `flutter test test/src/tokens/typography_test.dart` | ❌ W0 | ⬜ pending |
| 02-01-04 | 01 | 1 | TOK-09 | unit | `flutter test test/src/tokens/radius_test.dart` | ❌ W0 | ⬜ pending |
| 02-01-05 | 01 | 1 | TOK-10 | unit | `flutter test test/src/tokens/shadows_test.dart` | ❌ W0 | ⬜ pending |
| 02-01-06 | 01 | 1 | TOK-11 | unit | `flutter test test/src/tokens/opacity_test.dart` | ❌ W0 | ⬜ pending |
| 02-01-07 | 01 | 1 | TOK-12 | unit | `flutter test test/src/tokens/breakpoints_test.dart` | ❌ W0 | ⬜ pending |
| 02-02-01 | 02 | 2 | THM-01 | unit | `flutter test test/src/theme/tw_theme_extension_test.dart` | ❌ W0 | ⬜ pending |
| 02-02-02 | 02 | 2 | THM-02 | widget | `flutter test test/src/theme/tw_theme_test.dart` | ❌ W0 | ⬜ pending |
| 02-02-03 | 02 | 2 | THM-03, THM-04 | widget | `flutter test test/src/theme/tw_theme_data_test.dart` | ❌ W0 | ⬜ pending |
| 02-03-01 | 03 | 2 | INF-04 | meta | `flutter test --coverage` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/src/tokens/` directory — create
- [ ] `test/src/theme/` directory — create
- [ ] `test/src/tokens/colors_test.dart` — stubs for TOK-01, TOK-02
- [ ] `test/src/tokens/spacing_test.dart` — stubs for TOK-03, TOK-04
- [ ] `test/src/tokens/typography_test.dart` — stubs for TOK-05, TOK-06, TOK-07, TOK-08
- [ ] `test/src/tokens/radius_test.dart` — stubs for TOK-09
- [ ] `test/src/tokens/shadows_test.dart` — stubs for TOK-10
- [ ] `test/src/tokens/opacity_test.dart` — stubs for TOK-11
- [ ] `test/src/tokens/breakpoints_test.dart` — stubs for TOK-12
- [ ] `test/src/theme/tw_theme_extension_test.dart` — stubs for THM-01
- [ ] `test/src/theme/tw_theme_test.dart` — stubs for THM-02
- [ ] `test/src/theme/tw_theme_data_test.dart` — stubs for THM-03, THM-04

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
