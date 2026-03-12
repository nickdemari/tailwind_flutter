# Phase 5: Polish + Publication - Research

**Researched:** 2026-03-12
**Domain:** Flutter package publication, golden testing, documentation, example apps
**Confidence:** HIGH

## Summary

Phase 5 takes a fully-implemented library (Phases 1-4 complete, all 36 core requirements done) and wraps it for publication. The current pana score is **140/160**, losing 10 points for the missing example app and 10 points for `dart format` drift in two files. The dartdoc coverage is already at 99.8% (440/441 API elements) -- only the library-level comment on the barrel file is missing. This means the path to 160/160 is well-defined and mechanical, not exploratory.

The three substantive work items are: (1) create the multi-page example app in `example/`, (2) implement golden tests using Flutter's built-in `matchesGoldenFile` with the Ahem font, and (3) rewrite README.md with the quick-start guide and Tailwind CSS comparison table. The remaining items (CHANGELOG, version bump, CI ratchet, dartdoc gap, formatting) are all surgical single-file changes.

**Primary recommendation:** Fix the two formatting violations and create the example app first -- those two actions alone recover all 20 lost pana points. Then layer in golden tests, README, and CHANGELOG.

<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions
- Multi-page example app with tab navigation: Tokens, Extensions, Styles pages
- File structure: `example/lib/main.dart` + `example/lib/pages/{tokens,extensions,styles}_page.dart`
- Dark mode toggle in AppBar demonstrating TwTheme + TwVariant.dark resolution live
- App itself styled using tailwind_flutter (dogfooding)
- Subtle brand color override demo showing TwThemeData.light(colors: myBrandColors) customization
- Tokens page: Color palette grid (22 families with shade swatches), a few spacing/typography samples
- Extensions page: Side-by-side before/after comparisons (raw Flutter vs chained extensions), text extensions included
- Styles page: Practical card example using TwStyle demonstrating merge, variants, and apply
- README: Badges, 3-step quick-start (< 5 min), API overview by tier, Tailwind CSS comparison table, theme setup, contributing
- Golden tests: Flutter built-in `matchesGoldenFile` only (no alchemist), Ahem font, 3-4 scenarios x 2 themes = 6-8 golden files
- Golden scenarios: styled card (extensions), styled card (TwStyle.apply), text styling, composition/merge
- Dartdoc: Priority on public-facing API surface, code examples on key APIs only, token classes get class-level doc only
- Version: 0.1.0, CHANGELOG with full v0.1.0 entry, pana target 160/160

### Claude's Discretion
- Exact tab navigation implementation (TabBar vs BottomNavigationBar vs custom)
- Color grid layout density and swatch sizing
- Before/after code comparison visual treatment on Extensions page
- Which 2-3 extension methods get code examples in dartdoc
- Golden test widget sizes and exact compositions
- CHANGELOG entry granularity
- Badge ordering and formatting in README header

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| INF-03 | Example app in `example/` demonstrating all three tiers | Example app structure, Flutter package example conventions, pana example scoring |
| INF-05 | Golden tests for styled widgets across light/dark themes (Ahem font for CI stability) | matchesGoldenFile API, flutter_test_config.dart setup, golden test patterns |
| INF-06 | `README.md` with quick-start guide, API overview, and Tailwind CSS comparison | README structure, badge conventions, pub.dev display requirements |
| INF-08 | `CHANGELOG.md` following Keep a Changelog format | Keep a Changelog v1.1.0 format specification |
| INF-10 | Dartdoc coverage >= 80% on all public APIs | Current coverage at 99.8% (440/441), only barrel file library comment missing |

</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| flutter_test | SDK | Golden tests, widget tests | Built-in, no external dependency, CI-stable |
| pana | 0.23.10 | Package analysis scoring | Official pub.dev scoring tool |
| dartdoc | SDK-bundled | API documentation generation | Used by pub.dev for documentation scoring |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| very_good_analysis | ^5.1.0 | Already in dev_dependencies | Lint rules for the example app too |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| matchesGoldenFile | alchemist/golden_toolkit | Extra dep, Flutter 3.19 compat risk, overkill for 6-8 goldens |
| TabBar | BottomNavigationBar | TabBar is more standard for 3 top-level sections in a demo app, uses less vertical space |

**Installation:**
No new dependencies required. Example app will use the parent package via path dependency:
```yaml
# example/pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  tailwind_flutter:
    path: ../
```

## Architecture Patterns

### Example App Structure
```
example/
  lib/
    main.dart                    # App entry, TwTheme wrapping, tab scaffold
    pages/
      tokens_page.dart           # Color grid, spacing/typography samples
      extensions_page.dart       # Before/after comparisons
      styles_page.dart           # TwStyle card demo with variants
  pubspec.yaml                   # Depends on tailwind_flutter via path: ../
  analysis_options.yaml          # Can include parent's VGA rules
```

### Golden Test Structure
```
test/
  goldens/
    golden_styled_card_extensions_light.png
    golden_styled_card_extensions_dark.png
    golden_styled_card_tw_style_light.png
    golden_styled_card_tw_style_dark.png
    golden_text_styling_light.png
    golden_text_styling_dark.png
    golden_composition_merge_light.png
    golden_composition_merge_dark.png
  src/
    goldens/
      golden_test.dart           # All golden test cases
```

### Pattern 1: Golden Test with matchesGoldenFile
**What:** Render a widget in a constrained test environment and compare against a reference image.
**When to use:** Verifying styled widget appearance across light and dark themes.
**Example:**
```dart
// Source: Flutter SDK - matchesGoldenFile documentation
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  group('Golden - Styled Card', () {
    testWidgets('light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TwTheme(
            data: TwThemeData.light(),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: _StyledCard(),
                ),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/golden_styled_card_light.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: TwTheme(
            data: TwThemeData.dark(),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: _StyledCard(),
                ),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/golden_styled_card_dark.png'),
      );
    });
  });
}
```

### Pattern 2: Example App with Dark Mode Toggle
**What:** StatefulWidget at app root that toggles TwThemeData between light/dark.
**When to use:** The example app's main scaffold.
**Example:**
```dart
// Canonical pattern for toggling TwTheme brightness
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: TwTheme(
        data: _isDark ? TwThemeData.dark() : TwThemeData.light(),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('tailwind_flutter'),
              actions: [
                IconButton(
                  icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () => setState(() => _isDark = !_isDark),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Tokens'),
                  Tab(text: 'Extensions'),
                  Tab(text: 'Styles'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [TokensPage(), ExtensionsPage(), StylesPage()],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Anti-Patterns to Avoid
- **Using `flutter test --update-goldens` in CI:** Goldens must be generated locally and committed. CI should only compare, never update. If CI generates goldens, tests never fail.
- **Loading custom fonts in golden tests:** The CONTEXT decision explicitly uses Ahem font for CI stability. Custom fonts render differently across platforms, causing CI failures.
- **Nested `example/lib/example.dart` naming:** Pana looks for `example/lib/main.dart` as the primary example file. Non-standard names may not be detected.
- **Relative imports in example app:** Example code must use `package:tailwind_flutter/tailwind_flutter.dart` imports, not `../lib/...` relative paths. This is what pub.dev displays and what users copy.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Golden test framework | Custom pixel comparison | `matchesGoldenFile` from flutter_test | Handles tolerance, file management, CI detection natively |
| Example app navigation | Custom page routing | `DefaultTabController` + `TabBar` + `TabBarView` | Zero deps, 3-section demo, exactly matches the use case |
| Documentation coverage check | Manual counting script | `pana` output (reports X/Y API elements documented) | Already runs in CI, gives authoritative pub.dev-matching number |
| Changelog formatting | Manual markdown | Keep a Changelog format | Standard, pana validates structure |

**Key insight:** Phase 5 has no novel engineering -- every task has an established pattern. The risk is in the details (formatting, file paths, CI config), not in design.

## Common Pitfalls

### Pitfall 1: Pana --exit-code-threshold Semantics
**What goes wrong:** The `--exit-code-threshold` flag is counterintuitive. It triggers failure when `(max - granted) > threshold`, NOT when `granted < threshold`.
**Why it happens:** The current CI uses `--exit-code-threshold 120`, which means "fail if we lose more than 120 points" -- almost impossible to fail since max is 160. To enforce 160/160, threshold must be `0`.
**How to avoid:** Set `--exit-code-threshold 0` in CI. This means any lost point causes CI failure.
**Warning signs:** Pana CI step passing despite known point deductions.

### Pitfall 2: dart format Drift Causing 10-Point Pana Loss
**What goes wrong:** Two files (`widget_extensions.dart`, `colors.dart`) currently don't match `dart format` output, costing 10/50 in "Pass static analysis."
**Why it happens:** VGA lint rules and `dart format` operate independently. Code can pass `flutter analyze` but fail `dart format`.
**How to avoid:** Run `dart format .` before committing. The CI already checks this (`dart format --set-exit-if-changed`) but it's in a separate job that doesn't affect pana.
**Warning signs:** Pana reporting `40/50` on static analysis despite zero lint warnings.

### Pitfall 3: Golden Files Must Be Generated Locally, Not in CI
**What goes wrong:** Golden test images are platform-dependent. Generating on macOS then comparing on Ubuntu CI = guaranteed failure.
**Why it happens:** Even with Ahem font, rendering has minor platform differences.
**How to avoid:** Generate goldens locally, commit them, and use `flutter test --update-goldens` ONLY locally. CI runs `flutter test` without the flag. Critically: goldens must be generated on the SAME platform CI uses (Ubuntu) if pixel-perfect matching is required. For this project, using Ahem font minimizes platform differences, but residual differences can occur.
**Warning signs:** Golden tests pass locally but fail in CI, or vice versa.

### Pitfall 4: Example App pubspec.yaml Missing Required Fields
**What goes wrong:** The example app's pubspec needs `flutter:` section and proper SDK constraints, or `flutter pub get` fails.
**Why it happens:** Example apps need to be valid Flutter projects, not just loose Dart files.
**How to avoid:** Use `flutter create example --template=app` and then customize, or write a complete pubspec.yaml manually.
**Warning signs:** `flutter pub get` failing in `example/` directory.

### Pitfall 5: Library-Level Dartdoc Comment Missing
**What goes wrong:** Pana reports 440/441 documented (99.8%). The missing element is `tailwind_flutter` -- the library itself needs a `///` comment on the barrel file.
**Why it happens:** The barrel file (`lib/tailwind_flutter.dart`) has `//` comments but no `///` dartdoc comment on the library directive.
**How to avoid:** Add a `/// Tailwind CSS design tokens...` comment to the library-level export file. This single change pushes coverage to 441/441 (100%).
**Warning signs:** Pana output showing "Some symbols that are missing documentation: `tailwind_flutter`."

### Pitfall 6: pub.dev Homepage/Repository URL Validation
**What goes wrong:** Pana warns when `homepage` and `repository` URLs in pubspec.yaml are unreachable.
**Why it happens:** The current URLs (`https://github.com/user/tailwind_flutter`) are placeholders.
**How to avoid:** When publishing, update to the real GitHub repository URL. For local pana runs, this is a non-blocking warning (points are still granted).
**Warning signs:** Pana output showing "Homepage URL doesn't exist" and "Repository URL doesn't exist" -- but these are flagged as warnings, not point deductions.

## Code Examples

### Golden Test File (Complete Pattern)
```dart
// test/src/goldens/golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

/// Helper to wrap a widget in MaterialApp + TwTheme for golden testing.
Widget _goldenHarness({
  required Widget child,
  required TwThemeData themeData,
  ThemeData? materialTheme,
}) {
  return MaterialApp(
    theme: materialTheme ?? ThemeData.light(),
    debugShowCheckedModeBanner: false,
    home: TwTheme(
      data: themeData,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('Golden Tests', () {
    for (final entry in {
      'light': (TwThemeData.light(), ThemeData.light()),
      'dark': (TwThemeData.dark(), ThemeData.dark()),
    }.entries) {
      final themeName = entry.key;
      final (twTheme, materialTheme) = entry.value;

      testWidgets('styled card extensions - $themeName', (tester) async {
        await tester.pumpWidget(
          _goldenHarness(
            themeData: twTheme,
            materialTheme: materialTheme,
            child: SizedBox(
              width: 300,
              height: 200,
              child: Text('Hello')
                  .bold()
                  .p(TwSpacing.s4)
                  .bg(TwColors.blue.shade100)
                  .rounded(TwRadii.lg),
            ),
          ),
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/golden_styled_card_extensions_$themeName.png',
          ),
        );
      });
    }
  });
}
```

### README Quick-Start Section
```markdown
## Quick Start

### 1. Add the dependency
\```yaml
dependencies:
  tailwind_flutter: ^0.1.0
\```

### 2. Wrap your app in TwTheme
\```dart
MaterialApp(
  home: TwTheme(
    data: TwThemeData.light(),
    child: MyHomePage(),
  ),
)
\```

### 3. Style your widgets
\```dart
Text('Hello, Tailwind!')
  .bold()
  .fontSize(TwFontSizes.xl.value)
  .textColor(TwColors.blue.shade600)
  .p(TwSpacing.s4)
  .bg(TwColors.blue.shade50)
  .rounded(TwRadii.lg)
\```
```

### CHANGELOG v0.1.0 Entry (Keep a Changelog Format)
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-03-XX

### Added
- Complete Tailwind CSS v4 color palette: 22 families x 11 shades (242 colors)
- Spacing scale: 35 values from 0px to 384px with EdgeInsets convenience getters
- Typography tokens: 13 font sizes, 9 weights, 6 letter spacings, 6 line heights
- Border radius scale: 10 values with BorderRadius getters
- Box shadow presets: 7 elevation levels plus inner and none
- Opacity scale and breakpoint constants
- Theme integration: 7 ThemeExtension classes with TwTheme widget and context.tw accessor
- Widget extensions: padding, margin, background, rounded, opacity, shadow, sizing, alignment, clip
- Text extensions: bold, italic, fontSize, textColor, letterSpacing, lineHeight, fontWeight
- TwStyle composable styling: merge, apply, resolve with TwVariant (light/dark)
- Example app demonstrating all three tiers (tokens, extensions, styles)
- Golden tests for styled widgets across light and dark themes
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `alchemist` for golden tests | `matchesGoldenFile` built-in | Always available | Zero external dep, no compat risk |
| `dart_doc_coverage` CLI | pana reports coverage natively | pana 0.22+ | No separate tool needed |
| Manual pub point checking | `pana --exit-code-threshold 0` | Current | CI enforces exact score |
| `null_safety` scoring category | Removed from pana | pana 0.22+ | Max points changed from 130 to current 160 |

**Deprecated/outdated:**
- `very_good_workflows` reusable CI actions: overkill for this project, custom CI already established
- `pub publish --dry-run` as score proxy: doesn't give point breakdown, use pana instead

## Pana Scoring Breakdown (Verified Locally)

Current score: **140/160**

| Category | Current | Max | Gap | Fix |
|----------|---------|-----|-----|-----|
| Follow Dart file conventions | 30 | 30 | 0 | -- |
| Provide documentation | 10 | 20 | 10 | Create `example/` app |
| Platform support | 20 | 20 | 0 | -- |
| Pass static analysis | 40 | 50 | 10 | `dart format .` on 2 files |
| Support up-to-date dependencies | 40 | 40 | 0 | -- |
| **Total** | **140** | **160** | **20** | -- |

**Files needing `dart format`:** `lib/src/extensions/widget_extensions.dart`, `lib/src/tokens/colors.dart`

**Missing example:** pana requires a file matching the search order: `example/example.md` > `example/lib/main.dart` > `example/lib/tailwind_flutter.dart` > etc.

**Dartdoc coverage:** 440/441 (99.8%) -- only the barrel file `tailwind_flutter` library comment is missing.

## Open Questions

1. **Golden file platform consistency**
   - What we know: Ahem font is deterministic per-platform, but minor rendering differences can occur between macOS (local) and Ubuntu (CI)
   - What's unclear: Whether Ahem-only golden files generated on macOS will pass on Ubuntu CI without tolerance
   - Recommendation: Generate goldens locally, test in CI. If failures occur, either generate on a Linux environment (Docker) or add a tolerance comparator. For Ahem-only rendering (no custom fonts, no images), platform differences are typically negligible.

2. **pubspec.yaml homepage/repository URLs**
   - What we know: Current URLs (`https://github.com/user/tailwind_flutter`) are placeholders that pana warns about
   - What's unclear: Whether this will cause point deduction on pub.dev (locally it's a warning only, points still granted)
   - Recommendation: Update to real repo URL before actual publication. For Phase 5 implementation, leave as-is since pana still grants full points.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | flutter_test (SDK-bundled) |
| Config file | test/flutter_test_config.dart (not yet created -- see Wave 0) |
| Quick run command | `flutter test test/src/goldens/golden_test.dart` |
| Full suite command | `flutter test` |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| INF-03 | Example app builds and runs | smoke | `cd example && flutter pub get && flutter analyze` | -- Wave 0 |
| INF-05 | Golden tests verify styled widgets light/dark | golden | `flutter test test/src/goldens/golden_test.dart` | -- Wave 0 |
| INF-06 | README exists with required sections | manual-only | Verify file content manually | -- |
| INF-08 | CHANGELOG follows Keep a Changelog format | manual-only | pana validates changelog format | -- |
| INF-10 | Dartdoc >= 80% | unit | `dart pub global run pana --no-warning 2>&1 \| grep "API has dartdoc"` | -- Existing pana CI |

### Sampling Rate
- **Per task commit:** `flutter test` (full suite, fast -- under 30s)
- **Per wave merge:** `flutter test && dart pub global run pana --no-warning`
- **Phase gate:** pana reports 160/160, all golden tests pass, example app analyzes clean

### Wave 0 Gaps
- [ ] `test/src/goldens/golden_test.dart` -- covers INF-05 (golden tests)
- [ ] `example/` directory with full Flutter app -- covers INF-03
- [ ] `dart format .` on lib/ -- fixes 10-point pana deduction
- [ ] Library-level dartdoc comment on barrel file -- fixes 1 missing doc element

## Sources

### Primary (HIGH confidence)
- Local `pana` run (v0.23.10) -- verified exact scoring breakdown: 140/160 with specific deduction reasons
- Local `dart doc` run -- 0 warnings, 0 errors
- Local `dart format --set-exit-if-changed` -- identified exactly 2 files needing formatting
- Flutter SDK `matchesGoldenFile` API docs -- https://api.flutter.dev/flutter/flutter_test/matchesGoldenFile.html
- Dart package layout conventions -- https://dart.dev/tools/pub/package-layout

### Secondary (MEDIUM confidence)
- pub.dev scoring documentation -- https://pub.dev/help/scoring (categories confirmed, specific points verified locally)
- pana GitHub repository -- https://github.com/dart-lang/pana (--exit-code-threshold semantics confirmed)
- Keep a Changelog format -- https://keepachangelog.com/en/1.1.0/
- Flutter TabBar documentation -- https://docs.flutter.dev/cookbook/design/tabs

### Tertiary (LOW confidence)
- Golden test platform consistency claims -- based on community experience, not officially documented tolerance guarantees

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- no new dependencies, all built-in tools verified locally
- Architecture: HIGH -- example app and golden test patterns are well-established Flutter conventions
- Pitfalls: HIGH -- most pitfalls discovered through actual local pana run, not speculation
- Pana scoring: HIGH -- verified by running pana locally and reading exact output

**Research date:** 2026-03-12
**Valid until:** 2026-04-12 (stable domain, unlikely to change)
