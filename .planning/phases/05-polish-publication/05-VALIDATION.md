---
phase: 5
slug: polish-publication
status: complete
nyquist_compliant: true
wave_0_complete: true
created: 2026-03-12
audited: 2026-03-12
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | flutter_test (SDK-bundled) |
| **Config file** | test/flutter_test_config.dart |
| **Quick run command** | `flutter test test/src/goldens/golden_test.dart` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~8 seconds |

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
| 05-01-01 | 01 | 1 | INF-03 | smoke | `cd example && flutter pub get && flutter analyze` | ✅ | ✅ green |
| 05-01-02 | 01 | 1 | INF-05 | golden | `flutter test test/src/goldens/golden_test.dart` | ✅ | ✅ green |
| 05-02-01 | 02 | 1 | INF-06 | manual | Verify README content | N/A | ✅ green |
| 05-02-02 | 02 | 1 | INF-08 | manual | pana validates changelog format | N/A | ✅ green |
| 05-02-03 | 02 | 1 | INF-10 | unit | `dart format --set-exit-if-changed lib/` | ✅ | ✅ green |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [x] `test/src/goldens/golden_test.dart` — golden test file for INF-05
- [x] `example/` directory with full Flutter app — covers INF-03
- [x] `dart format .` on lib/ — fixes 10-point pana deduction
- [x] Library-level dartdoc comment on barrel file — fixes 1 missing doc element (INF-10)

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| README has quick-start, API overview, Tailwind comparison | INF-06 | Content quality review | Read README.md, verify sections present and accurate |
| CHANGELOG follows Keep a Changelog format | INF-08 | Format validation | Read CHANGELOG.md, verify v0.1.0 entry with proper sections |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** complete

---

## Validation Audit 2026-03-12

| Metric | Count |
|--------|-------|
| Gaps found | 0 |
| Resolved | 0 |
| Escalated | 0 |

### Verification Evidence

- **INF-03**: `cd example && flutter pub get && flutter analyze --no-fatal-infos` — No issues found
- **INF-05**: `flutter test test/src/goldens/golden_test.dart` — 8/8 golden tests pass (4 scenarios x 2 themes)
- **INF-10**: `dart format --set-exit-if-changed lib/` — 16 files, 0 changed
- **INF-06**: README.md has 270 lines with 14 sections including Quick Start, API Overview, Tailwind CSS comparison table
- **INF-08**: CHANGELOG.md has [0.1.0] entry in Keep a Changelog format
- **Full suite**: 321 tests pass
