---
phase: 4
slug: style-composition
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-11
---

# Phase 4 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter_test (SDK) |
| **Config file** | none (uses default flutter test runner) |
| **Quick run command** | `flutter test test/src/styles/` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test test/src/styles/`
- **After every plan wave:** Run `flutter test`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 04-01-01 | 01 | 1 | STY-04 | unit | `flutter test test/src/styles/tw_variant_test.dart` | ❌ W0 | ⬜ pending |
| 04-01-02 | 01 | 1 | STY-01 | unit | `flutter test test/src/styles/tw_style_test.dart --name "construction"` | ❌ W0 | ⬜ pending |
| 04-01-03 | 01 | 1 | STY-01 | unit | `flutter test test/src/styles/tw_style_test.dart --name "equality"` | ❌ W0 | ⬜ pending |
| 04-01-04 | 01 | 1 | STY-01 | unit | `flutter test test/src/styles/tw_style_test.dart --name "copyWith"` | ❌ W0 | ⬜ pending |
| 04-01-05 | 01 | 1 | STY-02 | unit | `flutter test test/src/styles/tw_style_test.dart --name "merge"` | ❌ W0 | ⬜ pending |
| 04-02-01 | 02 | 1 | STY-03 | widget | `flutter test test/src/styles/tw_style_test.dart --name "apply"` | ❌ W0 | ⬜ pending |
| 04-02-02 | 02 | 1 | STY-05 | widget | `flutter test test/src/styles/tw_style_test.dart --name "resolve"` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/src/styles/` directory creation
- [ ] `test/src/styles/tw_variant_test.dart` — stubs for STY-04
- [ ] `test/src/styles/tw_style_test.dart` — stubs for STY-01, STY-02, STY-03, STY-05

*Existing infrastructure covers framework and config — only test files needed.*

---

## Manual-Only Verifications

*All phase behaviors have automated verification.*

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
