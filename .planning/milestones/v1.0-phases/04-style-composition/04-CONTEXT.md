# Phase 4: Style Composition - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

TwStyle immutable class with merge, resolve, and apply — the composable styling tier that ties everything together. Developers define reusable style objects that combine visual properties, merge with right-side-wins semantics, resolve dark/light variants via BuildContext, and apply to widgets producing a CSS box model widget tree. This is the "CSS class" equivalent for Flutter.

</domain>

<decisions>
## Implementation Decisions

### Property set (CSS box model only)
- TwStyle holds exactly 8 optional properties: `padding`, `margin`, `backgroundColor`, `borderRadius`, `shadows`, `opacity`, `constraints`, `textStyle`
- No alignment or clip properties — those stay as extension chaining (`.apply().center()`)
- `padding` and `margin` typed as `EdgeInsets` — TwSpace getters (`.all`, `.x`, `.y`) provide ergonomic construction
- `constraints` typed as `BoxConstraints` — full min/max control, no separate width/height doubles
- `textStyle` typed as `TextStyle` — `.apply()` wraps in `DefaultTextStyle` when set

### Merge semantics
- `TwStyle.merge()` uses right-side-wins for all properties including lists
- Shadows are replaced, not appended — consistent with scalar property behavior
- Null properties in right-side style are ignored (left-side values preserved)

### Variant attachment API
- Variants defined via constructor parameter: `variants: {TwVariant.dark: TwStyle(...)}`
- Map type: `Map<TwVariant, TwStyle>` — keys are variant conditions, values are override styles
- TwVariant is a sealed class with exactly two cases: `TwVariant.dark` and `TwVariant.light` (no custom variants in v1)
- Resolve returns base style when no variant matches current brightness
- Resolve merges base + matching variant (variant overrides only properties it defines)

### Resolve behavior
- `.resolve(context)` checks platform brightness, returns flat TwStyle (no variants)
- Base style is the fallback — if no variant matches, base style is returned as-is
- `.apply()` on a style with variants uses base only (ignores variants without resolve)
- Dartdoc documents that `.resolve(context).apply()` is the correct path for variant-aware styles

### Apply widget tree order (CSS box model)
- Widget tree follows CSS box model, outermost first: margin → constraints → opacity → decoration → padding → textStyle → child
- Null properties are skipped — only wrap in widgets for set properties
- `backgroundColor`, `borderRadius`, and `shadows` merge into a single `DecoratedBox` with `BoxDecoration(color, borderRadius, boxShadow)` when multiple are set
- If only one of bg/borderRadius/shadow is set, still use `DecoratedBox` for consistency
- `textStyle` wraps in `DefaultTextStyle` between padding and child

### TwStyledWidget
- Dropped — not in requirements (STY-01 through STY-05), `.apply()` is the rendering path
- Delete `tw_styled_widget.dart` stub file
- Remove commented export line from barrel file

### Claude's Discretion
- Internal implementation of `.merge()` (whether to use copyWith pattern or manual null-coalescing)
- `TwStyle.copyWith()` method signature and implementation
- Whether TwStyle implements `==` / `hashCode` manually or uses Dart records/equatable pattern
- Test organization and grouping strategy
- Dartdoc examples beyond the decided API patterns
- Exact DecoratedBox construction logic when only subset of bg/borderRadius/shadow are set

</decisions>

<specifics>
## Specific Ideas

- TwStyle should feel like defining a CSS class: `final card = TwStyle(padding: ..., bg: ..., shadow: ...)` — one declaration, reuse everywhere
- `.resolve(context).apply(child: widget)` is the canonical two-step for variant-aware rendering
- Merging should feel like CSS cascade: `baseStyle.merge(cardStyle).merge(activeStyle)` — each layer overrides what it defines
- DecoratedBox consolidation means `.apply()` produces a leaner tree than chaining extensions — a selling point over Phase 3 extensions for complex styles

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `TwSpace` extension type with `.all`, `.x`, `.y` EdgeInsets getters — ergonomic padding/margin construction
- `TwRadius` extension type with `BorderRadius` getters — feeds into `BoxDecoration.borderRadius`
- `TwShadows` as `List<BoxShadow>` constants — direct `BoxDecoration.boxShadow` value
- `TwOpacity` as plain double constants — direct `Opacity` widget value
- `TwColors` with shade access — direct `BoxDecoration.color` value
- `TwFontSizes` with `.textStyle` getter — bridges into TwStyle's textStyle property

### Established Patterns
- Extension types implementing base types (zero-cost abstractions)
- Abstract final classes for token namespaces
- Phase 3 widget wrappers: each extension = one widget, inner-to-outer ordering
- Barrel export with commented sections — uncomment style exports when implemented
- VGA strict linting — zero warnings tolerance

### Integration Points
- Barrel export: uncomment `tw_style.dart` and `tw_variant.dart` exports, remove `tw_styled_widget.dart` line
- Delete `tw_styled_widget.dart` stub
- TwStyle reads platform brightness via `Theme.of(context).brightness` for variant resolution
- Tests go in `test/src/styles/` mirroring source structure

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 04-style-composition*
*Context gathered: 2026-03-11*
