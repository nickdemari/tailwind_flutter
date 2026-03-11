import 'package:flutter/widgets.dart';

/// A Tailwind CSS border radius token that can be used transparently as a
/// [double] value and also provides convenience [BorderRadius] getters.
///
/// Because [TwRadius] implements [double], it can be used anywhere a double
/// is expected (e.g. `Radius.circular(TwRadii.lg)`). The getter methods
/// [all], [top], [bottom], [left], and [right] produce [BorderRadius] values
/// for common corner configurations:
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: TwRadii.lg.all,  // all corners 8px
///   ),
/// )
/// ```
///
/// **Note:** The [double] value itself is const, but the [BorderRadius]
/// getters are computed at runtime (not const-evaluable).
extension type const TwRadius._(double _) implements double {
  /// Creates a radius token with the given [value] in logical pixels.
  const TwRadius(double value) : this._(value);

  /// [BorderRadius] with all four corners set to this radius.
  BorderRadius get all => BorderRadius.circular(_);

  /// [BorderRadius] with only the top-left and top-right corners set.
  BorderRadius get top => BorderRadius.only(
        topLeft: Radius.circular(_),
        topRight: Radius.circular(_),
      );

  /// [BorderRadius] with only the bottom-left and bottom-right corners set.
  BorderRadius get bottom => BorderRadius.only(
        bottomLeft: Radius.circular(_),
        bottomRight: Radius.circular(_),
      );

  /// [BorderRadius] with only the top-left and bottom-left corners set.
  BorderRadius get left => BorderRadius.only(
        topLeft: Radius.circular(_),
        bottomLeft: Radius.circular(_),
      );

  /// [BorderRadius] with only the top-right and bottom-right corners set.
  BorderRadius get right => BorderRadius.only(
        topRight: Radius.circular(_),
        bottomRight: Radius.circular(_),
      );
}

/// Tailwind CSS border radius scale.
///
/// 10 values from [none] (0px) to [full] (9999px, effectively circular).
/// Each value is a [TwRadius] that implements [double] for transparent usage.
abstract final class TwRadii {
  /// 0px -- no rounding
  static const none = TwRadius(0);

  /// 2px (0.125rem)
  static const xs = TwRadius(2);

  /// 4px (0.25rem)
  static const sm = TwRadius(4);

  /// 6px (0.375rem)
  static const md = TwRadius(6);

  /// 8px (0.5rem)
  static const lg = TwRadius(8);

  /// 12px (0.75rem)
  static const xl = TwRadius(12);

  /// 16px (1rem)
  static const xl2 = TwRadius(16);

  /// 24px (1.5rem)
  static const xl3 = TwRadius(24);

  /// 32px (2rem)
  static const xl4 = TwRadius(32);

  /// 9999px -- effectively a full circle / pill shape
  static const full = TwRadius(9999);
}
