/// Text-specific extension methods for Tailwind-style typography styling.
///
/// Provides chainable methods on [Text] to modify font weight, style, size,
/// color, and other [TextStyle] properties without manually constructing
/// a new [Text] widget.
///
/// **Usage order:** Text extensions must be called BEFORE [Widget] extensions
/// because they return [Text], not [Widget]. Once a widget extension wraps the
/// result, Text-specific methods are no longer available:
///
/// ```dart
/// // Correct: text extensions first, then widget extensions
/// Text('Hello')
///   .bold()
///   .fontSize(18)
///   .textColor(TwColors.blue.shade500)
///   .p(TwSpacing.s4)    // widget extension -- returns Widget
///   .bg(TwColors.gray.shade100);
///
/// // Wrong: widget extension first loses Text type
/// Text('Hello')
///   .p(TwSpacing.s4)    // returns Widget -- .bold() no longer available
///   .bold();            // compile error
/// ```
///
/// All methods preserve every [Text] constructor parameter (maxLines,
/// overflow, textAlign, softWrap, etc.) and merge styles non-destructively.
library;

import 'package:flutter/widgets.dart';

/// Tailwind-style text styling extensions on [Text].
///
/// Every method returns a new [Text] with the updated [TextStyle],
/// preserving all existing style properties and constructor parameters.
extension TwTextExtensions on Text {
  /// Sets [FontWeight.bold] (w700) on the text.
  ///
  /// ```dart
  /// Text('Hello').bold()
  /// ```
  Text bold() => _copyWith(
        style:
            (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
      );

  /// Sets [FontStyle.italic] on the text.
  ///
  /// ```dart
  /// Text('Hello').italic()
  /// ```
  Text italic() => _copyWith(
        style:
            (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
      );

  /// Sets the font size in logical pixels.
  ///
  /// ```dart
  /// Text('Hello').fontSize(18)
  /// ```
  Text fontSize(double size) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(fontSize: size),
      );

  /// Sets the text color.
  ///
  /// ```dart
  /// Text('Hello').textColor(Colors.red)
  /// ```
  Text textColor(Color color) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(color: color),
      );

  /// Sets the letter spacing in logical pixels.
  ///
  /// ```dart
  /// Text('Hello').letterSpacing(1.5)
  /// ```
  Text letterSpacing(double spacing) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(letterSpacing: spacing),
      );

  /// Sets the line height multiplier.
  ///
  /// This maps to [TextStyle.height], which is a multiplier applied to the
  /// font size to determine line height.
  ///
  /// ```dart
  /// Text('Hello').lineHeight(1.5) // 1.5x the font size
  /// ```
  Text lineHeight(double height) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(height: height),
      );

  /// Sets a specific [FontWeight].
  ///
  /// Use this when you need a weight other than bold (w700). For bold,
  /// prefer [bold] for readability.
  ///
  /// ```dart
  /// Text('Hello').fontWeight(FontWeight.w300) // light
  /// ```
  Text fontWeight(FontWeight weight) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(fontWeight: weight),
      );

  /// Merges a complete [TextStyle] into the existing style.
  ///
  /// Uses [TextStyle.merge], so non-null properties in [textStyle] override
  /// existing values while null properties are preserved from the original.
  ///
  /// This is useful for applying token-derived styles:
  /// ```dart
  /// Text('Hello').textStyle(TwFontSizes.lg.textStyle)
  /// ```
  Text textStyle(TextStyle textStyle) => _copyWith(
        style: (style ?? const TextStyle()).merge(textStyle),
      );

  /// Creates a new [Text] with an updated [TextStyle], preserving all
  /// constructor parameters.
  ///
  /// Only the [Text(String)] constructor is supported. The [data] field
  /// is accessed via `data!` which is safe because [Text.rich] is not
  /// targeted by this extension.
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
