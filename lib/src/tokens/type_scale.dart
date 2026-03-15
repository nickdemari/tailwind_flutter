import 'package:tailwind_flutter/src/tokens/typography.dart';

/// Size variant for semantic type roles.
///
/// Each [TwFontRole] provides three size variants following Material Design's
/// small / medium / large convention.
enum TwTypeVariant {
  /// Small variant.
  sm,

  /// Medium variant.
  md,

  /// Large variant.
  lg,
}

/// A semantic font role grouping three size variants of [TwFontSize].
///
/// Mirrors `TwColorFamily`'s extension-type pattern -- zero-cost at runtime,
/// const-constructible, and record-backed.
///
/// ```dart
/// TwTypeScale.headline.md  // -> TwFontSize(30, 1.2)
/// TwTypeScale.headline.resolve(TwTypeVariant.lg)  // -> TwFontSize(36, ~1.1111)
/// ```
extension type const TwFontRole._(
    ({TwFontSize sm, TwFontSize md, TwFontSize lg}) _) {
  /// Creates a font role with three size variants.
  const TwFontRole({
    required TwFontSize sm,
    required TwFontSize md,
    required TwFontSize lg,
  })
      : this._((sm: sm, md: md, lg: lg,));

  /// The small variant.
  TwFontSize get sm => _.sm;

  /// The medium variant.
  TwFontSize get md => _.md;

  /// The large variant.
  TwFontSize get lg => _.lg;

  /// Returns the [TwFontSize] for the given [variant].
  TwFontSize resolve(TwTypeVariant variant) => switch (variant) {
        TwTypeVariant.sm => _.sm,
        TwTypeVariant.md => _.md,
        TwTypeVariant.lg => _.lg,
      };
}

/// Material Design type roles mapped to Tailwind CSS font size tokens.
///
/// Five semantic roles -- [display], [headline], [title], [body], [label] --
/// each with three size variants accessed via [TwFontRole.sm],
/// [TwFontRole.md], [TwFontRole.lg],
/// or resolved dynamically with [TwFontRole.resolve].
///
/// ```dart
/// Text('Welcome').headline(TwTypeVariant.lg).bold()
/// Text('Details').body(TwTypeVariant.md)
///
/// // Standalone usage:
/// final style = TwTypeScale.headline.md.textStyle;
/// ```
abstract final class TwTypeScale {
  /// Display role -- xl4 (36px) / xl5 (48px) / xl6 (60px).
  static const display = TwFontRole(
      sm: TwFontSizes.xl4, md: TwFontSizes.xl5, lg: TwFontSizes.xl6,);

  /// Headline role -- xl2 (24px) / xl3 (30px) / xl4 (36px).
  static const headline = TwFontRole(
      sm: TwFontSizes.xl2, md: TwFontSizes.xl3, lg: TwFontSizes.xl4,);

  /// Title role -- sm (14px) / base (16px) / xl (20px).
  static const title = TwFontRole(
      sm: TwFontSizes.sm, md: TwFontSizes.base, lg: TwFontSizes.xl,);

  /// Body role -- xs (12px) / sm (14px) / base (16px).
  static const body = TwFontRole(
      sm: TwFontSizes.xs, md: TwFontSizes.sm, lg: TwFontSizes.base,);

  /// Label role -- xxs (11px) / xs (12px) / sm (14px).
  static const label = TwFontRole(
      sm: TwFontSizes.xxs, md: TwFontSizes.xs, lg: TwFontSizes.sm,);
}
