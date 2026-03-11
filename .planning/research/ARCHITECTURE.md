# Architecture Patterns

**Domain:** Flutter design token / utility-first styling package
**Researched:** 2026-03-11

---

## Recommended Architecture

The three-tier layered architecture is the right call. The PRD nails the dependency direction. What follows is *how* each tier should be internally structured, what talks to what, and where the subtle traps live.

```
                          Consumer App
                              |
                    +---------+---------+
                    |                   |
              [Tier 3: TwStyle]   [Tier 2: Extensions]
              composable styles    widget wrapping
                    |                   |
                    +--------+----------+
                             |
                    [Tier 1: Design Tokens]
                    extension types + ThemeExtension<T>
                             |
                      [Flutter SDK]
                  ThemeData / Widget / etc.
```

### The Golden Rule

**Data flows DOWN. Dependencies point DOWN. Never up, never sideways between tiers.**

- Tier 1 knows nothing about Tier 2 or Tier 3.
- Tier 2 consumes Tier 1 types as parameters (but never imports Tier 3).
- Tier 3 consumes Tier 1 types and Tier 1's ThemeExtension resolution (via BuildContext), and produces Tier 2-equivalent widget trees.
- The Theme subsystem (part of Tier 1) is the *only* thing that touches BuildContext at the token level.

---

## Component Boundaries

| Component | Responsibility | Depends On | Communicates With |
|-----------|---------------|------------|-------------------|
| `tokens/` (7 files) | Compile-time const values with extension types | Flutter SDK only (`dart:ui`, `painting`) | Nothing -- leaf nodes |
| `theme/tw_theme_extension.dart` | ThemeExtension<T> wrappers for each token category with `copyWith`/`lerp` | `tokens/` | ThemeData (via Flutter's extension system) |
| `theme/tw_theme_data.dart` | Composite facade aggregating all ThemeExtensions | `tw_theme_extension.dart` | BuildContext (via `Theme.of`) |
| `theme/tw_theme.dart` | InheritedWidget / Theme wrapper injecting all extensions | `tw_theme_data.dart` | Widget tree (ancestor lookup) |
| `extensions/context_extensions.dart` | `context.tw` accessor | `tw_theme_data.dart` | BuildContext |
| `extensions/widget_extensions.dart` | `.p()`, `.bg()`, `.rounded()`, etc. on Widget | Flutter SDK (`Padding`, `DecoratedBox`, etc.) | Widget tree (wraps in parent widgets) |
| `extensions/text_extensions.dart` | `.bold()`, `.fontSize()`, etc. on Text | Flutter SDK (`Text`, `TextStyle`) | Widget tree (returns modified Text) |
| `extensions/edge_insets_extensions.dart` | Convenience EdgeInsets builders | `tokens/spacing.dart` types | EdgeInsets |
| `styles/tw_style.dart` | Immutable style object with merge/resolve/apply | `tokens/`, `theme/`, Flutter SDK | Widget tree (via `.apply()`) |
| `styles/tw_variant.dart` | Sealed class for conditional style resolution | Flutter SDK (`MediaQuery`, `Theme`) | `tw_style.dart` |
| `styles/tw_styled_widget.dart` | Convenience StatelessWidget wrapper | `tw_style.dart` | Widget tree |

---

## Tier 1: Design Tokens -- Deep Dive

### Extension Type Pattern

The `extension type const` pattern is the backbone. Here is the canonical structure every token file must follow:

```dart
/// Zero-cost wrapper around [double] representing a spacing value
/// from the Tailwind v4 scale.
///
/// Because this `implements double`, instances are usable anywhere
/// a `double` is expected -- no `.value` accessor needed.
extension type const TwSpace(double _value) implements double {
  // Scale values as static constants
  static const s0   = TwSpace(0);
  static const s0p5 = TwSpace(2);
  static const s1   = TwSpace(4);
  // ... through s96

  // Convenience getters that produce Flutter types
  EdgeInsets get all    => EdgeInsets.all(_value);
  EdgeInsets get x      => EdgeInsets.symmetric(horizontal: _value);
  EdgeInsets get y      => EdgeInsets.symmetric(vertical: _value);
  EdgeInsets get top    => EdgeInsets.only(top: _value);
  EdgeInsets get bottom => EdgeInsets.only(bottom: _value);
  EdgeInsets get left   => EdgeInsets.only(left: _value);
  EdgeInsets get right  => EdgeInsets.only(right: _value);
}
```

**Critical implementation details:**

1. **Private representation field (`_value`)**: Use `_value` not `value` to discourage direct access. The extension type `implements double`, so consumers just use it as a `double`. The private name prevents confusion about whether to call `.value` or just pass the token directly.

2. **`const` keyword on the extension type**: Required for `static const` members to work. Without `extension type const`, you cannot have `static const s0 = TwSpace(0)`.

3. **`implements double` (not `implements num`)**: Be specific. `double` gives you `+`, `-`, `*`, `/` operators and all double methods. `num` would also work but is less precise.

4. **No instance state beyond the representation type**: Extension types cannot have instance variables. All convenience methods must derive from the single representation value.

5. **Runtime erasure**: At runtime, `TwSpace(16)` is literally `16.0`. No object allocation. No wrapper. This is why it is the correct choice for tokens that appear hundreds of times in a widget tree.

### Extension Type Gotcha: Type Checks

```dart
var space = TwSpace.s4; // compile-time type: TwSpace, runtime type: double
space is double;  // TRUE (runtime check against representation type)
space is TwSpace; // TRUE (compile-time, always succeeds because the
                  //       compiler knows the static type)
```

This means you **cannot use runtime type checks to distinguish TwSpace from raw double**. This is fine for tokens (you never need to) but is worth documenting.

### Color Token Organization

Colors are the largest token set (242 + 3 semantic). Two viable structures:

**Recommended: Abstract final class with static const fields**

```dart
abstract final class TwColors {
  // Slate family
  static const Color slate50  = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  // ...

  // Convenience: family accessor returning all shades
  static const List<Color> slate = [slate50, slate100, /* ... */];
}
```

**Why not extension type for colors?** `TwColor(Color value) implements Color` would work, but `Color` is a complex class with many methods. The extension type would need to expose all of `Color`'s interface via `implements`, which it does automatically -- but there is no *benefit* to the wrapper. Unlike `TwSpace implements double` where you add EdgeInsets getters, `TwColor` would add nothing that `Color` does not already have. A plain `static const Color` is simpler, more predictable, and equally const-friendly.

**Exception**: If you later want to add methods like `.withOpacity50` that return a `TwColor`, then the extension type earns its keep. For v1, prefer the simpler approach.

### Where Extension Types Earn Their Keep

| Token | Extension Type? | Rationale |
|-------|----------------|-----------|
| `TwSpace` | YES | Adds EdgeInsets convenience getters to double |
| `TwRadius` | YES | Adds `BorderRadius` convenience getters to double |
| `TwFontSize` | YES | Could add paired line-height getter |
| `TwOpacity` | MAYBE | Adds little over raw double, but naming consistency |
| `TwColor` | NO | Color already has a rich API; wrapper adds nothing in v1 |
| `TwFontWeight` | NO | Just `FontWeight` constants, no wrapper needed |
| `TwLetterSpacing` | NO | Just double constants |
| `TwLineHeight` | NO | Just double constants |
| `TwShadow` | NO | `List<BoxShadow>` -- cannot wrap a List in an extension type that implements List usefully |
| `TwBreakpoint` | NO | Better as sealed class or enum with value field |

---

## Tier 1 (continued): ThemeExtension Integration

### The Dual-Access Pattern

Tokens serve two masters:

1. **Static access** (compile-time const): `TwSpace.s4`, `TwColors.blue500`
2. **Theme-aware access** (runtime, overridable): `context.tw.spacing.s4`

These are *not* redundant. Static access is for hardcoded design -- "this padding is always 16px." Theme access is for overridable design -- "this padding is whatever the active theme says s4 is."

### ThemeExtension Implementation

Each token category gets one ThemeExtension class:

```dart
@immutable
class TwSpacingTheme extends ThemeExtension<TwSpacingTheme> {
  final double s0;
  final double s0p5;
  final double s1;
  // ... all 37 values

  const TwSpacingTheme({
    this.s0   = 0,
    this.s0p5 = 2,
    this.s1   = 4,
    // ... defaults from Tailwind scale
  });

  @override
  TwSpacingTheme copyWith({
    double? s0,
    double? s0p5,
    double? s1,
    // ...
  }) {
    return TwSpacingTheme(
      s0:   s0   ?? this.s0,
      s0p5: s0p5 ?? this.s0p5,
      s1:   s1   ?? this.s1,
      // ...
    );
  }

  @override
  TwSpacingTheme lerp(covariant TwSpacingTheme? other, double t) {
    if (other == null) return this;
    return TwSpacingTheme(
      s0:   lerpDouble(s0, other.s0, t)!,
      s0p5: lerpDouble(s0p5, other.s0p5, t)!,
      s1:   lerpDouble(s1, other.s1, t)!,
      // ...
    );
  }
}
```

**Lerp type dispatch for non-numeric tokens:**

| Property Type | Lerp Method |
|---------------|-------------|
| `double` | `lerpDouble(a, b, t)` |
| `Color` | `Color.lerp(a, b, t)` |
| `BorderRadius` | `BorderRadius.lerp(a, b, t)` |
| `List<BoxShadow>` | `BoxShadow.lerpList(a, b, t)` |
| `TextStyle` | `TextStyle.lerp(a, b, t)` |
| `FontWeight` | `FontWeight.lerp(a, b, t)` |
| `Duration` (v2) | Manual: `Duration(ms: lerpDouble(...))` |

### TwThemeData: The Composite Facade

```dart
class TwThemeData {
  final TwColorTheme colors;
  final TwSpacingTheme spacing;
  final TwTypographyTheme typography;
  final TwRadiusTheme radius;
  final TwShadowTheme shadows;
  final TwBreakpointTheme breakpoints;
  final TwOpacityTheme opacity;

  const TwThemeData({
    this.colors      = const TwColorTheme(),
    this.spacing     = const TwSpacingTheme(),
    this.typography  = const TwTypographyTheme(),
    this.radius      = const TwRadiusTheme(),
    this.shadows     = const TwShadowTheme(),
    this.breakpoints = const TwBreakpointTheme(),
    this.opacity     = const TwOpacityTheme(),
  });

  /// Resolve from nearest Theme ancestor.
  /// Falls back to defaults if TwTheme not installed.
  static TwThemeData of(BuildContext context) {
    return TwThemeData(
      colors:      Theme.of(context).extension<TwColorTheme>()      ?? const TwColorTheme(),
      spacing:     Theme.of(context).extension<TwSpacingTheme>()    ?? const TwSpacingTheme(),
      typography:  Theme.of(context).extension<TwTypographyTheme>() ?? const TwTypographyTheme(),
      radius:      Theme.of(context).extension<TwRadiusTheme>()     ?? const TwRadiusTheme(),
      shadows:     Theme.of(context).extension<TwShadowTheme>()     ?? const TwShadowTheme(),
      breakpoints: Theme.of(context).extension<TwBreakpointTheme>() ?? const TwBreakpointTheme(),
      opacity:     Theme.of(context).extension<TwOpacityTheme>()    ?? const TwOpacityTheme(),
    );
  }

  static TwThemeData? maybeOf(BuildContext context) {
    // Returns null if no TwTheme ancestor exists
    final colors = Theme.of(context).extension<TwColorTheme>();
    if (colors == null) return null;
    return of(context);
  }

  // Factory presets
  factory TwThemeData.light() => const TwThemeData();
  factory TwThemeData.dark()  => TwThemeData(
    colors: TwColorTheme.dark(),
    // other dark overrides
  );
}
```

**Architecture decision: `TwThemeData.of()` should call `Theme.of(context)` ONCE and extract all extensions, not call it 7 times.** This matters for performance -- each `Theme.of()` call registers a dependency on the InheritedWidget. Calling it once is sufficient.

```dart
// BETTER: single Theme.of() call
static TwThemeData of(BuildContext context) {
  final themeData = Theme.of(context);
  return TwThemeData(
    colors:      themeData.extension<TwColorTheme>()      ?? const TwColorTheme(),
    spacing:     themeData.extension<TwSpacingTheme>()    ?? const TwSpacingTheme(),
    // ...
  );
}
```

### TwTheme Widget

Two options for the wrapper widget:

**Option A: Wrap Theme (Recommended)**

```dart
class TwTheme extends StatelessWidget {
  final TwThemeData data;
  final Widget child;

  const TwTheme({required this.data, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          data.colors,
          data.spacing,
          data.typography,
          data.radius,
          data.shadows,
          data.breakpoints,
          data.opacity,
        ],
      ),
      child: child,
    );
  }
}
```

This is Flutter-idiomatic. It piggybacks on Theme's InheritedWidget, so `Theme.of(context).extension<T>()` just works. No custom InheritedWidget needed.

**Option B: Custom InheritedWidget** -- Only if we need TwThemeData to be accessible *without* ThemeData. Not worth the complexity for v1.

---

## Tier 2: Widget Extensions -- Deep Dive

### The Wrapping Pattern

Each extension method wraps the receiver widget in a parent widget. This is how Flutter itself works -- `Container` is just `Padding` + `DecoratedBox` + `ConstrainedBox` + etc.

```dart
extension TwWidgetExtensions on Widget {
  /// Wraps this widget in [Padding] with the given value on all sides.
  Widget p(double value) => Padding(
    padding: EdgeInsets.all(value),
    child: this,
  );

  /// Wraps this widget in [DecoratedBox] with the given background color.
  Widget bg(Color color) => DecoratedBox(
    decoration: BoxDecoration(color: color),
    child: this,
  );

  /// Wraps this widget in [ClipRRect] with the given border radius.
  Widget rounded(double radius) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: this,
  );
}
```

### Widget Tree Depth Concern

Chaining 5 extensions creates 5 wrapper widgets:

```dart
Text('Hello')
    .p(16)          // Padding
    .bg(Colors.red) // DecoratedBox
    .rounded(8)     // ClipRRect
    .shadow(...)    // DecoratedBox
    .opacity(0.8)   // Opacity
// Result: Opacity > DecoratedBox > ClipRRect > DecoratedBox > Padding > Text
```

**Is this a problem?** No, for two reasons:

1. **Flutter is designed for deep widget trees.** The framework uses sublinear algorithms for layout and building. Each of these widgets (Padding, DecoratedBox, ClipRRect, Opacity) has a single child -- the layout pass is O(n) where n is the chain depth. For 5-10 wrappers, this is negligible.

2. **This is what Container does internally.** `Container` with padding, color, and constraints creates `Padding > ColoredBox > ConstrainedBox` internally. Widget extensions just make the composition explicit.

**Where it WOULD be a problem:** If someone chains 50+ extensions in a single expression. This is a style issue, not an architectural one. Document recommended chain length (5-8 max) and suggest extracting TwStyle for complex compositions.

### Text Extension Pattern: Modification, Not Wrapping

Text extensions are fundamentally different from widget extensions. They must return a *modified* Text widget, not wrap it:

```dart
extension TwTextExtensions on Text {
  /// Returns a new [Text] with bold font weight applied.
  Text bold() => Text(
    data ?? '',
    key: key,
    style: (style ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.bold,
    ),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    // ... preserve all other Text properties
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );
}
```

**Critical: You must preserve ALL Text constructor parameters.** Missing one (like `maxLines` or `textDirection`) silently resets it to the default. This is the #1 source of bugs in Text extension implementations. Build a private helper:

```dart
extension TwTextExtensions on Text {
  /// Creates a copy of this Text with a modified style.
  Text _copyWithStyle(TextStyle Function(TextStyle) modify) {
    return Text(
      data ?? '',
      key: key,
      style: modify(style ?? const TextStyle()),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text bold() => _copyWithStyle((s) => s.copyWith(fontWeight: FontWeight.bold));
  Text italic() => _copyWithStyle((s) => s.copyWith(fontStyle: FontStyle.italic));
  Text fontSize(double size) => _copyWithStyle((s) => s.copyWith(fontSize: size));
  Text textColor(Color color) => _copyWithStyle((s) => s.copyWith(color: color));
}
```

**Text.rich() problem**: `Text.rich(TextSpan(...))` uses `textSpan` not `data`. The helper must handle both:

```dart
Text _copyWithStyle(TextStyle Function(TextStyle) modify) {
  final newStyle = modify(style ?? const TextStyle());
  if (textSpan != null) {
    return Text.rich(
      textSpan!,
      key: key,
      style: newStyle,
      // ... all other fields
    );
  }
  return Text(
    data ?? '',
    key: key,
    style: newStyle,
    // ... all other fields
  );
}
```

### Margin Extensions: The Container Trap

The PRD specifies margin extensions (`.m()`, `.mx()`, etc.). Margin is tricky in Flutter because `Padding` only does *inner* padding, while CSS margin is *outer* spacing.

**Option A: Wrap in another Padding (Recommended)**

```dart
Widget m(double value) => Padding(
  padding: EdgeInsets.all(value),
  child: this,
);
```

This is semantically identical to padding in Flutter. The distinction between "padding" and "margin" is purely about developer intent -- `.p()` means "space inside this widget's decoration" while `.m()` means "space outside." Both produce `Padding` widgets.

**Option B: Wrap in Container with margin** -- Adds unnecessary widget overhead (Container decomposes to multiple widgets). Avoid.

**Document clearly**: In Flutter, `.m(16).bg(Colors.red)` puts space *outside* the red background (because `.m()` wraps first, then `.bg()` wraps the Padding). The order matters and is visually "bottom-up" -- the last extension in the chain is the outermost widget.

---

## Tier 3: Style Composition -- Deep Dive

### How Mix Does It (Lessons Learned)

Mix uses a three-layer internal architecture:

1. **Attribute**: A description of a styling intention (e.g., "padding: 16"). Attributes are *mergeable* -- you can combine two padding attributes and the last one wins.
2. **Spec**: The *resolved* styling for a specific widget type (e.g., `BoxSpec` has padding, color, border, etc.). Specs are what widgets actually read during `build()`.
3. **Style**: A collection of Attributes, possibly with variants. `Style` merges Attributes, resolves variants against BuildContext, then produces a Spec.

This is over-engineered for tailwind_flutter's scope. Mix needs this because it defines *custom widget types* (Box, StyledText) that need their own spec resolution. tailwind_flutter wraps standard Flutter widgets.

### TwStyle: Simpler Is Better

```dart
@immutable
class TwStyle {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? shadows;
  final double? opacity;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;
  final Map<TwVariant, TwStyle>? variants;

  const TwStyle({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
    this.opacity,
    this.constraints,
    this.textStyle,
    this.alignment,
    this.clipBehavior,
    this.variants,
  });

  /// Merge: other's non-null fields override this.
  /// Variant maps are recursively merged.
  TwStyle merge(TwStyle other) {
    return TwStyle(
      padding:          other.padding          ?? padding,
      margin:           other.margin           ?? margin,
      backgroundColor:  other.backgroundColor  ?? backgroundColor,
      borderRadius:     other.borderRadius     ?? borderRadius,
      shadows:          other.shadows          ?? shadows,
      opacity:          other.opacity          ?? opacity,
      constraints:      other.constraints      ?? constraints,
      textStyle:        other.textStyle != null
          ? (textStyle?.merge(other.textStyle!) ?? other.textStyle)
          : textStyle,
      alignment:        other.alignment        ?? alignment,
      clipBehavior:     other.clipBehavior     ?? clipBehavior,
      variants:         _mergeVariants(variants, other.variants),
    );
  }

  /// Resolve: flatten variants based on context, return a variant-free TwStyle.
  TwStyle resolve(BuildContext context) {
    var resolved = _withoutVariants();
    if (variants != null) {
      for (final entry in variants!.entries) {
        if (entry.key.matches(context)) {
          resolved = resolved.merge(entry.value.resolve(context));
        }
      }
    }
    return resolved;
  }

  /// Apply: produce a widget tree from the resolved style.
  Widget apply({required Widget child}) {
    Widget result = child;

    // Apply from inside out (order matters!)
    if (textStyle != null) {
      result = DefaultTextStyle.merge(style: textStyle!, child: result);
    }
    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }
    if (constraints != null) {
      result = ConstrainedBox(constraints: constraints!, child: result);
    }
    if (backgroundColor != null || borderRadius != null || shadows != null) {
      result = DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: shadows,
        ),
        child: result,
      );
    }
    if (clipBehavior != null && borderRadius != null) {
      result = ClipRRect(
        borderRadius: borderRadius! as BorderRadius,
        child: result,
      );
    }
    if (opacity != null) {
      result = Opacity(opacity: opacity!, child: result);
    }
    if (alignment != null) {
      result = Align(alignment: alignment!, child: result);
    }
    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    return result;
  }
}
```

### Apply Order Matters

The `apply()` method builds widgets inside-out. The order determines the visual result:

```
margin (outermost)
  alignment
    opacity
      clip
        decoration (bg, radius, shadow)
          constraints
            padding
              textStyle
                child (innermost)
```

This matches CSS box model intuition: padding is inside the border/background, margin is outside everything.

### TwVariant: Sealed Class for Type Safety

```dart
sealed class TwVariant {
  const TwVariant();
  bool matches(BuildContext context);

  // V1 variants
  const factory TwVariant.dark() = _DarkVariant;
  const factory TwVariant.light() = _LightVariant;
}

class _DarkVariant extends TwVariant {
  const _DarkVariant();

  @override
  bool matches(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  bool operator ==(Object other) => other is _DarkVariant;

  @override
  int get hashCode => runtimeType.hashCode;
}

class _LightVariant extends TwVariant {
  const _LightVariant();

  @override
  bool matches(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  bool operator ==(Object other) => other is _LightVariant;

  @override
  int get hashCode => runtimeType.hashCode;
}
```

Using a sealed class instead of an enum because V2 will add responsive variants (`TwVariant.sm()`, `.md()`) and interaction variants (`TwVariant.hover()`), which need constructor parameters. Sealed classes scale; enums don't.

### Why Terminal `.apply()` Beats Builder `.make()`

VelocityX's `.make()` pattern has a fundamental flaw: the builder methods return a non-widget type (a builder object), so forgetting `.make()` at the end compiles fine but renders nothing. The error is silent.

```dart
// VelocityX -- compiles, renders nothing, no warning
"Hello".text.xl4.red500; // Oops, forgot .make()
```

TwStyle avoids this entirely:

1. `TwStyle` is NOT a Widget. It cannot be placed in a widget tree. The type system catches misuse at compile time.
2. `.apply(child: ...)` takes a `required Widget child` parameter, making it explicit that this is the rendering step.
3. The return type of `.apply()` is `Widget`, which is what the widget tree expects.

```dart
// tailwind_flutter -- compile error if you forget .apply()
cardStyle.resolve(context); // Returns TwStyle, not Widget -- type error in widget tree
```

---

## Data Flow Diagram

```
  Consumer Code
       |
       | uses either:
       |
  [A] Direct tokens       [B] Theme tokens          [C] Composable styles
  TwSpace.s4               context.tw.spacing.s4     TwStyle(padding: ...)
       |                        |                          |
       | (compile-time)         | (runtime)                | .resolve(context)
       |                        |                          |
       v                        v                          v
  double literal           ThemeData.extension<T>()    Resolved TwStyle
  (zero cost)              (InheritedWidget lookup)    (variant-free)
       |                        |                          |
       | used in:               | used in:                 | .apply(child:)
       |                        |                          |
  Widget constructors      Widget constructors         Widget tree
  OR extension methods     OR extension methods        (Padding, DecoratedBox, etc.)
       |                        |                          |
       v                        v                          v
                    Flutter Widget Tree
                         |
                    Element Tree
                         |
                    RenderObject Tree
                         |
                      Screen
```

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Extension Type for Everything
**What:** Wrapping every token type in an extension type.
**Why bad:** Extension types earn their keep only when they add meaningful convenience methods. `TwFontWeight implements FontWeight` adds nothing -- `FontWeight.w700` is already readable.
**Instead:** Use extension types only when the wrapper adds convenience getters (TwSpace -> EdgeInsets, TwRadius -> BorderRadius, TwFontSize -> paired lineHeight).

### Anti-Pattern 2: Single Monolithic ThemeExtension
**What:** One `TwThemeExtension` class with all 300+ token fields.
**Why bad:** `copyWith` with 300+ optional parameters is unusable. `lerp` with 300+ lerp calls is a performance concern during theme animation. IDE autocomplete becomes useless.
**Instead:** One ThemeExtension per token category (7 classes). TwThemeData composes them.

### Anti-Pattern 3: Extension Methods That Return Non-Widget Types
**What:** `.bg(color)` returning a builder or descriptor instead of a Widget.
**Why bad:** This is VelocityX's `.make()` footgun. If the return type is not Widget, forgetting a terminal call produces silent failures.
**Instead:** Every widget extension method returns `Widget`. Period. No builders, no descriptors. Style composition goes through `TwStyle`, which is explicitly NOT a Widget.

### Anti-Pattern 4: Context-Dependent Extensions
**What:** `.bgPrimary()` that internally calls `Theme.of(context)` inside an extension method.
**Why bad:** Extension methods on Widget don't have BuildContext access. You'd need to either accept context as a parameter (ugly: `.bgPrimary(context)`) or use a different mechanism entirely.
**Instead:** Tier 2 extensions take explicit values. Theme resolution happens at the call site: `.bg(context.tw.colors.primary)`. Tier 3's TwStyle handles context-dependent styling via `.resolve(context)`.

### Anti-Pattern 5: Mutable Style Objects
**What:** TwStyle with setters or mutation methods.
**Why bad:** Breaks const declarations, makes style sharing unsafe, prevents reliable merge semantics.
**Instead:** TwStyle is `@immutable`. `merge()` returns a new instance. `resolve()` returns a new instance. No mutation ever.

---

## Patterns to Follow

### Pattern 1: Const-First Design
**What:** Every token, every default ThemeExtension, and every variant-free TwStyle should be `const`.
**When:** Always. This is a package constraint.
**Example:**
```dart
// Tokens are const
static const s4 = TwSpace(16);

// ThemeExtensions have const defaults
const TwSpacingTheme({this.s0 = 0, this.s1 = 4, ...});

// Styles can be const if variant-free
const cardStyle = TwStyle(
  padding: EdgeInsets.all(16),
  backgroundColor: Color(0xFFFFFFFF),
);
```

### Pattern 2: Progressive Disclosure
**What:** Each tier is independently useful. Consumers adopt only what they need.
**When:** API design decisions.
**Example:** A consumer can use `TwSpace.s4` as a plain double in `EdgeInsets.all(TwSpace.s4)` without ever touching TwStyle or extensions. No imports beyond `tokens/spacing.dart` needed.

### Pattern 3: Composition Over Configuration
**What:** Multiple simple extension calls instead of one call with many parameters.
**When:** Tier 2 widget extensions.
**Example:**
```dart
// Good: composable, each call does one thing
widget.p(16).bg(Colors.blue).rounded(8)

// Bad: god-method with many optional params
widget.styled(padding: 16, bg: Colors.blue, radius: 8)
```

### Pattern 4: Single Responsibility Per File
**What:** Each file in `tokens/` exports exactly one token family. Each file in `theme/` has one clear responsibility.
**When:** Module organization.
**Why:** Enables parallel development (agents can work on separate files simultaneously) and tree-shaking (unused token files are not compiled in).

---

## Scalability Considerations

| Concern | V1 (small apps) | V2 (medium apps) | Future (large design systems) |
|---------|-----------------|-------------------|-------------------------------|
| Token count | 350+ static consts | Same + custom tokens via ThemeExtension | Token generation from Figma/design tools |
| Theme variants | light/dark | + responsive breakpoints | + interaction states, platform-specific |
| Style reuse | Inline TwStyle consts | Shared style files, merge patterns | Design system library of composable styles |
| Performance | Negligible overhead (const + extension types) | Same | Consider caching resolved TwStyle per context |
| Widget tree depth | 3-5 wrappers per chain | Same | TwStyle.apply() consolidates into fewer widgets |
| Dart analysis | Zero warnings | Same | Custom lint rules (tailwind_flutter_lint) |

---

## Suggested Build Order

Based on dependency analysis, this is the critical path:

### Wave 1: Tokens (No Dependencies -- Start Immediately)
All 7 token files are independent leaf nodes. They depend only on `dart:ui` and `package:flutter/painting.dart`.

**Build order within Wave 1 doesn't matter -- all can be parallel.** But if forced to sequence:
1. `spacing.dart` -- simplest extension type, validates the pattern
2. `colors.dart` -- largest file (~600 lines), longest to write
3. `typography.dart` -- multiple extension types and plain constants
4. `radius.dart`, `shadows.dart`, `opacity.dart`, `breakpoints.dart` -- small files

### Wave 2: Theme + Context Extensions (Depends on Wave 1)
These can be parallel with each other:
- `tw_theme_extension.dart` -- One ThemeExtension<T> per token category
- `tw_theme_data.dart` -- Composite facade
- `tw_theme.dart` -- Theme wrapper widget
- `context_extensions.dart` -- `context.tw` accessor

### Wave 3: Widget Extensions (Depends on Wave 1, Independent of Wave 2)
- `widget_extensions.dart` -- Extension on Widget
- `text_extensions.dart` -- Extension on Text
- `edge_insets_extensions.dart` -- Convenience builders

Note: Widget extensions do NOT depend on the theme system. They take raw values. So Wave 2 and Wave 3 can actually run in parallel.

### Wave 4: Style Composition (Depends on Wave 1 + Wave 2)
- `tw_variant.dart` -- Sealed class (needs BuildContext/Theme for resolution)
- `tw_style.dart` -- Immutable style object with merge/resolve/apply
- `tw_styled_widget.dart` -- Convenience wrapper

### Wave 5: Integration (Depends on All)
- Barrel export (`tailwind_flutter.dart`)
- Example app
- Tests (unit, widget, golden)
- Documentation, CI/CD

```
Timeline:
Wave 1 ──────→ Wave 2 ───→ Wave 4 ───→ Wave 5
              ↗ Wave 3 ──↗
```

---

## Module Boundary Rules

1. **`tokens/` files MUST NOT import from `theme/`, `extensions/`, or `styles/`.**
2. **`theme/` files MAY import from `tokens/` only.**
3. **`extensions/widget_extensions.dart` and `text_extensions.dart` MUST NOT import from `theme/` or `styles/`.** They take raw Flutter types as parameters.
4. **`extensions/context_extensions.dart` imports from `theme/` only** (it's the bridge between widget code and theme resolution).
5. **`styles/` MAY import from `tokens/` and `theme/`.** It resolves variants using Theme.of(context).
6. **The barrel export (`tailwind_flutter.dart`) is the only file that imports from all modules.**

Enforcing these boundaries prevents circular dependencies and ensures the wave execution strategy works.

---

## Sources

- [Dart Extension Types Official Documentation](https://dart.dev/language/extension-types) -- HIGH confidence
- [Flutter ThemeExtension Class API](https://api.flutter.dev/flutter/material/ThemeExtension-class.html) -- HIGH confidence
- [Very Good Ventures: Mastering Scalable Theming](https://www.verygood.ventures/blog/mastering-scalable-theming-for-custom-widgets) -- HIGH confidence
- [FreeCodeCamp: Theming and Customization in Flutter](https://www.freecodecamp.org/news/theming-and-customization-in-flutter-a-handbook-for-developers) -- MEDIUM confidence
- [Mix Package Documentation](https://www.fluttermix.com/documentation/overview/introduction) -- MEDIUM confidence
- [Mix GitHub Repository](https://github.com/btwld/mix) -- HIGH confidence
- [Dart 3.3 Blog Post](https://blog.dart.dev/dart-3-3-325bf2bf6c13) -- HIGH confidence
- [styled_widget GitHub](https://github.com/ReinBentdal/styled_widget) -- MEDIUM confidence
- [Niku Comparison to VelocityX](https://niku.saltyaom.com/velocity-x) -- MEDIUM confidence
- [Flutter Inside Flutter: Layout Algorithm](https://docs.flutter.dev/resources/inside-flutter) -- HIGH confidence
