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
///   .fontSize(TwFontSizes.base)
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
import 'package:tailwind_flutter/src/tokens/typography.dart';

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

  /// Sets the font size.
  ///
  /// Accepts a [num] (raw pixel value) or a [TwFontSize] token.
  /// When a [TwFontSize] is passed, the paired line-height is also applied
  /// automatically — matching Tailwind's convention where each size class
  /// implies a specific line-height.
  ///
  /// ```dart
  /// Text('Hello').fontSize(18)              // raw double — sets fontSize only
  /// Text('Hello').fontSize(TwFontSizes.lg)  // token — sets fontSize + lineHeight
  /// ```
  ///
  /// To override the auto-applied line-height, chain [lineHeight] after:
  /// ```dart
  /// Text('Hello').fontSize(TwFontSizes.lg).lineHeight(2.0)
  /// ```
  Text fontSize(dynamic size) {
    final base = style ?? const TextStyle();
    return switch (size) {
      final TwFontSize s => _copyWith(
          style: base.copyWith(fontSize: s.value, height: s.lineHeight),
        ),
      final num n => _copyWith(style: base.copyWith(fontSize: n.toDouble())),
      _ => throw ArgumentError(
          'fontSize expects num or TwFontSize, got ${size.runtimeType}',
        ),
    };
  }

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

  /// Adds an underline decoration to the text.
  ///
  /// ```dart
  /// Text('Hello').underline()
  /// ```
  Text underline() => _copyWith(
        style: (style ?? const TextStyle())
            .copyWith(decoration: TextDecoration.underline),
      );

  /// Adds a line-through (strikethrough) decoration to the text.
  ///
  /// ```dart
  /// Text('Original price').lineThrough()
  /// ```
  Text lineThrough() => _copyWith(
        style: (style ?? const TextStyle())
            .copyWith(decoration: TextDecoration.lineThrough),
      );

  /// Adds an overline decoration to the text.
  ///
  /// ```dart
  /// Text('Hello').overline()
  /// ```
  Text overline() => _copyWith(
        style: (style ?? const TextStyle())
            .copyWith(decoration: TextDecoration.overline),
      );

  /// Transforms all characters to uppercase.
  ///
  /// Modifies the text string, not the style.
  ///
  /// ```dart
  /// Text('hello').uppercase() // 'HELLO'
  /// ```
  Text uppercase() => _copyWithData(data!.toUpperCase());

  /// Transforms all characters to lowercase.
  ///
  /// Modifies the text string, not the style.
  ///
  /// ```dart
  /// Text('HELLO').lowercase() // 'hello'
  /// ```
  Text lowercase() => _copyWithData(data!.toLowerCase());

  /// Capitalizes the first letter of each word.
  ///
  /// Modifies the text string, not the style.
  ///
  /// ```dart
  /// Text('hello world').capitalize() // 'Hello World'
  /// ```
  Text capitalize() => _copyWithData(
        data!.isEmpty
            ? data!
            : data!.split(' ').map((w) {
                if (w.isEmpty) return w;
                return w[0].toUpperCase() + w.substring(1);
              }).join(' '),
      );

  /// Sets the font family.
  ///
  /// ```dart
  /// Text('Hello').fontFamily('Roboto')
  /// ```
  Text fontFamily(String family) => _copyWith(
        style: (style ?? const TextStyle()).copyWith(fontFamily: family),
      );

  /// Sets the text alignment.
  ///
  /// Unlike other text extensions, this modifies the [Text.textAlign]
  /// constructor parameter rather than the [TextStyle].
  ///
  /// Named [align] instead of `textAlign` to avoid shadowing the
  /// [Text.textAlign] property.
  ///
  /// ```dart
  /// Text('Hello').align(TextAlign.center)
  /// ```
  Text align(TextAlign alignment) => Text(
        data!,
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: alignment,
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

  /// Creates a new [Text] with replaced [data], preserving style and all
  /// constructor parameters.
  Text _copyWithData(String newData) => Text(
        newData,
        key: key,
        style: style,
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
