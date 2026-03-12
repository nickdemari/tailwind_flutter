library;

/// Conditional style variants based on platform brightness.
///
/// `TwVariant` is a sealed class with exactly two cases: `TwVariant.dark` and
/// `TwVariant.light`. Used as keys in the `variants` map of `TwStyle` to
/// define brightness-conditional style overrides.
///
/// ```dart
/// final themed = TwStyle(
///   backgroundColor: TwColors.white,
///   variants: {
///     TwVariant.dark: TwStyle(backgroundColor: TwColors.zinc.shade900),
///   },
/// );
/// ```
///
/// The sealed class enables exhaustive `switch` expressions without a
/// `default` case, so the analyzer catches any unhandled variants at
/// compile time.

import 'dart:ui';

/// A condition that determines when a variant style applies.
///
/// Use [matches] to test whether a [Brightness] value satisfies the variant
/// condition. Both [TwVariant.dark] and [TwVariant.light] are `const`
/// singletons and work correctly as `Map` keys via `identical` equality.
sealed class TwVariant {
  const TwVariant._();

  /// A variant that matches [Brightness.dark].
  static const dark = TwDarkVariant._();

  /// A variant that matches [Brightness.light].
  static const light = TwLightVariant._();

  /// Returns `true` if [brightness] satisfies this variant condition.
  bool matches(Brightness brightness);
}

/// Variant that matches [Brightness.dark].
final class TwDarkVariant extends TwVariant {
  const TwDarkVariant._() : super._();

  @override
  bool matches(Brightness brightness) => brightness == Brightness.dark;
}

/// Variant that matches [Brightness.light].
final class TwLightVariant extends TwVariant {
  const TwLightVariant._() : super._();

  @override
  bool matches(Brightness brightness) => brightness == Brightness.light;
}
