import 'package:flutter/widgets.dart';

/// A Tailwind CSS spacing value that implements [double] for transparent use
/// in any Flutter API expecting a numeric value.
///
/// Provides convenience getters for common [EdgeInsets] configurations:
///
/// ```dart
/// // As a double (e.g., in SizedBox)
/// SizedBox(width: TwSpacing.s4) // 16.0
///
/// // As EdgeInsets (e.g., in Padding)
/// Padding(padding: TwSpacing.s4.all)  // EdgeInsets.all(16.0)
/// Padding(padding: TwSpacing.s4.x)    // EdgeInsets.symmetric(horizontal: 16.0)
/// ```
///
/// **Note:** The EdgeInsets getters (`.all`, `.x`, `.y`, `.top`, `.bottom`,
/// `.left`, `.right`) produce runtime values and are NOT const-evaluable.
/// The token VALUE itself is const, but convenience getters execute at runtime.
extension type const TwSpace._(double _) implements double {
  /// Creates a [TwSpace] with the given pixel [value].
  const TwSpace(double value) : this._(value);

  /// Returns [EdgeInsets] with this spacing on all sides.
  EdgeInsets get all => EdgeInsets.all(_);

  /// Returns [EdgeInsets] with this spacing on left and right (horizontal).
  EdgeInsets get x => EdgeInsets.symmetric(horizontal: _);

  /// Returns [EdgeInsets] with this spacing on top and bottom (vertical).
  EdgeInsets get y => EdgeInsets.symmetric(vertical: _);

  /// Returns [EdgeInsets] with this spacing on top only.
  EdgeInsets get top => EdgeInsets.only(top: _);

  /// Returns [EdgeInsets] with this spacing on bottom only.
  EdgeInsets get bottom => EdgeInsets.only(bottom: _);

  /// Returns [EdgeInsets] with this spacing on left only.
  EdgeInsets get left => EdgeInsets.only(left: _);

  /// Returns [EdgeInsets] with this spacing on right only.
  EdgeInsets get right => EdgeInsets.only(right: _);
}

/// The complete Tailwind CSS spacing scale.
///
/// Contains 35 named spacing values from the Tailwind CSS v3/v4 compatible
/// spacing scale, based on a 4px base unit. Each value is a [TwSpace]
/// extension type that implements [double], so it can be used anywhere a
/// [double] is expected.
///
/// The naming convention uses `s` prefix with the Tailwind scale name:
/// - `s0` through `s96` for integer values
/// - `s0_5`, `s1_5`, `s2_5`, `s3_5` for fractional values
/// - `sPx` for the 1px value
///
/// ```dart
/// // Direct as double
/// SizedBox(height: TwSpacing.s4)  // 16.0 pixels
///
/// // Via EdgeInsets getter
/// Padding(padding: TwSpacing.s2.all)  // EdgeInsets.all(8.0)
/// ```
///
/// **Scale note:** This implements the 35-value named spacing scale from
/// Tailwind CSS. Tailwind v4 introduced dynamic spacing (any multiple of
/// the base unit), but this package provides the standard named constants
/// for type-safe, autocomplete-friendly usage.
abstract final class TwSpacing {
  /// 0px -- zero spacing.
  static const s0 = TwSpace(0);

  /// 1px -- single pixel spacing.
  static const sPx = TwSpace(1);

  /// 2px (0.125rem) -- 0.5 unit.
  static const s0_5 = TwSpace(2);

  /// 4px (0.25rem) -- 1 unit.
  static const s1 = TwSpace(4);

  /// 6px (0.375rem) -- 1.5 units.
  static const s1_5 = TwSpace(6);

  /// 8px (0.5rem) -- 2 units.
  static const s2 = TwSpace(8);

  /// 10px (0.625rem) -- 2.5 units.
  static const s2_5 = TwSpace(10);

  /// 12px (0.75rem) -- 3 units.
  static const s3 = TwSpace(12);

  /// 14px (0.875rem) -- 3.5 units.
  static const s3_5 = TwSpace(14);

  /// 16px (1rem) -- 4 units.
  static const s4 = TwSpace(16);

  /// 20px (1.25rem) -- 5 units.
  static const s5 = TwSpace(20);

  /// 24px (1.5rem) -- 6 units.
  static const s6 = TwSpace(24);

  /// 28px (1.75rem) -- 7 units.
  static const s7 = TwSpace(28);

  /// 32px (2rem) -- 8 units.
  static const s8 = TwSpace(32);

  /// 36px (2.25rem) -- 9 units.
  static const s9 = TwSpace(36);

  /// 40px (2.5rem) -- 10 units.
  static const s10 = TwSpace(40);

  /// 44px (2.75rem) -- 11 units.
  static const s11 = TwSpace(44);

  /// 48px (3rem) -- 12 units.
  static const s12 = TwSpace(48);

  /// 56px (3.5rem) -- 14 units.
  static const s14 = TwSpace(56);

  /// 64px (4rem) -- 16 units.
  static const s16 = TwSpace(64);

  /// 80px (5rem) -- 20 units.
  static const s20 = TwSpace(80);

  /// 96px (6rem) -- 24 units.
  static const s24 = TwSpace(96);

  /// 112px (7rem) -- 28 units.
  static const s28 = TwSpace(112);

  /// 128px (8rem) -- 32 units.
  static const s32 = TwSpace(128);

  /// 144px (9rem) -- 36 units.
  static const s36 = TwSpace(144);

  /// 160px (10rem) -- 40 units.
  static const s40 = TwSpace(160);

  /// 176px (11rem) -- 44 units.
  static const s44 = TwSpace(176);

  /// 192px (12rem) -- 48 units.
  static const s48 = TwSpace(192);

  /// 208px (13rem) -- 52 units.
  static const s52 = TwSpace(208);

  /// 224px (14rem) -- 56 units.
  static const s56 = TwSpace(224);

  /// 240px (15rem) -- 60 units.
  static const s60 = TwSpace(240);

  /// 256px (16rem) -- 64 units.
  static const s64 = TwSpace(256);

  /// 288px (18rem) -- 72 units.
  static const s72 = TwSpace(288);

  /// 320px (20rem) -- 80 units.
  static const s80 = TwSpace(320);

  /// 384px (24rem) -- 96 units.
  static const s96 = TwSpace(384);
}
