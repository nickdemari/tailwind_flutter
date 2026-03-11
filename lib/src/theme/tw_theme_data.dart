import 'package:flutter/material.dart';

import 'package:tailwind_flutter/src/theme/tw_theme_extension.dart';

/// Aggregates all 7 Tailwind CSS [ThemeExtension] instances and provides
/// convenient factory constructors for light and dark presets.
///
/// Use [TwThemeData.light] or [TwThemeData.dark] for zero-config setup, or
/// supply per-category overrides:
///
/// ```dart
/// TwTheme(
///   data: TwThemeData.light(colors: myBrandColors),
///   child: MyApp(),
/// )
/// ```
///
/// Access resolved data in widgets via [TwThemeContext.tw]:
///
/// ```dart
/// final primary = context.tw.colors.blue.shade500;
/// ```
class TwThemeData {
  /// Creates a [TwThemeData] with explicit values for all fields.
  const TwThemeData({
    required this.brightness,
    required this.colors,
    required this.spacing,
    required this.typography,
    required this.radius,
    required this.shadows,
    required this.opacity,
    required this.breakpoints,
  });

  /// Creates a light theme using all default tokens.
  ///
  /// Any parameter can be overridden to customize a specific token category
  /// while keeping defaults for the rest.
  factory TwThemeData.light({
    TwColorTheme? colors,
    TwSpacingTheme? spacing,
    TwTypographyTheme? typography,
    TwRadiusTheme? radius,
    TwShadowTheme? shadows,
    TwOpacityTheme? opacity,
    TwBreakpointTheme? breakpoints,
  }) {
    return TwThemeData(
      brightness: Brightness.light,
      colors: colors ?? TwColorTheme.defaults,
      spacing: spacing ?? TwSpacingTheme.defaults,
      typography: typography ?? TwTypographyTheme.defaults,
      radius: radius ?? TwRadiusTheme.defaults,
      shadows: shadows ?? TwShadowTheme.defaults,
      opacity: opacity ?? TwOpacityTheme.defaults,
      breakpoints: breakpoints ?? TwBreakpointTheme.defaults,
    );
  }

  /// Creates a dark theme using all default tokens.
  ///
  /// Currently uses the same token values as `light` (Tailwind tokens are
  /// brightness-agnostic). The [brightness] field is set to [Brightness.dark]
  /// so downstream widgets can query it.
  factory TwThemeData.dark({
    TwColorTheme? colors,
    TwSpacingTheme? spacing,
    TwTypographyTheme? typography,
    TwRadiusTheme? radius,
    TwShadowTheme? shadows,
    TwOpacityTheme? opacity,
    TwBreakpointTheme? breakpoints,
  }) {
    return TwThemeData(
      brightness: Brightness.dark,
      colors: colors ?? TwColorTheme.defaults,
      spacing: spacing ?? TwSpacingTheme.defaults,
      typography: typography ?? TwTypographyTheme.defaults,
      radius: radius ?? TwRadiusTheme.defaults,
      shadows: shadows ?? TwShadowTheme.defaults,
      opacity: opacity ?? TwOpacityTheme.defaults,
      breakpoints: breakpoints ?? TwBreakpointTheme.defaults,
    );
  }

  /// The brightness mode for this theme (light or dark).
  final Brightness brightness;

  /// Tailwind color palette.
  final TwColorTheme colors;

  /// Tailwind spacing scale.
  final TwSpacingTheme spacing;

  /// Tailwind typography tokens (font sizes, weights, letter spacing, line
  /// heights).
  final TwTypographyTheme typography;

  /// Tailwind border radius scale.
  final TwRadiusTheme radius;

  /// Tailwind box shadow presets.
  final TwShadowTheme shadows;

  /// Tailwind opacity scale.
  final TwOpacityTheme opacity;

  /// Tailwind responsive breakpoints.
  final TwBreakpointTheme breakpoints;

  /// Returns all 7 [ThemeExtension] instances for injection into
  /// [ThemeData.extensions].
  Iterable<ThemeExtension<dynamic>> get extensions => [
        colors,
        spacing,
        typography,
        radius,
        shadows,
        opacity,
        breakpoints,
      ];

  /// Creates a copy with the given fields replaced.
  TwThemeData copyWith({
    Brightness? brightness,
    TwColorTheme? colors,
    TwSpacingTheme? spacing,
    TwTypographyTheme? typography,
    TwRadiusTheme? radius,
    TwShadowTheme? shadows,
    TwOpacityTheme? opacity,
    TwBreakpointTheme? breakpoints,
  }) {
    return TwThemeData(
      brightness: brightness ?? this.brightness,
      colors: colors ?? this.colors,
      spacing: spacing ?? this.spacing,
      typography: typography ?? this.typography,
      radius: radius ?? this.radius,
      shadows: shadows ?? this.shadows,
      opacity: opacity ?? this.opacity,
      breakpoints: breakpoints ?? this.breakpoints,
    );
  }
}

/// Provides [tw] and [twMaybe] accessors on [BuildContext] for convenient
/// access to the nearest [TwThemeData].
///
/// ```dart
/// // Throws if no TwTheme ancestor
/// final colors = context.tw.colors;
///
/// // Returns null if no TwTheme ancestor
/// final colors = context.twMaybe?.colors;
/// ```
extension TwThemeContext on BuildContext {
  /// Resolves the nearest [TwThemeData] from the widget tree.
  ///
  /// Throws a [FlutterError] with a helpful message if no `TwTheme` ancestor
  /// is found (i.e. no [TwColorTheme] extension on the current [ThemeData]).
  TwThemeData get tw {
    final theme = Theme.of(this);
    final colors = theme.extension<TwColorTheme>();
    if (colors == null) {
      throw FlutterError(
        'No TwTheme found in the widget tree.\n'
        'Wrap your app (or the relevant subtree) in a TwTheme widget:\n\n'
        '  TwTheme(\n'
        '    data: TwThemeData.light(),\n'
        '    child: MyApp(),\n'
        '  )\n',
      );
    }
    return TwThemeData(
      brightness: theme.brightness,
      colors: colors,
      spacing: theme.extension<TwSpacingTheme>() ?? TwSpacingTheme.defaults,
      typography:
          theme.extension<TwTypographyTheme>() ?? TwTypographyTheme.defaults,
      radius: theme.extension<TwRadiusTheme>() ?? TwRadiusTheme.defaults,
      shadows: theme.extension<TwShadowTheme>() ?? TwShadowTheme.defaults,
      opacity: theme.extension<TwOpacityTheme>() ?? TwOpacityTheme.defaults,
      breakpoints:
          theme.extension<TwBreakpointTheme>() ?? TwBreakpointTheme.defaults,
    );
  }

  /// Resolves the nearest [TwThemeData], or returns `null` if no `TwTheme`
  /// ancestor exists.
  TwThemeData? get twMaybe {
    final theme = Theme.of(this);
    final colors = theme.extension<TwColorTheme>();
    if (colors == null) return null;
    return TwThemeData(
      brightness: theme.brightness,
      colors: colors,
      spacing: theme.extension<TwSpacingTheme>() ?? TwSpacingTheme.defaults,
      typography:
          theme.extension<TwTypographyTheme>() ?? TwTypographyTheme.defaults,
      radius: theme.extension<TwRadiusTheme>() ?? TwRadiusTheme.defaults,
      shadows: theme.extension<TwShadowTheme>() ?? TwShadowTheme.defaults,
      opacity: theme.extension<TwOpacityTheme>() ?? TwOpacityTheme.defaults,
      breakpoints:
          theme.extension<TwBreakpointTheme>() ?? TwBreakpointTheme.defaults,
    );
  }
}
