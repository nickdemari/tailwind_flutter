/// Tailwind CSS v4 opacity scale as `static const double` values.
///
/// Provides 21 opacity values from fully transparent (`o0 = 0.0`) to fully
/// opaque (`o100 = 1.0`) in steps of 5, mirroring Tailwind's `opacity-*`
/// utilities.
///
/// These are plain doubles suitable for use with any Flutter API that accepts
/// an opacity value (e.g., `Opacity`, `Color.withValues(alpha: ...)`).
///
/// ```dart
/// Opacity(opacity: TwOpacity.o50, child: widget)
/// ```
abstract final class TwOpacity {
  /// Fully transparent.
  static const double o0 = 0;

  /// 5% opacity.
  static const double o5 = 0.05;

  /// 10% opacity.
  static const double o10 = 0.1;

  /// 15% opacity.
  static const double o15 = 0.15;

  /// 20% opacity.
  static const double o20 = 0.2;

  /// 25% opacity.
  static const double o25 = 0.25;

  /// 30% opacity.
  static const double o30 = 0.3;

  /// 35% opacity.
  static const double o35 = 0.35;

  /// 40% opacity.
  static const double o40 = 0.4;

  /// 45% opacity.
  static const double o45 = 0.45;

  /// 50% opacity.
  static const double o50 = 0.5;

  /// 55% opacity.
  static const double o55 = 0.55;

  /// 60% opacity.
  static const double o60 = 0.6;

  /// 65% opacity.
  static const double o65 = 0.65;

  /// 70% opacity.
  static const double o70 = 0.7;

  /// 75% opacity.
  static const double o75 = 0.75;

  /// 80% opacity.
  static const double o80 = 0.8;

  /// 85% opacity.
  static const double o85 = 0.85;

  /// 90% opacity.
  static const double o90 = 0.9;

  /// 95% opacity.
  static const double o95 = 0.95;

  /// Fully opaque.
  static const double o100 = 1;
}
