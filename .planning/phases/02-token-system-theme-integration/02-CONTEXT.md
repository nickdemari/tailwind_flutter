# Phase 2: Token System + Theme Integration - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

All 7 Tailwind v4 token categories (colors, spacing, typography, radius, shadows, opacity, breakpoints) as const Dart values with extension types, plus 7 ThemeExtension classes, TwTheme widget, TwThemeData resolver via context.tw, and light/dark presets. Unit tests for all tokens and theme resolution (>=85% coverage).

</domain>

<decisions>
## Implementation Decisions

### Color Access API
- Family objects pattern: `TwColors.blue.shade500` — each color family is a const TwColorFamily extension type with shade getters
- Two-step autocomplete: `TwColors.` → families, then `.shade` → shades
- TwColorFamily is an extension type wrapping a record of 11 Color values (shade50 through shade950)
- Shade names use `shade` prefix (`.shade500` not `.s500`) — mirrors Flutter's `Colors.blue.shade500` convention
- No default shade — `TwColors.blue` returns TwColorFamily, not Color. Always explicit: `.shade500`
- Semantic colors (`TwColors.black`, `.white`, `.transparent`) are direct `static const Color` values, not families

### Dark Theme Tokens
- Brightness flag only — `TwThemeData.dark()` sets platform brightness to dark, all token VALUES stay identical
- Developers pick dark-appropriate shades per usage (Tailwind's model: `dark:` is per-usage, not global token swap)
- Phase 4's TwStyle will handle dark/light variant resolution

### Theme Customizability
- TwThemeData is customizable: `TwThemeData.light(colors: myColors, spacing: mySpacing)` accepts per-category overrides with Tailwind defaults
- Full custom constructor also available: `TwThemeData(brightness: ..., colors: ..., spacing: ..., ...)` for complete control

### ThemeExtension Granularity
- 7 ThemeExtension classes, one per token category (1:1 with token files):
  - TwColorTheme, TwSpacingTheme, TwTypographyTheme, TwRadiusTheme, TwShadowTheme, TwOpacityTheme, TwBreakpointTheme
- Each has `copyWith` and `lerp` as required by ThemeExtension<T>
- Access via `context.tw.colors`, `context.tw.spacing`, etc.

### Context Resolution
- `context.tw` throws with helpful message if no TwTheme ancestor ("No TwTheme found. Wrap your app in TwTheme(...)")
- `context.tw.maybeOf` (or `context.twMaybe`) provides nullable access for optional theme usage
- Matches Flutter's `Theme.of()` / `Theme.maybeOf()` pattern

### Extension Type Extras
- No arithmetic operators on TwSpace — `implements double` means Dart's double arithmetic already works, result is a plain double (correct: computed values aren't design tokens)
- TwFontSize carries paired line-height: `.value` (size), `.lineHeight` (paired default), `.textStyle` (TextStyle with both). Extension type wraps a record of (size, lineHeight)
- TwRadius provides BorderRadius getters only: `.all`, `.top`, `.bottom`, `.left`, `.right`. No `.circular` getter — `Radius.circular(TwRadius.lg)` is trivial
- TwShadow values are plain `const List<BoxShadow>` — no extension type wrapper. Flutter's BoxShadow is already well-typed

### Test Strategy
- Colors (242): boundary + systematic — test shade50/shade500/shade950 per family (~66 value assertions) + verify all 22 families exist with 11 shades each + semantic colors exact
- Spacing (37), radius (10), opacity (~20), breakpoints (5): exhaustive value-by-value testing — small enough sets
- Typography (13 sizes): exhaustive — verify each size AND its paired line-height
- Theme: both unit tests (copyWith, lerp logic) AND widget tests (pumpWidget + TwTheme injection, context.tw resolution, throw-on-missing)
- Test files mirror source 1:1: test/src/tokens/colors_test.dart, test/src/theme/tw_theme_test.dart, etc.

### Claude's Discretion
- TwColorFamily extension type internal representation (record vs other)
- Exact naming of ThemeExtension factory constructors (`.tailwind()`, `.defaults()`, etc.)
- Whether TwThemeData stores ThemeExtensions in a list or individual fields
- EdgeInsets getter naming on TwSpace (`.all`, `.x`, `.y` vs `.horizontal`, `.vertical`)
- Opacity and breakpoint extension type decisions (extension types vs plain abstract final classes)
- Test group organization within each test file

</decisions>

<specifics>
## Specific Ideas

- Color access should feel like Flutter's `Colors.blue.shade500` — familiar to every Flutter dev, just with Tailwind's palette
- TwFontSize.lg.textStyle is a key convenience — Tailwind's text-lg implies both size AND line-height, the extension type should carry that pairing
- TwThemeData.light() / .dark() should work with zero config but allow per-category overrides for branding
- Extension types that `implements double` (TwSpace, TwRadius, TwFontSize) must remain const-evaluable — no runtime allocation

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- Barrel export at `lib/tailwind_flutter.dart` with commented sections for all 7 token files and 3 theme files — uncomment as implemented
- Stub files already exist in `lib/src/tokens/` (7 files) and `lib/src/theme/` (3 files) — ready for implementation

### Established Patterns
- `very_good_analysis` 5.1.0 linting — strict mode, zero warnings tolerance
- Phase 1 established barrel export pattern with version constant
- GitHub Actions CI runs analyze + test on every push

### Integration Points
- Token files are independent leaf nodes — can be built in parallel within this phase
- Theme files depend on token files (ThemeExtension classes reference token types)
- Barrel export must be updated: uncomment token and theme exports as each file is implemented
- Existing smoke test in `test/tailwind_flutter_test.dart` — new test files added alongside, don't modify the smoke test

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-token-system-theme-integration*
*Context gathered: 2026-03-11*
