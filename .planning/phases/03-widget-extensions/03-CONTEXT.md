# Phase 3: Widget Extensions - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Padding, margin, background, radius, opacity, shadow, sizing, alignment, clip, and text-specific chaining extensions on Widget/Text. Each extension wraps the widget in a single-purpose parent widget (Padding, ColoredBox, ClipRRect, etc.). Developers chain methods like `.p(16).bg(blue).rounded(8)` instead of manually nesting widgets.

</domain>

<decisions>
## Implementation Decisions

### Chaining order & widget tree
- Accept Flutter's wrapping model as-is — each extension wraps the widget in a parent, order matters
- Document the recommended chaining order in dartdoc and README:
  - Inner to outer: `.p()` → `.bg()` → `.rounded()` → `.shadow()` → `.opacity()` → `.m()`
  - Key gotcha: `.bg().rounded()` rounds the background; `.rounded().bg()` does NOT
- No smart reordering or decoration merging — explicit wrapping, predictable widget tree

### Widget wrappers (one extension = one widget)
- `.bg(Color)` → `ColoredBox` (lightest solid background widget)
- `.rounded(double)` → `ClipRRect` (physically clips child content at corners)
- `.roundedFull()` → `ClipRRect` with `BorderRadius.circular(9999)` (pill/circle)
- `.shadow(List<BoxShadow>)` → `DecoratedBox` with `BoxDecoration(boxShadow: ...)`
- `.opacity(double)` → `Opacity` widget
- `.p(double)` / `.px()` / `.py()` / `.pt()` / `.pb()` / `.pl()` / `.pr()` → `Padding`
- `.m(double)` / `.mx()` / `.my()` / `.mt()` / `.mb()` / `.ml()` / `.mr()` → `Padding` (margin is outer padding in Flutter)
- `.width(double)` / `.height(double)` / `.size(double, double)` → `SizedBox`
- `.center()` → `Center`
- `.align(Alignment)` → `Align`
- `.clipRect()` → `ClipRect`
- `.clipOval()` → `ClipOval`

### Shadow parameter type
- `.shadow()` accepts `List<BoxShadow>` only — matches TwShadows type directly
- No single BoxShadow overload; users wrap in a list: `.shadow([BoxShadow(...)])`

### Margin documentation
- Dartdoc on `.m()` transparently states it wraps in Padding
- Documents that margin is outer padding in Flutter's model
- Recommends calling `.m()` after visual extensions (`.bg()`, `.rounded()`)

### Padding/Margin parameter type
- Accept `double` only — no EdgeInsets overload
- Directional variants (`.px()`, `.py()`, `.pt()`, etc.) handle asymmetric cases
- TwSpace implements double so tokens work directly: `.p(TwSpacing.s4)`

### Clip API
- `.rounded(double)` and `.roundedFull()` handle rounded clipping via ClipRRect
- `.clipRect()` and `.clipOval()` are the other clip variants
- No separate `.clipRounded()` — `.rounded()` already does this

### Text extensions
- Extensions are `on Text` — must be called BEFORE any Widget extension (which returns Widget)
- Style merging: each Text extension reads existing TextStyle, merges the new property, returns new Text with combined style
- All Text constructor parameters are preserved (textAlign, maxLines, overflow, softWrap, textDirection, locale, strutStyle, textWidthBasis, textHeightBehavior, semanticsLabel, selectionColor)
- Only `Text(String)` constructor supported — `Text.rich(InlineSpan)` is out of scope
- Available extensions: `.bold()`, `.italic()`, `.fontSize(double)`, `.textColor(Color)`, `.letterSpacing(double)`, `.lineHeight(double)`, `.fontWeight(FontWeight)`
- `.textStyle(TextStyle)` also provided for applying a full TextStyle at once (merges into existing)

### Stub cleanup
- Remove `edge_insets_extensions.dart` — TwSpace already has EdgeInsets getters, widget extensions accept double
- Remove `context_extensions.dart` — context.tw is already implemented in theme layer (tw_theme_data.dart)
- Remove corresponding commented exports from barrel file

### Claude's Discretion
- Internal helper methods for Text parameter copying (private _copyWith or similar)
- Extension method dartdoc examples beyond the recommended order
- Whether to split widget_extensions.dart into multiple files (padding_ext, bg_ext, etc.) or keep as one
- Test file organization and grouping strategy

</decisions>

<specifics>
## Specific Ideas

- Chaining should feel like Tailwind utilities: `widget.p(TwSpacing.s4).bg(TwColors.blue.shade500).rounded(TwRadii.lg)`
- Widget tree in DevTools should be predictable: each extension = one wrapper widget, outermost called last
- Text extensions should feel natural: `Text('Hello').bold().textColor(TwColors.slate.shade700).fontSize(18)`
- `.textStyle(TwFontSizes.lg.textStyle)` bridges the token system into text extensions

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `TwSpace` extension type (implements double) with EdgeInsets getters — tokens work directly as extension params
- `TwRadius` extension type (implements double) with BorderRadius getters — `.rounded(TwRadii.lg)` works
- `TwFontSize` extension type with `.textStyle` getter — bridges into `.textStyle()` text extension
- `TwShadows` as `List<BoxShadow>` constants — direct param for `.shadow(TwShadows.md)`
- `TwOpacity` as plain double constants — direct param for `.opacity(TwOpacity.o50)`
- `TwColors` with shade access — `.bg(TwColors.blue.shade500)` and `.textColor()`

### Established Patterns
- Extension types implementing base types (TwSpace implements double) — zero-cost abstractions
- Abstract final classes for token namespaces (TwSpacing, TwRadii, TwShadows, etc.)
- Barrel export with commented sections — uncomment extension exports when implemented
- VGA strict linting — zero warnings tolerance

### Integration Points
- Barrel export: uncomment `widget_extensions.dart` and `text_extensions.dart` exports
- Remove dead stubs: `edge_insets_extensions.dart`, `context_extensions.dart`
- Remove corresponding commented barrel exports for removed stubs
- Tests go in `test/src/extensions/` mirroring source structure

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-widget-extensions*
*Context gathered: 2026-03-11*
