library;

/// Immutable composable style definition.
///
/// `TwStyle` holds up to 8 optional visual properties that map to the CSS box
/// model, plus an optional `variants` map for brightness-conditional overrides.
///
/// ```dart
/// // Define a reusable style (like a CSS class)
/// final card = TwStyle(
///   padding: TwSpacing.s4.all,
///   backgroundColor: TwColors.white,
///   borderRadius: TwRadii.lg.all,
///   shadows: TwShadows.md,
/// );
///
/// // Compose styles with right-side-wins merge
/// final active = card.merge(TwStyle(
///   backgroundColor: TwColors.blue.shade50,
///   shadows: TwShadows.lg,
/// ));
/// ```

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:tailwind_flutter/src/styles/tw_variant.dart';

/// An immutable set of visual properties for composable styling.
///
/// [TwStyle] is the "CSS class" equivalent for Flutter. Define reusable styles,
/// merge them with [merge] (right-side-wins semantics), create variations with
/// [copyWith], and attach brightness-conditional overrides via [variants].
///
/// All properties are optional and nullable. Only non-null properties take
/// effect when the style is applied to a widget.
///
/// ## Properties
///
/// | Property | Flutter Type | CSS Equivalent |
/// |----------|-------------|----------------|
/// | [padding] | [EdgeInsets] | `padding` |
/// | [margin] | [EdgeInsets] | `margin` |
/// | [backgroundColor] | [Color] | `background-color` |
/// | [borderRadius] | [BorderRadius] | `border-radius` |
/// | [shadows] | `List<BoxShadow>` | `box-shadow` |
/// | [opacity] | [double] | `opacity` |
/// | [constraints] | [BoxConstraints] | `width`/`height`/`max-*`/`min-*` |
/// | [textStyle] | [TextStyle] | `font-*`/`text-*` |
///
/// ## Merge Semantics
///
/// [merge] uses right-side-wins: the `other` style's non-null properties
/// override `this` style's values. Variants are **not** carried over --
/// merge always produces a flat style.
///
/// ```dart
/// final merged = baseStyle.merge(overrideStyle);
/// ```
@immutable
class TwStyle {
  /// Creates a style with optional visual properties.
  ///
  /// All parameters default to `null`, meaning the property is unset and will
  /// be skipped during widget tree construction.
  const TwStyle({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
    this.opacity,
    this.constraints,
    this.textStyle,
    this.variants,
  });

  /// Inner spacing between content and decoration.
  final EdgeInsets? padding;

  /// Outer spacing around the decorated box.
  final EdgeInsets? margin;

  /// Fill color of the decoration.
  final Color? backgroundColor;

  /// Corner rounding of the decoration.
  final BorderRadius? borderRadius;

  /// Box shadows applied to the decoration.
  ///
  /// Shadows are replaced (not appended) during [merge], consistent with
  /// the behavior of all other properties.
  final List<BoxShadow>? shadows;

  /// Opacity applied to the entire styled subtree.
  ///
  /// Must be between 0.0 (fully transparent) and 1.0 (fully opaque).
  final double? opacity;

  /// Size constraints applied to the styled subtree.
  final BoxConstraints? constraints;

  /// Text style applied via `DefaultTextStyle.merge` to the subtree.
  final TextStyle? textStyle;

  /// Brightness-conditional style overrides.
  ///
  /// Keys are [TwVariant] conditions (e.g., [TwVariant.dark]), values are
  /// [TwStyle] instances that override the base style when the condition
  /// matches the current platform brightness.
  ///
  /// Use `.resolve(context)` to evaluate variants before `.apply()`.
  final Map<TwVariant, TwStyle>? variants;

  /// Creates a copy with the specified properties replaced.
  ///
  /// Properties not provided retain their current values. Note that the
  /// standard `??` pattern means you cannot explicitly set a property to
  /// `null` via [copyWith] -- construct a new [TwStyle] without it instead.
  ///
  /// ```dart
  /// final updated = style.copyWith(opacity: 0.8);
  /// ```
  TwStyle copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    double? opacity,
    BoxConstraints? constraints,
    TextStyle? textStyle,
    Map<TwVariant, TwStyle>? variants,
  }) {
    return TwStyle(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      opacity: opacity ?? this.opacity,
      constraints: constraints ?? this.constraints,
      textStyle: textStyle ?? this.textStyle,
      variants: variants ?? this.variants,
    );
  }

  /// Merges [other] over `this` with right-side-wins semantics.
  ///
  /// Non-null properties in [other] override the corresponding properties in
  /// `this`. Null properties in [other] leave the original values intact.
  ///
  /// Variants are **not** carried over from either side -- merge always
  /// produces a flat style. This is consistent with the resolve-then-apply
  /// pattern where variant resolution happens before merging.
  ///
  /// ```dart
  /// final card = TwStyle(padding: TwSpacing.s4.all, opacity: 1.0);
  /// final active = card.merge(TwStyle(opacity: 0.8));
  /// // active.padding == TwSpacing.s4.all (preserved)
  /// // active.opacity == 0.8 (overridden)
  /// ```
  TwStyle merge(TwStyle other) {
    return TwStyle(
      padding: other.padding ?? padding,
      margin: other.margin ?? margin,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      shadows: other.shadows ?? shadows,
      opacity: other.opacity ?? opacity,
      constraints: other.constraints ?? constraints,
      textStyle: other.textStyle ?? textStyle,
      // Variants are NOT merged -- merge produces a flat style.
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwStyle &&
          padding == other.padding &&
          margin == other.margin &&
          backgroundColor == other.backgroundColor &&
          borderRadius == other.borderRadius &&
          listEquals(shadows, other.shadows) &&
          opacity == other.opacity &&
          constraints == other.constraints &&
          textStyle == other.textStyle &&
          mapEquals(variants, other.variants);

  @override
  int get hashCode => Object.hash(
        padding,
        margin,
        backgroundColor,
        borderRadius,
        shadows != null ? Object.hashAll(shadows!) : null,
        opacity,
        constraints,
        textStyle,
        variants != null ? Object.hashAll(variants!.entries) : null,
      );
}
