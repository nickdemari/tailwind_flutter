---
phase: 1
slug: infrastructure-foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-11
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter_test (Flutter SDK built-in) |
| **Config file** | `pubspec.yaml` (test dependencies) |
| **Quick run command** | `flutter test` |
| **Full suite command** | `flutter test && flutter analyze && dart pub publish --dry-run` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test`
- **After every plan wave:** Run `flutter test && flutter analyze && dart pub publish --dry-run`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | INF-01 | integration | `dart pub publish --dry-run` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | INF-07 | integration | `flutter analyze` | ❌ W0 | ⬜ pending |
| 01-02-01 | 02 | 1 | INF-02 | unit | `flutter test` | ❌ W0 | ⬜ pending |
| 01-02-02 | 02 | 1 | INF-09 | integration | `flutter analyze && flutter test` (CI validates) | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/tailwind_flutter_test.dart` — smoke test that imports barrel export
- [ ] `pubspec.yaml` — with flutter_test dev dependency
- [ ] `analysis_options.yaml` — with very_good_analysis (version TBD per research)

*If none: "Existing infrastructure covers all phase requirements."*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| GitHub Actions CI runs on push | INF-09 | Requires GitHub infrastructure | Push to repo, verify workflow runs in Actions tab |
| pub.dev score conventions | INF-01 | pana scoring is server-side | Run `dart pub publish --dry-run` locally, verify no warnings |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
