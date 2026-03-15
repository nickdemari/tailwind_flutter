import 'package:flutter/widgets.dart';

/// A Tailwind CSS font size token pairing a font size with its default
/// line-height ratio.
///
/// Each [TwFontSize] carries both the pixel size and the paired line-height
/// that Tailwind associates with that size class (e.g. `text-lg` implies
/// `font-size: 1.125rem` and `line-height: 1.75rem`).
///
/// Use [textStyle] to create a [TextStyle] with both `fontSize` and `height`
/// set, matching Tailwind's "size implies line-height" convention:
///
/// ```dart
/// Text('Hello', style: TwFontSizes.lg.textStyle);
/// ```
extension type const TwFontSize._(({double size, double lineHeight}) _) {
  /// Creates a font size token with the given [size] in logical pixels and
  /// paired [lineHeight] as a ratio (e.g. 1.5 means 150% of font size).
  const TwFontSize(double size, double lineHeight)
      : this._((size: size, lineHeight: lineHeight));

  /// The font size in logical pixels.
  double get value => _.size;

  /// The paired line-height as a ratio of the font size.
  double get lineHeight => _.lineHeight;

  /// Creates a [TextStyle] with both `fontSize` and `height` set to match
  /// Tailwind's paired size + line-height convention.
  TextStyle get textStyle => TextStyle(fontSize: _.size, height: _.lineHeight);
}

/// Tailwind CSS font size scale.
///
/// 14 size classes from [xxs] (11px) to [xl9] (128px), each with a paired
/// line-height ratio derived from Tailwind v4's `calc()` values.
///
/// Sizes xl5 and above use a line-height of 1.0 (matching the font size).
abstract final class TwFontSizes {
  /// 11px, line-height 16/11 = ~1.4545
  static const xxs = TwFontSize(11, 1.4545);

  /// 12px, line-height 16/12 = ~1.3333
  static const xs = TwFontSize(12, 1.3333);

  /// 14px, line-height 20/14 = ~1.4286
  static const sm = TwFontSize(14, 1.4286);

  /// 16px, line-height 24/16 = 1.5
  static const base = TwFontSize(16, 1.5);

  /// 18px, line-height 28/18 = ~1.5556
  static const lg = TwFontSize(18, 1.5556);

  /// 20px, line-height 28/20 = 1.4
  static const xl = TwFontSize(20, 1.4);

  /// 24px, line-height 32/24 = ~1.3333
  static const xl2 = TwFontSize(24, 1.3333);

  /// 30px, line-height 36/30 = 1.2
  static const xl3 = TwFontSize(30, 1.2);

  /// 36px, line-height 40/36 = ~1.1111
  static const xl4 = TwFontSize(36, 1.1111);

  /// 48px, line-height 1.0
  static const xl5 = TwFontSize(48, 1);

  /// 60px, line-height 1.0
  static const xl6 = TwFontSize(60, 1);

  /// 72px, line-height 1.0
  static const xl7 = TwFontSize(72, 1);

  /// 96px, line-height 1.0
  static const xl8 = TwFontSize(96, 1);

  /// 128px, line-height 1.0
  static const xl9 = TwFontSize(128, 1);
}

/// Tailwind CSS font weight constants.
///
/// 9 weight classes mapped to Flutter's [FontWeight] values.
abstract final class TwFontWeights {
  /// FontWeight.w100
  static const thin = FontWeight.w100;

  /// FontWeight.w200
  static const extralight = FontWeight.w200;

  /// FontWeight.w300
  static const light = FontWeight.w300;

  /// FontWeight.w400
  static const normal = FontWeight.w400;

  /// FontWeight.w500
  static const medium = FontWeight.w500;

  /// FontWeight.w600
  static const semibold = FontWeight.w600;

  /// FontWeight.w700
  static const bold = FontWeight.w700;

  /// FontWeight.w800
  static const extrabold = FontWeight.w800;

  /// FontWeight.w900
  static const black = FontWeight.w900;
}

/// Tailwind CSS letter-spacing scale as em multipliers.
///
/// Values are stored as em multipliers (relative to font size). To compute
/// the absolute pixel value for Flutter's [TextStyle.letterSpacing], multiply
/// by the current font size:
///
/// ```dart
/// TextStyle(
///   fontSize: 16,
///   letterSpacing: TwLetterSpacing.tight * 16, // -0.4px
/// )
/// ```
abstract final class TwLetterSpacing {
  /// -0.05em -- tightest tracking
  static const double tighter = -0.05;

  /// -0.025em
  static const double tight = -0.025;

  /// 0em -- default tracking
  static const double normal = 0;

  /// 0.025em
  static const double wide = 0.025;

  /// 0.05em
  static const double wider = 0.05;

  /// 0.1em -- widest tracking
  static const double widest = 0.1;
}

/// Tailwind CSS line-height scale as ratios.
///
/// These are unitless ratios applied to the font size. In Flutter, set
/// [TextStyle.height] to one of these values:
///
/// ```dart
/// TextStyle(height: TwLineHeights.relaxed) // 1.625x font size
/// ```
abstract final class TwLineHeights {
  /// 1.0 -- no extra leading
  static const double none = 1;

  /// 1.25
  static const double tight = 1.25;

  /// 1.375
  static const double snug = 1.375;

  /// 1.5 -- default
  static const double normal = 1.5;

  /// 1.625
  static const double relaxed = 1.625;

  /// 2.0 -- most generous leading
  static const double loose = 2;
}
