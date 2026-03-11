# Phase 1: Infrastructure Foundation - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Package scaffolding that passes CI, scores well on pana conventions, and is ready to receive token code. Delivers: pubspec.yaml, analysis_options.yaml, barrel export, GitHub Actions CI pipeline, and the lib/src/ directory structure with placeholder files.

</domain>

<decisions>
## Implementation Decisions

### Linting Strategy
- Use `very_good_analysis ^10.2.0` (overrides PRD's `flutter_lints` — research confirmed VGA has 86%+ rule coverage and is the pub.dev standard for high-scoring packages)
- PRD's `flutter_lints` reference is superseded — VGA is strictly stronger and includes flutter_lints rules as a subset
- Zero warnings tolerance from first commit

### SDK Constraints
- Dart SDK: `>=3.3.0 <4.0.0` (minimum for extension types)
- Flutter SDK: `>=3.19.0` (corresponding Flutter version for Dart 3.3)
- These are locked from the PRD — no flexibility

### CI Pipeline
- GitHub Actions with `subosito/flutter-action` for Flutter setup
- Jobs: `flutter analyze`, `flutter test`, `dart pub publish --dry-run`
- Test against minimum Flutter 3.19 AND current stable to ensure SDK constraint range works
- VGV reusable workflows are preferred if compatible with minimum Flutter constraint; custom workflows as fallback

### Package Metadata
- Package name: `tailwind_flutter`
- License: MIT
- Zero third-party dependencies (Flutter SDK only)
- Topics for pub.dev discovery: `tailwind`, `design-tokens`, `styling`, `theme`, `utility`
- Homepage/repository: Claude's discretion (placeholder URL, updated before publication)

### Directory Structure
- Follow PRD's file structure exactly: `lib/src/tokens/`, `lib/src/theme/`, `lib/src/extensions/`, `lib/src/styles/`
- Barrel export at `lib/tailwind_flutter.dart` — structured with commented sections but exports commented out until files exist
- Stub files in each directory (empty but valid Dart) so the structure is navigable from day one

### Claude's Discretion
- Exact pubspec.yaml description wording (within pub.dev character limits)
- Whether to include `funding` or `screenshots` sections in pubspec initially
- GitHub Actions workflow file organization (single vs multi-file)
- Whether barrel export uses `part`/`part of` or plain exports (research confirms plain exports are standard)
- Smoke test implementation for `flutter test` to pass

</decisions>

<specifics>
## Specific Ideas

- PRD specifies exact barrel export structure with organized sections (Tokens, Theme, Widget Extensions, Style Composition)
- Research confirmed 160/160 pub.dev scoring breakdown: Conventions 30 + Documentation 20 + Platforms 20 + Static Analysis 50 + Dependencies 40
- `very_good_analysis` may require Dart ^3.11 as dev dep — verify this is non-transitive (dev deps should not affect consumers on Dart 3.3)

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- None — greenfield project, no existing code

### Established Patterns
- None yet — this phase establishes the patterns

### Integration Points
- Barrel export structure must match PRD's shared contracts section exactly
- Directory structure must support the module boundary map from PRD (Module A-E)

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-infrastructure-foundation*
*Context gathered: 2026-03-11*
