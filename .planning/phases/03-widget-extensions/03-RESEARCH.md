# Phase 3: Widget Extensions - Research

**Researched:** 2026-03-11
**Domain:** Dart extension methods on Flutter Widget and Text classes
**Confidence:** HIGH

## Summary

Phase 3 implements chained extension methods on `Widget` and `Text` to provide Tailwind-style utility methods (`.p()`, `.bg()`, `.rounded()`, `.bold()`, etc.). Each extension wraps the receiver in a single Flutter widget (Padding, ColoredBox, ClipRRect, etc.), producing a predictable widget tree where the outermost wrapper corresponds to the last chained call.

The technical approach is straightforward Dart -- extension methods on `Widget` returning `Widget` and extensions on `Text` returning `Text`. There are no exotic dependencies or framework concerns. The primary complexity lies in (a) correctly preserving ALL Text constructor parameters when returning a new Text instance, (b) documenting chaining order gotchas (shadow + clip interaction), and (c) handling deprecated/version-gated Text properties relative to our Flutter >=3.19.0 constraint.

**Primary recommendation:** Implement two named extensions (`TwWidgetExtensions on Widget`, `TwTextExtensions on Text`), each in its own file, with comprehensive dartdoc on chaining order and a private `_copyTextWith` helper for Text parameter preservation.

<user_constraints>

## User Constraints (from CONTEXT.md)

### Locked Decisions
- Chaining order: accept Flutter's wrapping model as-is -- each extension wraps widget in parent, order matters
- Recommended order documented: inner to outer `.p()` -> `.bg()` -> `.rounded()` -> `.shadow()` -> `.opacity()` -> `.m()`
- No smart reordering or decoration merging
- One extension = one wrapper widget (specific mappings locked: `.bg()` -> ColoredBox, `.rounded()` -> ClipRRect, `.shadow()` -> DecoratedBox, `.opacity()` -> Opacity, etc.)
- `.shadow()` accepts `List<BoxShadow>` only -- no single BoxShadow overload
- Padding/margin accept `double` only -- no EdgeInsets overload
- `.rounded()` and `.roundedFull()` handle rounded clipping -- no separate `.clipRounded()`
- Text extensions are `on Text` -- must be called BEFORE any Widget extension
- Text style merging: read existing TextStyle, merge new property, return new Text
- All Text constructor params preserved (textAlign, maxLines, overflow, softWrap, textDirection, locale, strutStyle, textWidthBasis, textHeightBehavior, semanticsLabel, selectionColor)
- Only `Text(String)` constructor supported -- `Text.rich(InlineSpan)` out of scope
- Text extensions: `.bold()`, `.italic()`, `.fontSize(double)`, `.textColor(Color)`, `.letterSpacing(double)`, `.lineHeight(double)`, `.fontWeight(FontWeight)`, `.textStyle(TextStyle)`
- Stub cleanup: remove `edge_insets_extensions.dart` and `context_extensions.dart`, remove corresponding commented exports

### Claude's Discretion
- Internal helper methods for Text parameter copying (private `_copyWith` or similar)
- Extension method dartdoc examples beyond the recommended order
- Whether to split `widget_extensions.dart` into multiple files or keep as one
- Test file organization and grouping strategy

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope

</user_constraints>

<phase_requirements>

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| EXT-01 | Padding extensions -- `p`, `px`, `py`, `pt`, `pb`, `pl`, `pr` accepting `double` | Widget extension wrapping in Padding with EdgeInsets variants; TwSpace implements double so tokens work directly |
| EXT-02 | Margin extensions -- `m`, `mx`, `my`, `mt`, `mb`, `ml`, `mr` | Same Padding wrapper as EXT-01 but documented as "outer padding"; called after visual extensions |
| EXT-03 | Background color extension -- `.bg(Color)` | ColoredBox wrapper; lightest Flutter widget for solid backgrounds |
| EXT-04 | Border radius extension -- `.rounded(double)`, `.roundedFull()` | ClipRRect wrapper with BorderRadius.circular(); 9999 for `.roundedFull()` |
| EXT-05 | Opacity extension -- `.opacity(double)` | Opacity widget wrapper; TwOpacity constants are plain doubles |
| EXT-06 | Shadow extension -- `.shadow(List<BoxShadow>)` | DecoratedBox with BoxDecoration(boxShadow:); no explicit color needed |
| EXT-07 | Sizing extensions -- `.width()`, `.height()`, `.size()` | SizedBox wrapper |
| EXT-08 | Alignment extensions -- `.center()`, `.align(Alignment)` | Center and Align widgets |
| EXT-09 | Clip extensions -- `.clipRect()`, `.clipOval()` | ClipRect and ClipOval widgets; `.clipRounded()` removed per CONTEXT.md (`.rounded()` covers it) |
| EXT-10 | Text-specific extensions on Text | Extension `on Text` returning new Text with merged TextStyle; must preserve all 15 constructor parameters |

</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| flutter | >=3.19.0 | Framework providing Widget, Text, Padding, etc. | Project SDK constraint |
| dart | >=3.3.0 | Language features: extension methods, extension types | Project SDK constraint |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| flutter_test | SDK | Widget testing with WidgetTester | All extension method tests |
| very_good_analysis | ^5.1.0 | Strict linting | Already configured, zero warnings tolerance |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Named extensions | Unnamed extensions | Named required for explicit imports and avoids conflicts -- always name |
| Separate files per concern | Single large file | Discretion area; see Architecture recommendation below |

**Installation:** No new dependencies needed. Everything uses `flutter` SDK and existing dev deps.

## Architecture Patterns

### Recommended Project Structure (Claude's Discretion: file split)
```
lib/src/extensions/
  widget_extensions.dart    # All Widget extensions (EXT-01 through EXT-09)
  text_extensions.dart      # All Text extensions (EXT-10)
```

**Recommendation: keep Widget extensions in ONE file.** Rationale:
- Total method count is ~22 methods -- manageable in a single file (~200-250 lines)
- All methods follow the identical pattern: wrap `this` in a parent widget, return it
- Users import via barrel file anyway, so file splitting provides no import benefit
- Splitting into 9 files (one per EXT requirement) would create unnecessary navigation overhead

### Pattern 1: Widget Extension (wrap-and-return)
**What:** Each extension method wraps `this` in a single-purpose Flutter widget and returns it.
**When to use:** Every Widget extension (EXT-01 through EXT-09).
**Example:**
```dart
// Source: Dart language spec + Flutter widget model
extension TwWidgetExtensions on Widget {
  /// Adds padding on all sides.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.all].
  /// Accepts [TwSpacing] tokens directly: `.p(TwSpacing.s4)`.
  Widget p(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  /// Applies a solid background color.
  ///
  /// Wraps this widget in a [ColoredBox].
  Widget bg(Color color) => ColoredBox(color: color, child: this);

  /// Clips child content with rounded corners.
  ///
  /// Wraps this widget in a [ClipRRect].
  Widget rounded(double radius) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );
}
```

### Pattern 2: Text Extension (copy-with-merged-style)
**What:** Each Text extension reads the existing Text's properties, merges a style change, returns a new Text.
**When to use:** All text-specific extensions (EXT-10).
**Example:**
```dart
// Source: Flutter Text API + Dart extension methods
extension TwTextExtensions on Text {
  /// Makes the text bold (FontWeight.w700).
  Text bold() => _copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );

  /// Private helper: creates a new Text preserving all constructor params.
  Text _copyWith({TextStyle? style}) => Text(
        data!,  // safe: we only support Text(String), not Text.rich
        key: key,
        style: style ?? this.style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}
```

### Pattern 3: Style Merging (non-destructive)
**What:** When the Text already has a TextStyle, merge rather than replace.
**When to use:** Every Text extension that modifies style.
**Key mechanic:**
```dart
final merged = (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold);
```
This ensures:
- If no existing style: creates TextStyle with just the new property
- If existing style: preserves all existing properties, overrides only the target

### Anti-Patterns to Avoid
- **Creating new TextStyle from scratch:** `TextStyle(fontWeight: FontWeight.bold)` discards existing style properties. Always use `.copyWith()` on the existing style.
- **Returning Widget from Text extensions:** Text extensions MUST return `Text`, not `Widget`, so they can be chained with other Text extensions before Widget extensions.
- **Using Container instead of single-purpose widgets:** Container is a convenience wrapper that internally delegates to lighter widgets. Use ColoredBox, Padding, SizedBox directly for transparency and performance.
- **Forgetting to forward `data!`:** The `data` property on Text is `String?` (nullable because `Text.rich` sets it to null). Since we only support `Text(String)`, asserting `data!` is correct. But if someone somehow calls our extension on a `Text.rich`, it will throw. This is acceptable per CONTEXT.md scope.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Background color | Custom paint or Container | `ColoredBox` | Lightest widget for solid color; has const constructor |
| Rounded corners + clipping | Custom `CustomClipper` | `ClipRRect` with `BorderRadius.circular()` | Built-in, handles anti-aliasing |
| Box shadows | Custom painter | `DecoratedBox` with `BoxDecoration(boxShadow:)` | Standard Flutter pattern, supports multiple shadows |
| TextStyle merging | Manual property copying | `TextStyle.copyWith()` | Handles all 25+ TextStyle properties correctly |

**Key insight:** Every extension method in this phase maps to exactly one Flutter widget that already exists. There is zero custom rendering or layout logic.

## Common Pitfalls

### Pitfall 1: Shadow + Clip Ordering
**What goes wrong:** `.shadow(TwShadows.md).rounded(TwRadii.lg)` -- ClipRRect clips the shadow because the shadow (DecoratedBox) is the CHILD of the clip.
**Why it happens:** Each extension wraps in a parent. `.rounded()` called after `.shadow()` wraps the shadow widget inside ClipRRect, which clips its children including the shadow.
**How to avoid:** Document the recommended chaining order prominently. Shadow should be called AFTER rounded: `.rounded(TwRadii.lg).shadow(TwShadows.md)` so the DecoratedBox paints the shadow OUTSIDE the clipped area.
**Warning signs:** Shadows appearing clipped or invisible when rounded corners are applied.

### Pitfall 2: `.bg().rounded()` vs `.rounded().bg()`
**What goes wrong:** `.rounded().bg()` does NOT produce a rounded background -- the ColoredBox paints a rectangular background OUTSIDE the ClipRRect.
**Why it happens:** `.bg()` wraps in ColoredBox which paints a solid rectangle. If ClipRRect is the child, only the child content is clipped, not the parent background.
**How to avoid:** Document that `.bg().rounded()` is the correct order (background inside, rounded clip outside).
**Warning signs:** Background color extends beyond rounded corners.

### Pitfall 3: Text Extension Type Narrowing
**What goes wrong:** After calling a Widget extension, the return type is `Widget`, not `Text`. Text-specific extensions are no longer accessible.
**Why it happens:** Widget extensions are `on Widget` and return `Widget`. Once you call `.p(16)` on a Text, you get a Padding wrapping a Text -- the Padding is a Widget, not a Text.
**How to avoid:** Always chain Text extensions FIRST: `Text('Hi').bold().textColor(red).p(16).bg(blue)`. Document this ordering requirement.
**Warning signs:** Compile error "The method 'bold' isn't defined for the type 'Widget'".

### Pitfall 4: Forgetting Text Constructor Parameters
**What goes wrong:** A user's `Text('Hello', maxLines: 1, overflow: TextOverflow.ellipsis)` loses maxLines and overflow after `.bold()`.
**Why it happens:** The extension creates a new Text but forgets to forward some constructor parameters.
**How to avoid:** The `_copyWith` helper MUST forward ALL 15 supported parameters. Write tests that verify parameter preservation for each property.
**Warning signs:** Text overflow behavior, alignment, or locale changes after applying text extensions.

### Pitfall 5: `semanticsIdentifier` Not Available in Flutter 3.19
**What goes wrong:** Using `semanticsIdentifier` in the Text copy helper causes compile errors on Flutter 3.19-3.31.
**Why it happens:** `semanticsIdentifier` was merged to Flutter master on March 13, 2025 and shipped in Flutter 3.32+. Our SDK constraint is `>=3.19.0`.
**How to avoid:** Do NOT forward `semanticsIdentifier`. It's a newer property not available in our minimum SDK version. If the project later bumps the minimum to >=3.32, it can be added.
**Warning signs:** Compile error on CI or user's older Flutter version.

### Pitfall 6: `textScaleFactor` Deprecation Warning
**What goes wrong:** Accessing `textScaleFactor` on Text triggers a deprecation warning, violating VGA's zero-warnings policy.
**Why it happens:** `textScaleFactor` was deprecated in Flutter 3.16 (before our minimum 3.19).
**How to avoid:** Forward only `textScaler`, not `textScaleFactor`. Users on Flutter >=3.19 should already be using `textScaler`. Accessing the deprecated property to preserve it would require `// ignore: deprecated_member_use`, which is fragile.
**Warning signs:** Analysis warnings about deprecated members.

### Pitfall 7: Opacity Widget Performance
**What goes wrong:** `Opacity` widget with value 0.0 or 1.0 is wasteful -- Flutter still creates a layer.
**Why it happens:** The Opacity widget always composites into an offscreen buffer.
**How to avoid:** Document in dartdoc that for 0.0 opacity, consider using `Visibility` instead. For 1.0, the extension is a no-op visually but still adds a widget to the tree. This is acceptable -- we chose simplicity over optimization per CONTEXT.md "no smart reordering."
**Warning signs:** Performance profiling showing unnecessary layer creation.

## Code Examples

Verified patterns from official sources:

### Widget Extension - Padding Variants
```dart
// All padding variants following the same pattern
extension TwWidgetExtensions on Widget {
  Widget p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget px(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Widget py(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  Widget pt(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  Widget pb(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);

  Widget pl(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  Widget pr(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);
}
```

### Widget Extension - Visual
```dart
Widget bg(Color color) => ColoredBox(color: color, child: this);

Widget rounded(double radius) =>
    ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);

Widget roundedFull() =>
    ClipRRect(borderRadius: BorderRadius.circular(9999), child: this);

Widget shadow(List<BoxShadow> shadows) => DecoratedBox(
      decoration: BoxDecoration(boxShadow: shadows),
      child: this,
    );

Widget opacity(double value) => Opacity(opacity: value, child: this);
```

### Widget Extension - Sizing & Alignment
```dart
Widget width(double value) => SizedBox(width: value, child: this);

Widget height(double value) => SizedBox(height: value, child: this);

Widget size(double width, double height) =>
    SizedBox(width: width, height: height, child: this);

Widget center() => Center(child: this);

Widget align(Alignment alignment) => Align(alignment: alignment, child: this);
```

### Widget Extension - Clips
```dart
Widget clipRect() => ClipRect(child: this);

Widget clipOval() => ClipOval(child: this);
```

### Text Extension - Full Implementation Pattern
```dart
extension TwTextExtensions on Text {
  Text bold() => _copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );

  Text italic() => _copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        ),
      );

  Text fontSize(double size) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(fontSize: size),
      );

  Text textColor(Color color) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(color: color),
      );

  Text letterSpacing(double spacing) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(
          letterSpacing: spacing,
        ),
      );

  Text lineHeight(double height) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(height: height),
      );

  Text fontWeight(FontWeight weight) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(fontWeight: weight),
      );

  Text textStyle(TextStyle textStyle) => _copyWith(
        style: (style ?? const TextStyle()).merge(textStyle),
      );

  /// Private helper preserving all Text(String) constructor params.
  Text _copyWith({TextStyle? style}) => Text(
        data!,
        key: key,
        style: style ?? this.style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}
```

### Barrel Export Updates
```dart
// After implementation, barrel file should have:
export 'src/extensions/widget_extensions.dart';
export 'src/extensions/text_extensions.dart';

// REMOVED (dead stubs):
// export 'src/extensions/edge_insets_extensions.dart';
// export 'src/extensions/context_extensions.dart';
```

### Test Pattern - Widget Extension
```dart
// Source: existing project test patterns (tw_theme_test.dart)
testWidgets('.p() wraps in Padding with EdgeInsets.all', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: const SizedBox().p(16),
    ),
  );

  final padding = tester.widget<Padding>(find.byType(Padding));
  expect(padding.padding, const EdgeInsets.all(16));
});
```

### Test Pattern - Text Extension Parameter Preservation
```dart
testWidgets('.bold() preserves all Text parameters', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Text(
        'Hello',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ).bold(),
    ),
  );

  final text = tester.widget<Text>(find.byType(Text));
  expect(text.style?.fontWeight, FontWeight.bold);
  expect(text.maxLines, 2);
  expect(text.overflow, TextOverflow.ellipsis);
  expect(text.textAlign, TextAlign.center);
  expect(text.data, 'Hello');
});
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `Container(color: ...)` | `ColoredBox(color: ...)` | Flutter linter rule `use_colored_box` | Lighter widget, VGA enforces this |
| `Container(decoration: BoxDecoration(borderRadius: ...))` | `ClipRRect(borderRadius: ...)` | Best practice (always was) | Actual clipping vs. decorative border radius |
| `textScaleFactor: double` | `textScaler: TextScaler` | Flutter 3.16 (Nov 2023) | Non-linear font scaling support; deprecated param still exists |
| N/A | `semanticsIdentifier` | Flutter 3.32+ (May 2025) | New property NOT available at our min SDK 3.19 |

**Deprecated/outdated:**
- `Text.textScaleFactor`: Deprecated since Flutter 3.16 -- do not access or forward, use `textScaler` instead
- `edge_insets_extensions.dart` stub: Superseded by TwSpace extension type with EdgeInsets getters
- `context_extensions.dart` stub: Superseded by context.tw implemented in tw_theme_data.dart

## Open Questions

1. **Margin dartdoc phrasing**
   - What we know: `.m()` wraps in Padding (because Flutter has no Margin widget)
   - What's unclear: Exact dartdoc wording to explain this transparently
   - Recommendation: Use `/// Adds outer spacing (margin). Wraps this widget in [Padding].` with a `/// **Note:** Flutter has no margin widget; margin is outer padding.` remark

2. **`.textStyle()` merge vs. replace semantics**
   - What we know: CONTEXT.md says "merges into existing" for `.textStyle(TextStyle)`
   - What's unclear: Whether `merge` or `copyWith` is the right method
   - Recommendation: Use `TextStyle.merge()` for `.textStyle()` (it overlays non-null properties) and `TextStyle.copyWith()` for individual property extensions. This distinction matters: `merge` only overrides non-null fields in the argument, while `copyWith` always overrides the specified field.

3. **EXT-09 discrepancy: `.clipRounded(double)` in REQUIREMENTS.md but removed in CONTEXT.md**
   - What we know: REQUIREMENTS.md lists `.clipRounded(double)` under EXT-09. CONTEXT.md explicitly states "No separate `.clipRounded()` -- `.rounded()` already does this."
   - What's unclear: N/A -- CONTEXT.md is the later, more refined decision
   - Recommendation: Follow CONTEXT.md -- implement `.clipRect()` and `.clipOval()` only for EXT-09. The `.rounded()` from EXT-04 covers the rounded clip case.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | flutter_test (SDK) |
| Config file | none (standard `flutter test` setup) |
| Quick run command | `flutter test test/src/extensions/` |
| Full suite command | `flutter test` |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| EXT-01 | 7 padding variants wrap in Padding with correct EdgeInsets | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-02 | 7 margin variants wrap in Padding with correct EdgeInsets | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-03 | `.bg(Color)` wraps in ColoredBox with correct color | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-04 | `.rounded()` and `.roundedFull()` wrap in ClipRRect with correct radius | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-05 | `.opacity()` wraps in Opacity with correct value | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-06 | `.shadow()` wraps in DecoratedBox with correct BoxDecoration | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-07 | `.width()`, `.height()`, `.size()` wrap in SizedBox | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-08 | `.center()` wraps in Center, `.align()` wraps in Align | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-09 | `.clipRect()` wraps in ClipRect, `.clipOval()` wraps in ClipOval | unit (widget test) | `flutter test test/src/extensions/widget_extensions_test.dart` | No -- Wave 0 |
| EXT-10 | 8 text extensions merge style and preserve all Text params | unit (widget test) | `flutter test test/src/extensions/text_extensions_test.dart` | No -- Wave 0 |

### Sampling Rate
- **Per task commit:** `flutter test test/src/extensions/`
- **Per wave merge:** `flutter test`
- **Phase gate:** Full suite green + `flutter analyze` zero warnings before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `test/src/extensions/widget_extensions_test.dart` -- covers EXT-01 through EXT-09
- [ ] `test/src/extensions/text_extensions_test.dart` -- covers EXT-10
- No framework install needed -- flutter_test already in dev_dependencies

## Sources

### Primary (HIGH confidence)
- [Flutter Text constructor API docs](https://api.flutter.dev/flutter/widgets/Text/Text.html) -- complete parameter list verified
- [Flutter Text class API docs](https://api.flutter.dev/flutter/widgets/Text-class.html) -- public property list verified
- [Flutter TextStyle.copyWith API docs](https://api.flutter.dev/flutter/painting/TextStyle/copyWith.html) -- merge/copyWith semantics
- [Flutter deprecation guide: textScaleFactor](https://docs.flutter.dev/release/breaking-changes/deprecate-textscalefactor) -- deprecated in 3.16, replaced by textScaler
- [Flutter semanticsIdentifier PR #163843](https://github.com/flutter/flutter/pull/163843) -- merged March 13, 2025, post-3.29 release
- Project source: `lib/src/tokens/spacing.dart`, `radius.dart`, `typography.dart`, `shadows.dart`, `opacity.dart` -- verified token types and APIs
- Project source: `test/src/theme/tw_theme_test.dart` -- verified widget test patterns

### Secondary (MEDIUM confidence)
- [ClipRRect clips BoxShadow discussion](https://rydmike.com/blog_cliprect_boxshadow.html) -- shadow/clip interaction verified with multiple sources
- [ColoredBox vs Container performance](https://docs.flutter.dev/release/breaking-changes/container-color) -- official Flutter breaking change doc
- [Dart extension methods guide](https://dart.dev/language/extension-methods) -- official Dart docs on extension method resolution

### Tertiary (LOW confidence)
- None -- all findings verified with official sources

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- no new dependencies, pure Flutter SDK
- Architecture: HIGH -- extension methods are textbook Dart, wrapper pattern is standard Flutter
- Pitfalls: HIGH -- shadow/clip interaction verified with official docs and community reports; Text property list verified against API docs
- Text parameter preservation: HIGH -- verified complete property list against Flutter 3.41 API docs, cross-referenced with SDK constraint

**Research date:** 2026-03-11
**Valid until:** 2026-04-11 (stable domain -- extension methods and widget APIs change very slowly)
