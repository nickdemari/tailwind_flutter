# Technology Stack

**Project:** tailwind_flutter
**Researched:** 2026-03-11

## Recommended Stack

### Core SDK Constraints

| Technology | Version Constraint | Purpose | Why | Confidence |
|------------|-------------------|---------|-----|------------|
| Dart SDK | `>=3.3.0 <4.0.0` | Language runtime | 3.3 is the floor for extension types (`extension type const TwSpace(double value) implements double`). This is the minimum viable SDK for the package's core abstraction. Do NOT raise to 3.7+ unless you need wildcard variables or tall-style formatting -- every bump shrinks your addressable install base. | HIGH |
| Flutter SDK | `>=3.19.0` | Framework | Flutter 3.19 ships with Dart 3.3. This is the paired minimum. Current stable is 3.41.2 (Feb 2026) so the vast majority of active developers are well above this floor. | HIGH |

**Why not target Dart 3.10+ / Flutter 3.38+?**
Dart 3.10 added dot shorthands (`.foo` instead of `ContextType.foo`) which is nice but not worth halving your install base for. Dart 3.3 gives you everything you actually need: extension types, sealed classes, records, patterns. The PRD already locked this decision -- research confirms it's correct.

**Why not target Dart 3.11 (current stable)?**
Because you're building a library, not an app. Libraries should target the lowest SDK that supports their required features. Targeting current stable is a consumer-hostile move that forces upgrades for zero benefit.

### Dependencies

| Dependency | Version | Type | Purpose | Why |
|------------|---------|------|---------|-----|
| `flutter` | SDK | direct | Widget tree, ThemeData, ThemeExtension | Required for extensions on Widget, BuildContext, ThemeExtension<T> |
| None | - | - | - | Zero third-party dependencies. This is non-negotiable for a styling primitive package. Every dep you add is a dep your consumers inherit. The PRD says zero deps -- research agrees this is correct for the package category. |

### Dev Dependencies

| Library | Version | Purpose | Why | Confidence |
|---------|---------|---------|-----|------------|
| `flutter_test` | SDK | Unit + widget testing | Ships with Flutter SDK. Provides `testWidgets`, `pumpWidget`, `matchesGoldenFile`, `expectLater`. No external test framework needed. | HIGH |
| `flutter_lints` | `^6.0.0` | Static analysis rules | The official Flutter team linting package. Pana scores against the core/recommended lints from `package:lints` which `flutter_lints` builds on. Using this ensures pana's "Pass static analysis" category (50 points) is satisfied. | HIGH |
| `very_good_analysis` | `^10.2.0` | Stricter lint superset | OPTIONAL, but recommended. VGA enables 86%+ of available lint rules including `strict-inference` and `strict-raw-types`. For a package targeting Flutter Favorite candidacy, this level of strictness is appropriate. Requires Dart ^3.11 as a dev dep only -- this does NOT affect consumer SDK constraints since dev deps are not transitive. | HIGH |
| `alchemist` | `^0.13.0` | Golden test framework | Replaced the discontinued `golden_toolkit`. Solves CI golden test flakes with Ahem font rendering. Provides `goldenTest`, `GoldenTestGroup`, platform vs CI test separation. Betterment (maintainer) is a reputable Flutter shop. | MEDIUM |

**IMPORTANT NOTE on `very_good_analysis` vs `flutter_lints`:**
You pick ONE of these, not both. If you use VGA, you do NOT also need `flutter_lints` -- VGA is a superset. The recommendation is:

- **Use `very_good_analysis`** for development (stricter, catches more issues)
- **Pana checks against `package:lints` rules** which VGA already includes and exceeds
- If VGA's Dart ^3.11 dev-dep constraint causes any issue during CI testing against the minimum Flutter 3.19, fall back to `flutter_lints` ^6.0.0 instead

### Analysis Configuration

Use `very_good_analysis` as the base with project-specific overrides:

```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    # Override VGA where needed for this package's patterns
    public_member_api_docs: true  # Enforce dartdoc on ALL public APIs (pub.dev requirement)
    sort_constructors_first: true
    prefer_single_quotes: true
```

**Why `very_good_analysis` over raw `flutter_lints`?**
`flutter_lints` is the minimum bar that pana checks. VGA is the bar that high-quality packages clear. Every Flutter Favorite candidate or top-liked package uses either VGA, `lint`, or a custom strict config. For a package that wants 160/160 pub points AND Flutter Favorite candidacy, VGA is the right call.

**Why not `lint` package instead?**
VGA is marginally stricter (188 rules vs 170 for `lint`), enables `strict-inference` and `strict-raw-types` in the analyzer section (not just lint rules), and is maintained by Very Good Ventures who literally build Flutter packages for a living. The difference is small, but VGA wins on pedigree and strictness.

### CI/CD Stack

| Tool | Version/Ref | Purpose | Why | Confidence |
|------|-------------|---------|-----|------------|
| GitHub Actions | - | CI/CD platform | Industry standard for open source Flutter. Free for public repos. | HIGH |
| `subosito/flutter-action` | `@v2` (latest: v2.15.0) | Flutter SDK setup in CI | De facto standard action for Flutter CI. Supports channel selection, version pinning, caching. | HIGH |
| `VeryGoodOpenSource/very_good_workflows` | `@v1` | Reusable CI workflows | Provides `flutter_package.yml` (analyze + test + coverage) and `pana.yml` (pub.dev score verification) as reusable workflows. Battle-tested across hundreds of VGV packages. | HIGH |
| `pana` | `0.23.10` | Package scoring verification | Run locally during dev AND in CI via VGV's `pana.yml` workflow. Catches scoring issues before publish. Set `min_score: 160` in CI. | HIGH |
| `very_good_coverage` | CLI tool | Coverage enforcement | Enforces minimum coverage threshold in CI. Set to 85% per PRD constraint. | MEDIUM |
| `lcov` | System tool | Coverage report generation | `flutter test --coverage` outputs `lcov.info`. Use `lcov -r` to exclude generated files if any exist. Standard approach. | HIGH |

### CI Workflow Architecture

```yaml
# .github/workflows/ci.yml -- recommended structure
name: CI

on:
  pull_request:
  push:
    branches: [main]

jobs:
  # Job 1: Semantic analysis + formatting + tests against minimum SDK
  analyze:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
    with:
      flutter_version: "3.19.0"  # Test against minimum supported
      min_coverage: 85

  # Job 2: Test against latest stable too
  analyze-latest:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
    with:
      flutter_channel: stable
      min_coverage: 85

  # Job 3: Verify pub.dev score
  pana:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/pana.yml@v1
    with:
      min_score: 160
```

**Why test against both minimum AND latest Flutter?**
Pana's "Support up-to-date dependencies" category (40 points) requires working with the latest stable SDK. But you also need to verify your `>=3.19.0` constraint actually works. Test both.

## Pub.dev Scoring Breakdown (160 Points Maximum)

Verified against actual pub.dev package score pages (e.g., `provider` shows 150/160). The scoring system was updated since the 2021 pana#975 issue that documented a 130 max. The current maximum is 160.

| Category | Max Points | How to Get Full Points |
|----------|-----------|----------------------|
| **Follow Dart file conventions** | 30 | Valid `pubspec.yaml` (10), valid `README.md` (5), valid `CHANGELOG.md` (5), OSI-approved license (10). Use MIT. |
| **Provide documentation** | 20 | Working example in `example/` directory (10), >= 20% of public API has dartdoc comments (10). Target 80%+ per PRD. |
| **Platform support** | 20 | Support all 6 Flutter platforms. Since this is a pure Dart + Flutter widgets package (no native code), all platforms are automatic. |
| **Pass static analysis** | 50 | Zero errors/warnings/lints from `flutter analyze` with the standard lints package. Zero formatting issues. This is the biggest category -- and where `provider` lost 10 points for just 2 type-parameter naming issues. |
| **Support up-to-date dependencies** | 40 | Work with latest stable Dart SDK, latest stable Flutter SDK, and all deps at latest versions. Zero third-party deps makes this trivial. |
| **TOTAL** | **160** | |

**Critical insight:** The zero-deps strategy makes 60 of 160 points essentially free (40 for up-to-date deps + 20 for platform support). The remaining 100 points come from documentation discipline and clean code. Static analysis at 50 points is the biggest single category -- one lint warning can cost you 10 points.

## Extension Types: Implementation Strategy

### Pattern: Transparent Extension Type with `implements`

```dart
extension type const TwSpace(double value) implements double {
  static const s0 = TwSpace(0);
  static const s1 = TwSpace(4);
  // ...
}
```

**Why `implements double`?**
- TwSpace values can be used anywhere a `double` is expected (e.g., `EdgeInsets.all(TwSpace.s4)`) without `.value`
- All `double` members (arithmetic, comparison) are available
- Zero runtime cost -- extension types are erased at compile time, so `TwSpace(4)` becomes `4.0` in the compiled output

**Known limitation -- runtime type erasure:**
`TwSpace.s4 is double` evaluates to `true` at runtime. `TwSpace.s4 is TwSpace` also evaluates to `true`. This is expected and harmless for a token system, but it means you cannot use `is`/`as` checks to distinguish between `TwSpace` and raw `double` at runtime. Document this behavior in the API docs.

**Known limitation -- const constructor required for const values:**
Extension types support `const` constructors, and the PRD requires all tokens to be compile-time constants. This works: `static const s4 = TwSpace(16)` compiles to a const literal. Verified against Dart language spec.

**Known limitation -- instance getters are NOT const:**
`TwSpace.s4.all` (where `.all` returns `EdgeInsets.all(value)`) is NOT a const expression even though both `TwSpace.s4` and `EdgeInsets.all` have const constructors. Dart's const evaluator does not inline extension type getter bodies. `const padding = TwSpace.s4.all` will fail with `CONST_EVAL_EXTENSION_TYPE_METHOD`. However, `const padding = EdgeInsets.all(TwSpace.s4)` WILL work because `TwSpace.s4` erases to `16.0` which is a const double. Document this clearly.

### Pattern: Colors as Abstract Final Class (NOT Extension Type)

```dart
abstract final class TwColors {
  static const Color slate50  = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  // ... all 242 + black, white, transparent
}
```

**Why NOT `extension type const TwColor(Color value) implements Color`?**
Color already has a rich API (withOpacity, withAlpha, red, green, blue, etc.). An extension type wrapper adds zero convenience methods that Color doesn't already have. Unlike `TwSpace implements double` (where you add EdgeInsets getters), `TwColor` would be pure overhead with no benefit. Plain `static const Color` is simpler and equally const-friendly.

### Where Extension Types Earn Their Keep

| Token | Extension Type? | Rationale |
|-------|----------------|-----------|
| `TwSpace` | YES | Adds EdgeInsets convenience getters (.all, .x, .y, .top, etc.) |
| `TwRadius` | YES | Adds BorderRadius convenience getters (.all, .topLeft, etc.) |
| `TwFontSize` | MAYBE | Could add paired line-height getter, but may not justify the const limitation |
| `TwOpacity` | NO | Just doubles, adds nothing over raw `static const double` |
| `TwColor` | NO | Color API is already rich; wrapper adds nothing in v1 |
| `TwFontWeight` | NO | Just `FontWeight` constants |
| `TwLetterSpacing` | NO | Just double constants |
| `TwLineHeight` | NO | Just double constants |
| `TwShadow` | NO | `List<BoxShadow>` -- cannot wrap a List in an extension type usefully |
| `TwBreakpoint` | NO | Better as sealed class with value field for v2 responsive features |

## Testing Strategy

### Unit Testing: `flutter_test` (built-in)

No external test runner needed. `flutter_test` provides:
- `test()` and `group()` for pure Dart token value assertions
- `testWidgets()` and `WidgetTester` for widget extension tests
- `matchesGoldenFile()` for built-in golden comparison
- `expectLater()` for async golden assertions

### Golden Testing: `alchemist` (dev dependency)

**Why alchemist over raw `matchesGoldenFile`?**
- **CI stability:** Raw golden tests use platform-specific font rendering, causing flakes across macOS/Linux/Windows CI runners. Alchemist's CI mode uses the Ahem font (renders squares) for deterministic cross-platform comparison.
- **Organization:** `GoldenTestGroup` renders multiple scenarios in a grid layout, reducing test file count.
- **Theme injection:** Built-in support for testing with different ThemeData configs -- critical for light/dark mode verification.

**Why NOT alchemist?**
Alchemist adds a transitive dependency on `equatable` and `meta`. As a dev dependency only, this doesn't affect consumers. The benefit (CI-stable goldens) outweighs the dev-dep cost.

**Alternative consideration:** Flutter's built-in golden test infrastructure (`matchesGoldenFile`) works fine if you standardize on a single CI platform (e.g., Ubuntu) and accept the platform font rendering lock-in. This is a simpler option with zero additional dev deps. Choose alchemist if you want golden tests to work on developer machines (macOS/Windows) AND CI (Linux).

### Coverage: `flutter test --coverage`

Generates `lcov.info`. Use `very_good_coverage` or a simple shell check in CI to enforce the 85% threshold.

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Lint rules | `very_good_analysis` | `flutter_lints` | Too permissive for a quality-focused package. VGA catches more issues. |
| Lint rules | `very_good_analysis` | `lint` (package) | Slightly less strict, no analyzer strict modes by default. |
| Golden tests | `alchemist` | Raw `matchesGoldenFile` | CI font rendering flakes. Alchemist solves this with Ahem font mode. |
| Golden tests | `alchemist` | `golden_toolkit` | Discontinued/unmaintained. Alchemist is the spiritual successor. |
| CI workflows | VGV reusable workflows | Custom YAML | Why reinvent the wheel? VGV workflows are battle-tested. |
| CI action | `subosito/flutter-action@v2` | Manual Flutter install | More maintenance, no caching. Use the standard action. |
| Code gen | None (pre-written tokens) | `build_runner` | Consumer friction. Tokens are static -- no reason to generate at build time. |
| Code gen | None | Dart macros | Paused by Dart team as of Jan 2025. Not viable. |
| Theme gen | None (hand-written) | `theme_tailor` | Adds a build_runner dependency. ThemeExtension boilerplate is manageable for 7 token categories. |

## Installation

### For the package itself (pubspec.yaml)

```yaml
name: tailwind_flutter
description: >-
  Tailwind CSS design tokens and utility-first styling for Flutter.
  Type-safe, composable, theme-aware.
version: 0.1.0
homepage: https://github.com/[owner]/tailwind_flutter
repository: https://github.com/[owner]/tailwind_flutter
issue_tracker: https://github.com/[owner]/tailwind_flutter/issues
topics:
  - tailwind
  - design-tokens
  - styling
  - theme
  - ui

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.19.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^10.2.0
  alchemist: ^0.13.0
```

### For consumers of the package

```yaml
# In consumer's pubspec.yaml
dependencies:
  tailwind_flutter: ^0.1.0
```

```bash
flutter pub add tailwind_flutter
```

## pubspec.yaml Requirements for 160/160

Critical fields that affect pub.dev scoring:

| Field | Required For | Points Impact |
|-------|-------------|---------------|
| `name` | Convention | Part of 30pts |
| `description` | Convention (60-180 chars recommended) | Part of 30pts |
| `version` | Convention (semver) | Part of 30pts |
| `homepage` OR `repository` | Convention (https only) | Part of 30pts |
| `environment.sdk` | Convention + Dependencies | Part of 30pts + 40pts |
| `topics` | Discovery (max 5, not scored but affects visibility) | Indirect |
| `screenshots` | Optional but improves pub.dev listing | None |

## Dart Language Feature Availability Matrix

Since we target Dart >=3.3, here is what we can and cannot use:

| Feature | Available Since | Can We Use? | Notes |
|---------|----------------|-------------|-------|
| Extension types | 3.3 | YES | Core of our token design |
| Sealed classes | 3.0 | YES | TwVariant sealed class |
| Records | 3.0 | YES | If needed for any compound returns |
| Patterns / Pattern matching | 3.0 | YES | Useful in tests and variant resolution |
| Class modifiers (final, base, interface) | 3.0 | YES | `abstract final class TwColors` |
| Digit separators | 3.6 | NO | Cannot use `0xFF_F8_FA_FC` syntax. Must use `0xFFF8FAFC`. |
| Wildcard variables | 3.7 | NO | Cannot use `_` as wildcard in declarations. |
| Null-aware elements | 3.8 | NO | Cannot use `?element` in list literals. |
| Dot shorthands | 3.10 | NO | Cannot use `.foo` shorthand. Must write full `ContextType.foo`. |

This is important: do NOT accidentally use Dart 3.6+ features in the codebase. The `sdk: ">=3.3.0 <4.0.0"` constraint means consumers on 3.3-3.5 must be able to compile the package.

## Sources

- [Dart SDK archive](https://dart.dev/get-dart/archive) - Dart 3.11 is current stable (2026-01-27)
- [Flutter release notes](https://docs.flutter.dev/release/release-notes) - Flutter 3.41.2 is current stable (Feb 2026)
- [Dart extension types](https://dart.dev/language/extension-types) - Official extension type documentation
- [Dart language evolution](https://dart.dev/resources/language/evolution) - Feature version matrix
- [pub.dev scoring](https://pub.dev/help/scoring) - Scoring categories and requirements
- [pub.dev provider score page](https://pub.dev/packages/provider/score) - Verified 160 max (provider shows 150/160)
- [pub.dev getter score page](https://pub.dev/packages/getter/score) - Verified 160 max (getter shows 140/160, detailed category breakdown)
- [pana GitHub](https://github.com/dart-lang/pana) - Package analyzer source (v0.23.10)
- [pana issue #975](https://github.com/dart-lang/pana/issues/975) - Historical 130 max (2021), since updated to 160
- [Very Good Analysis](https://pub.dev/packages/very_good_analysis) - v10.2.0, Dart ^3.11
- [Alchemist](https://pub.dev/packages/alchemist) - v0.13.0, golden testing framework
- [Very Good Workflows](https://github.com/VeryGoodOpenSource/very_good_workflows) - Reusable CI workflows
- [subosito/flutter-action](https://github.com/subosito/flutter-action) - v2.15.0, Flutter CI action
- [ThemeExtension class](https://api.flutter.dev/flutter/material/ThemeExtension-class.html) - Official Flutter API docs
- [flutter_lints](https://pub.dev/packages/flutter_lints) - v6.0.0, official Flutter lints
- [Flutter linting comparison](https://rydmike.com/blog_flutter_linting.html) - VGA vs lint vs flutter_lints analysis
