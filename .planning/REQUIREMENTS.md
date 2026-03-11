# Requirements: tailwind_flutter

**Defined:** 2026-03-11
**Core Value:** Complete Tailwind v4 design token parity expressed as type-safe, const Dart values with a composable utility API that enhances Flutter's existing ThemeData system.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Tokens — Colors

- [ ] **TOK-01**: Complete Tailwind v4 color palette — 22 families × 11 shades (242 colors) as `static const Color` values in `TwColors` abstract final class
- [ ] **TOK-02**: Semantic colors — `black` (#000), `white` (#FFF), `transparent` as named constants

### Tokens — Spacing

- [ ] **TOK-03**: Full spacing scale — 37 values from 0 to 96 (0px to 384px, 4px base unit) using extension type `TwSpace` that `implements double`
- [ ] **TOK-04**: EdgeInsets convenience getters on `TwSpace` — `.all`, `.x`, `.y`, `.top`, `.bottom`, `.left`, `.right`

### Tokens — Typography

- [x] **TOK-05**: Typography scale — 13 font sizes (xs/12px through 9xl/128px) each with paired default line-height, using extension type `TwFontSize`
- [x] **TOK-06**: Font weight constants — 9 weights (thin/100 through black/900) as `FontWeight` values
- [x] **TOK-07**: Letter spacing scale — 6 named values (tighter/-0.05em through widest/0.1em)
- [x] **TOK-08**: Line height scale — 6 named ratios (none/1.0 through loose/2.0)

### Tokens — Visual

- [x] **TOK-09**: Border radius scale — 10 values (none/0 through full/9999) using extension type `TwRadius` with `BorderRadius` getters
- [x] **TOK-10**: Box shadow presets — 7 elevation levels (2xs through 2xl) plus inner and none as `List<BoxShadow>` records
- [x] **TOK-11**: Opacity scale — standard Tailwind opacity values (0, 5, 10, 15...95, 100) as `double` constants
- [x] **TOK-12**: Breakpoint constants — 5 responsive thresholds (sm/640, md/768, lg/1024, xl/1280, 2xl/1536)

### Theme Integration

- [ ] **THM-01**: `ThemeExtension<T>` class for each token category (7 classes) with `copyWith` and `lerp` — split per category, not monolithic
- [ ] **THM-02**: `TwTheme` widget that injects all `ThemeExtension`s into `ThemeData`
- [ ] **THM-03**: `TwThemeData` resolver accessed via `context.tw` with null-safety (`maybeOf`)
- [ ] **THM-04**: Default light and dark theme presets (`TwThemeData.light()`, `TwThemeData.dark()`)

### Widget Extensions

- [ ] **EXT-01**: Padding extensions — `p`, `px`, `py`, `pt`, `pb`, `pl`, `pr` accepting `double`
- [ ] **EXT-02**: Margin extensions — `m`, `mx`, `my`, `mt`, `mb`, `ml`, `mr`
- [ ] **EXT-03**: Background color extension — `.bg(Color)`
- [ ] **EXT-04**: Border radius extension — `.rounded(double)`, `.roundedFull()`
- [ ] **EXT-05**: Opacity extension — `.opacity(double)`
- [ ] **EXT-06**: Shadow extension — `.shadow(List<BoxShadow>)`
- [ ] **EXT-07**: Sizing extensions — `.width(double)`, `.height(double)`, `.size(double, double)`
- [ ] **EXT-08**: Alignment extensions — `.center()`, `.align(Alignment)`
- [ ] **EXT-09**: Clip extensions — `.clipRect()`, `.clipOval()`, `.clipRounded(double)`
- [ ] **EXT-10**: Text-specific extensions on `Text` widget — `.bold()`, `.italic()`, `.fontSize(double)`, `.textColor(Color)`, `.letterSpacing(double)`, `.lineHeight(double)`, `.fontWeight(FontWeight)` — must preserve ALL Text constructor parameters

### Style Composition

- [ ] **STY-01**: `TwStyle` immutable data class with all visual properties (padding, margin, backgroundColor, borderRadius, shadows, opacity, constraints, textStyle)
- [ ] **STY-02**: `TwStyle.merge()` for combining styles (right-side wins for conflicts)
- [ ] **STY-03**: `TwStyle.apply(child: widget)` to render styled widget — widget tree follows CSS box model order
- [ ] **STY-04**: `TwVariant` sealed class with `dark`, `light` platform brightness variants
- [ ] **STY-05**: `TwStyle.resolve(context)` to evaluate variant conditions and return flat style

### Infrastructure

- [x] **INF-01**: Package structure targeting 160/160 pub.dev points (conventions, docs, platforms, analysis, deps)
- [x] **INF-02**: Barrel export file (`tailwind_flutter.dart`) with organized exports
- [ ] **INF-03**: Example app in `example/` demonstrating all three tiers
- [ ] **INF-04**: Unit tests for all token values, extension methods, theme resolution
- [ ] **INF-05**: Golden tests for styled widgets across light/dark themes (using Ahem font for CI stability)
- [ ] **INF-06**: `README.md` with quick-start guide, API overview, and comparison to Tailwind CSS
- [x] **INF-07**: `analysis_options.yaml` with `very_good_analysis` + strict mode, zero warnings
- [ ] **INF-08**: `CHANGELOG.md` following Keep a Changelog format
- [x] **INF-09**: CI/CD via GitHub Actions (analyze, test, pana score, coverage)
- [ ] **INF-10**: Dartdoc coverage ≥ 80% on all public APIs

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Responsive & Interaction

- **V2-01**: Responsive variants — `TwVariant.sm()`, `.md()`, `.lg()`, `.xl()`, `.xxl()` using `MediaQuery`
- **V2-02**: Hover/press interaction variants for desktop/web
- **V2-03**: `TwAnimatedStyle` with implicit animation support (duration, curve)
- **V2-04**: Group/peer-like conditional modifiers (parent state affects child)

### Tooling

- **V2-05**: `tailwind_flutter_lint` companion package with custom lint rules
- **V2-06**: Widgetbook catalog app as separate example project
- **V2-07**: Dedicated documentation website
- **V2-08**: VS Code / Android Studio snippets extension
- **V2-09**: Token generation CLI from upstream Tailwind CSS releases
- **V2-10**: `@apply`-equivalent — named style extraction with `TwStyle` factory constructors

## Out of Scope

| Feature | Reason |
|---------|--------|
| Component library (buttons, cards, modals) | Styling primitive package — components belong in separate `tailwind_flutter_ui` package |
| Layout utilities (VStack, HStack, grid) | Flutter's Row/Column/Flex/Expanded are sufficient and well-understood |
| String-based class parsing ("bg-blue-500") | Antithetical to project philosophy — always typed Dart |
| CSS-in-Dart or stylesheet abstraction | Not the goal — enhance Flutter, don't replace its mental model |
| Build-time code generation for consumers | Adoption barrier — ship pre-generated tokens |
| State management integration | Solved, opinionated domain — coupling alienates users |
| Navigation/routing integration | Unrelated to styling |
| Dart macros | Paused indefinitely by Dart team (Jan 2025) |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| TOK-01 | Phase 2 | Pending |
| TOK-02 | Phase 2 | Pending |
| TOK-03 | Phase 2 | Pending |
| TOK-04 | Phase 2 | Pending |
| TOK-05 | Phase 2 | Complete |
| TOK-06 | Phase 2 | Complete |
| TOK-07 | Phase 2 | Complete |
| TOK-08 | Phase 2 | Complete |
| TOK-09 | Phase 2 | Complete |
| TOK-10 | Phase 2 | Complete |
| TOK-11 | Phase 2 | Complete |
| TOK-12 | Phase 2 | Complete |
| THM-01 | Phase 2 | Pending |
| THM-02 | Phase 2 | Pending |
| THM-03 | Phase 2 | Pending |
| THM-04 | Phase 2 | Pending |
| EXT-01 | Phase 3 | Pending |
| EXT-02 | Phase 3 | Pending |
| EXT-03 | Phase 3 | Pending |
| EXT-04 | Phase 3 | Pending |
| EXT-05 | Phase 3 | Pending |
| EXT-06 | Phase 3 | Pending |
| EXT-07 | Phase 3 | Pending |
| EXT-08 | Phase 3 | Pending |
| EXT-09 | Phase 3 | Pending |
| EXT-10 | Phase 3 | Pending |
| STY-01 | Phase 4 | Pending |
| STY-02 | Phase 4 | Pending |
| STY-03 | Phase 4 | Pending |
| STY-04 | Phase 4 | Pending |
| STY-05 | Phase 4 | Pending |
| INF-01 | Phase 1 | Complete |
| INF-02 | Phase 1 | Complete |
| INF-03 | Phase 5 | Pending |
| INF-04 | Phase 2 | Pending |
| INF-05 | Phase 5 | Pending |
| INF-06 | Phase 5 | Pending |
| INF-07 | Phase 1 | Complete |
| INF-08 | Phase 5 | Pending |
| INF-09 | Phase 1 | Complete |
| INF-10 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 41 total
- Mapped to phases: 41
- Unmapped: 0

---
*Requirements defined: 2026-03-11*
*Last updated: 2026-03-11 after roadmap creation*
