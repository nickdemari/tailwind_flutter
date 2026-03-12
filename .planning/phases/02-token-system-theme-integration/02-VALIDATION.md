---
phase: 2
slug: token-system-theme-integration
status: complete
nyquist_compliant: true
wave_0_complete: true
created: 2026-03-11
audited: 2026-03-12
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
| **Actual runtime** | ~11 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test --no-pub`
- **After every plan wave:** Run `flutter test --coverage`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Tests | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|-------|--------|
| 02-01-01 | 01 | 1 | TOK-01, TOK-02 | unit | `flutter test test/src/tokens/colors_test.dart` | ✅ (177 lines) | 27 | ✅ green |
| 02-01-02 | 01 | 1 | TOK-03, TOK-04 | unit | `flutter test test/src/tokens/spacing_test.dart` | ✅ (112 lines) | 47 | ✅ green |
| 02-01-03 | 02 | 1 | TOK-05, TOK-06, TOK-07, TOK-08 | unit | `flutter test test/src/tokens/typography_test.dart` | ✅ (234 lines) | 40 | ✅ green |
| 02-01-04 | 02 | 1 | TOK-09 | unit | `flutter test test/src/tokens/radius_test.dart` | ✅ (122 lines) | 20 | ✅ green |
| 02-01-05 | 02 | 1 | TOK-10 | unit | `flutter test test/src/tokens/shadows_test.dart` | ✅ (173 lines) | 22 | ✅ green |
| 02-01-06 | 03 | 1 | TOK-11 | unit | `flutter test test/src/tokens/opacity_test.dart` | ✅ (162 lines) | 23 | ✅ green |
| 02-01-07 | 03 | 1 | TOK-12 | unit | `flutter test test/src/tokens/breakpoints_test.dart` | ✅ (61 lines) | 7 | ✅ green |
| 02-02-01 | 04 | 2 | THM-01 | unit | `flutter test test/src/theme/tw_theme_extension_test.dart` | ✅ (424 lines) | 28 | ✅ green |
| 02-02-02 | 04 | 2 | THM-02 | widget | `flutter test test/src/theme/tw_theme_test.dart` | ✅ (87 lines) | 4 | ✅ green |
| 02-02-03 | 04 | 2 | THM-03, THM-04 | widget | `flutter test test/src/theme/tw_theme_data_test.dart` | ✅ (186 lines) | 11 | ✅ green |
| 02-03-01 | 04 | 2 | INF-04 | meta | `flutter test --coverage` | ✅ | 321 total | ✅ 98.9% |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [x] `test/src/tokens/` directory — created
- [x] `test/src/theme/` directory — created
- [x] `test/src/tokens/colors_test.dart` — 27 tests for TOK-01, TOK-02
- [x] `test/src/tokens/spacing_test.dart` — 47 tests for TOK-03, TOK-04
- [x] `test/src/tokens/typography_test.dart` — 40 tests for TOK-05, TOK-06, TOK-07, TOK-08
- [x] `test/src/tokens/radius_test.dart` — 20 tests for TOK-09
- [x] `test/src/tokens/shadows_test.dart` — 22 tests for TOK-10
- [x] `test/src/tokens/opacity_test.dart` — 23 tests for TOK-11
- [x] `test/src/tokens/breakpoints_test.dart` — 7 tests for TOK-12
- [x] `test/src/theme/tw_theme_extension_test.dart` — 28 tests for THM-01
- [x] `test/src/theme/tw_theme_test.dart` — 4 widget tests for THM-02
- [x] `test/src/theme/tw_theme_data_test.dart` — 11 tests for THM-03, THM-04

---

## Coverage Report

| Source File | Lines Hit | Lines Found | Coverage |
|-------------|-----------|-------------|----------|
| lib/src/tokens/colors.dart | 11 | 11 | 100.0% |
| lib/src/tokens/spacing.dart | 7 | 7 | 100.0% |
| lib/src/tokens/typography.dart | 3 | 3 | 100.0% |
| lib/src/tokens/radius.dart | 13 | 13 | 100.0% |
| lib/src/tokens/shadows.dart | — | — | const-only (no executable lines) |
| lib/src/tokens/opacity.dart | — | — | const-only (no executable lines) |
| lib/src/tokens/breakpoints.dart | — | — | const-only (no executable lines) |
| lib/src/theme/tw_theme_extension.dart | 355 | 359 | 98.9% |
| lib/src/theme/tw_theme_data.dart | 45 | 46 | 97.8% |
| lib/src/theme/tw_theme.dart | 9 | 9 | 100.0% |
| **TOTAL (instrumented)** | **443** | **448** | **98.9%** |

*Note: opacity.dart, breakpoints.dart, and shadows.dart contain only `static const` declarations with zero executable statements. Dart's coverage tool correctly omits them. All values are exhaustively verified by their test files.*

---

## Manual-Only Verifications

*All phase behaviors have automated verification.*

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 15s (actual: ~11s)
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved

---

## Validation Audit 2026-03-12

| Metric | Count |
|--------|-------|
| Gaps found | 0 |
| Resolved | 0 |
| Escalated | 0 |
| Total tests | 321 |
| Line coverage | 98.9% |
