# Phase 5: Polish + Publication - Context

**Gathered:** 2026-03-12
**Status:** Ready for planning

<domain>
## Phase Boundary

Example app, golden tests, README, CHANGELOG, dartdoc coverage audit, and pana score verification for 160/160 pub.dev points. This is the packaging layer that makes the library adoptable — no new API surface, only documentation, demonstration, and publication readiness.

</domain>

<decisions>
## Implementation Decisions

### Example app structure
- Multi-page with tab navigation: Tokens, Extensions, Styles pages
- File structure: `example/lib/main.dart` + `example/lib/pages/{tokens,extensions,styles}_page.dart`
- Dark mode toggle in AppBar — demonstrates TwTheme + TwVariant.dark resolution live
- App itself styled using tailwind_flutter (dogfooding) — proves the package works for real UI
- Subtle brand color override demo — shows TwThemeData.light(colors: myBrandColors) customization

### Tokens page
- Color palette grid showing all 22 families with shade swatches — the visual "wow" moment
- A few spacing and typography samples below the color grid
- Not a full catalog of every token category

### Extensions page
- Side-by-side before/after comparisons: raw Flutter nesting vs chained extensions
- Visually demonstrates the boilerplate reduction pitch
- Text extension examples included

### Styles page
- Practical card example (product card or profile card) using TwStyle
- Demonstrates merge, variants, and apply in a real scenario
- Copy-pasteable as a starting point for devs

### README structure
- Badges: pub.dev version, CI status, coverage, license, style (VGA)
- 3-step quick-start: add dep → wrap in TwTheme → style a widget (under 20 lines, < 5 min to first styled widget)
- API overview organized by three tiers
- Tailwind CSS comparison table: maps utilities to their tailwind_flutter equivalents (`bg-blue-500` → `.bg(TwColors.blue.shade500)`)
- Theme setup section
- Contributing section
- Standard pub.dev sections — no bloat

### Golden tests
- Flutter's built-in `matchesGoldenFile` — skip alchemist entirely (zero dep, CI-stable, no Flutter 3.19 compat risk)
- Ahem font for CI stability
- 3-4 scenarios × 2 themes (light + dark) = 6-8 golden files total
- Scenarios: styled card (extensions), styled card (TwStyle.apply), text styling, composition/merge
- Each scenario rendered in both light and dark — proves TwVariant.dark resolution visually

### Dartdoc coverage
- Priority: public-facing API surface — TwStyle (apply/resolve/merge), widget extensions, TwTheme/TwThemeData
- Code examples (/// ```dart) on key APIs only: TwStyle.apply, .merge, .resolve, TwTheme widget, 2-3 extension methods
- Token classes: class-level doc only, skip individual member docs (shade500, s4, lg are self-documenting)
- Target: ≥ 80% coverage on all public APIs

### Version & publication
- Bump to 0.1.0 for initial pub.dev release (pre-1.0, room for breaking changes before v2 features)
- CHANGELOG updated with full v0.1.0 entry covering all phases
- Pana target: 160/160 points (ratcheted from Phase 1's 120 threshold)

### Claude's Discretion
- Exact tab navigation implementation (TabBar vs BottomNavigationBar vs custom)
- Color grid layout density and swatch sizing
- Before/after code comparison visual treatment on Extensions page
- Which 2-3 extension methods get code examples in dartdoc
- Golden test widget sizes and exact compositions
- CHANGELOG entry granularity
- Badge ordering and formatting in README header

</decisions>

<specifics>
## Specific Ideas

- Example app should dogfood tailwind_flutter for its own styling — strongest proof the package works
- Dark mode toggle is a selling point: flip the switch, see TwVariant.dark resolve live
- Before/after on Extensions page is the "60% less boilerplate" visual proof
- Styles page card should be realistic enough to copy-paste into a real project
- Quick-start in README must get someone from zero to styled widget in < 5 minutes — that's the adoption hook
- Tailwind CSS comparison table helps web devs transferring to Flutter onboard immediately

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- All 15 source files complete with 936 dartdoc comments already in place
- Barrel export clean with all exports active — no stub cleanup needed
- TwTheme widget + TwThemeData with light/dark presets — ready for example app wrapping
- TwStyle with apply/resolve/merge — ready for Styles page demo
- Widget extensions (10 methods) + Text extensions (8 methods) — ready for Extensions page demo
- All token classes (TwColors, TwSpacing, TwRadii, etc.) — ready for Tokens page demo

### Established Patterns
- VGA 5.1.0 strict linting — zero warnings tolerance
- Extension types implementing base types (TwSpace, TwRadius, TwFontSize)
- Abstract final classes for token namespaces
- GitHub Actions CI: analyze + test + pana on every push
- Test files mirror source 1:1 in test/src/

### Integration Points
- example/ directory does not exist yet — create from scratch
- README.md is a placeholder — full rewrite
- CHANGELOG.md has only initial entry — expand with v0.1.0
- pubspec.yaml version bump: 0.0.1-dev.1 → 0.1.0
- CI pana threshold: ratchet from 120 to 160
- Golden test files go in test/goldens/ (new directory)

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 05-polish-publication*
*Context gathered: 2026-03-12*
