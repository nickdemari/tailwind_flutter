---
phase: 5
slug: polish-publication
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-12
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter_test (SDK-bundled) |
| **Config file** | test/flutter_test_config.dart (Wave 0 creates if needed) |
| **Quick run command** | `flutter test test/src/goldens/golden_test.dart` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test`
- **After every plan wave:** Run `flutter test && dart pub global run pana --no-warning`
- **Before `/gsd:verify-work`:** Full suite must be green + pana 160/160
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 05-01-01 | 01 | 1 | INF-03 | smoke | `cd example && flutter pub get && flutter analyze` | ❌ W0 | ⬜ pending |
| 05-01-02 | 01 | 1 | INF-05 | golden | `flutter test test/src/goldens/golden_test.dart` | ❌ W0 | ⬜ pending |
| 05-02-01 | 02 | 1 | INF-06 | manual | Verify README content | N/A | ⬜ pending |
| 05-02-02 | 02 | 1 | INF-08 | manual | pana validates changelog format | N/A | ⬜ pending |
| 05-02-03 | 02 | 1 | INF-10 | unit | `dart pub global run pana --no-warning 2>&1 \| grep "API has dartdoc"` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/src/goldens/golden_test.dart` — golden test file for INF-05
- [ ] `example/` directory with full Flutter app — covers INF-03
- [ ] `dart format .` on lib/ — fixes 10-point pana deduction
- [ ] Library-level dartdoc comment on barrel file — fixes 1 missing doc element (INF-10)

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| README has quick-start, API overview, Tailwind comparison | INF-06 | Content quality review | Read README.md, verify sections present and accurate |
| CHANGELOG follows Keep a Changelog format | INF-08 | Format validation | Read CHANGELOG.md, verify v0.1.0 entry with proper sections |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
