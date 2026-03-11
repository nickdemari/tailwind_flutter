import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:tailwind_flutter/src/tokens/breakpoints.dart';
import 'package:tailwind_flutter/src/tokens/colors.dart';
import 'package:tailwind_flutter/src/tokens/opacity.dart';
import 'package:tailwind_flutter/src/tokens/radius.dart';
import 'package:tailwind_flutter/src/tokens/shadows.dart';
import 'package:tailwind_flutter/src/tokens/spacing.dart';
import 'package:tailwind_flutter/src/tokens/typography.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Lerps each shade of two [TwColorFamily] instances by [t].
///
/// Since [TwColorFamily] is an extension type, this creates a new instance
/// with each of the 11 shades interpolated via [Color.lerp].
TwColorFamily _lerpColorFamily(TwColorFamily a, TwColorFamily b, double t) {
  return TwColorFamily(
    shade50: Color.lerp(a.shade50, b.shade50, t)!,
    shade100: Color.lerp(a.shade100, b.shade100, t)!,
    shade200: Color.lerp(a.shade200, b.shade200, t)!,
    shade300: Color.lerp(a.shade300, b.shade300, t)!,
    shade400: Color.lerp(a.shade400, b.shade400, t)!,
    shade500: Color.lerp(a.shade500, b.shade500, t)!,
    shade600: Color.lerp(a.shade600, b.shade600, t)!,
    shade700: Color.lerp(a.shade700, b.shade700, t)!,
    shade800: Color.lerp(a.shade800, b.shade800, t)!,
    shade900: Color.lerp(a.shade900, b.shade900, t)!,
    shade950: Color.lerp(a.shade950, b.shade950, t)!,
  );
}

// ---------------------------------------------------------------------------
// 1. TwColorTheme
// ---------------------------------------------------------------------------

/// Theme extension providing the full Tailwind CSS color palette.
///
/// Contains 22 color families (each with 11 shades) plus 3 semantic colors
/// (black, white, transparent). All values default to [TwColors] constants.
///
/// ```dart
/// final colors = Theme.of(context).extension<TwColorTheme>()!;
/// final primary = colors.blue.shade500;
/// ```
class TwColorTheme extends ThemeExtension<TwColorTheme> {
  /// Creates a [TwColorTheme] with all color families and semantic colors.
  const TwColorTheme({
    required this.slate,
    required this.gray,
    required this.zinc,
    required this.neutral,
    required this.stone,
    required this.red,
    required this.orange,
    required this.amber,
    required this.yellow,
    required this.lime,
    required this.green,
    required this.emerald,
    required this.teal,
    required this.cyan,
    required this.sky,
    required this.blue,
    required this.indigo,
    required this.violet,
    required this.purple,
    required this.fuchsia,
    required this.pink,
    required this.rose,
    required this.black,
    required this.white,
    required this.transparent,
  });

  /// Default theme using all [TwColors] constants.
  static const defaults = TwColorTheme(
    slate: TwColors.slate,
    gray: TwColors.gray,
    zinc: TwColors.zinc,
    neutral: TwColors.neutral,
    stone: TwColors.stone,
    red: TwColors.red,
    orange: TwColors.orange,
    amber: TwColors.amber,
    yellow: TwColors.yellow,
    lime: TwColors.lime,
    green: TwColors.green,
    emerald: TwColors.emerald,
    teal: TwColors.teal,
    cyan: TwColors.cyan,
    sky: TwColors.sky,
    blue: TwColors.blue,
    indigo: TwColors.indigo,
    violet: TwColors.violet,
    purple: TwColors.purple,
    fuchsia: TwColors.fuchsia,
    pink: TwColors.pink,
    rose: TwColors.rose,
    black: TwColors.black,
    white: TwColors.white,
    transparent: TwColors.transparent,
  );

  // -- Gray scale families --

  /// Slate color family.
  final TwColorFamily slate;

  /// Gray color family.
  final TwColorFamily gray;

  /// Zinc color family.
  final TwColorFamily zinc;

  /// Neutral color family.
  final TwColorFamily neutral;

  /// Stone color family.
  final TwColorFamily stone;

  // -- Warm families --

  /// Red color family.
  final TwColorFamily red;

  /// Orange color family.
  final TwColorFamily orange;

  /// Amber color family.
  final TwColorFamily amber;

  /// Yellow color family.
  final TwColorFamily yellow;

  /// Lime color family.
  final TwColorFamily lime;

  // -- Cool families --

  /// Green color family.
  final TwColorFamily green;

  /// Emerald color family.
  final TwColorFamily emerald;

  /// Teal color family.
  final TwColorFamily teal;

  /// Cyan color family.
  final TwColorFamily cyan;

  /// Sky color family.
  final TwColorFamily sky;

  /// Blue color family.
  final TwColorFamily blue;

  /// Indigo color family.
  final TwColorFamily indigo;

  // -- Purple/pink families --

  /// Violet color family.
  final TwColorFamily violet;

  /// Purple color family.
  final TwColorFamily purple;

  /// Fuchsia color family.
  final TwColorFamily fuchsia;

  /// Pink color family.
  final TwColorFamily pink;

  /// Rose color family.
  final TwColorFamily rose;

  // -- Semantic colors --

  /// Pure black.
  final Color black;

  /// Pure white.
  final Color white;

  /// Fully transparent.
  final Color transparent;

  @override
  TwColorTheme copyWith({
    TwColorFamily? slate,
    TwColorFamily? gray,
    TwColorFamily? zinc,
    TwColorFamily? neutral,
    TwColorFamily? stone,
    TwColorFamily? red,
    TwColorFamily? orange,
    TwColorFamily? amber,
    TwColorFamily? yellow,
    TwColorFamily? lime,
    TwColorFamily? green,
    TwColorFamily? emerald,
    TwColorFamily? teal,
    TwColorFamily? cyan,
    TwColorFamily? sky,
    TwColorFamily? blue,
    TwColorFamily? indigo,
    TwColorFamily? violet,
    TwColorFamily? purple,
    TwColorFamily? fuchsia,
    TwColorFamily? pink,
    TwColorFamily? rose,
    Color? black,
    Color? white,
    Color? transparent,
  }) {
    return TwColorTheme(
      slate: slate ?? this.slate,
      gray: gray ?? this.gray,
      zinc: zinc ?? this.zinc,
      neutral: neutral ?? this.neutral,
      stone: stone ?? this.stone,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      amber: amber ?? this.amber,
      yellow: yellow ?? this.yellow,
      lime: lime ?? this.lime,
      green: green ?? this.green,
      emerald: emerald ?? this.emerald,
      teal: teal ?? this.teal,
      cyan: cyan ?? this.cyan,
      sky: sky ?? this.sky,
      blue: blue ?? this.blue,
      indigo: indigo ?? this.indigo,
      violet: violet ?? this.violet,
      purple: purple ?? this.purple,
      fuchsia: fuchsia ?? this.fuchsia,
      pink: pink ?? this.pink,
      rose: rose ?? this.rose,
      black: black ?? this.black,
      white: white ?? this.white,
      transparent: transparent ?? this.transparent,
    );
  }

  @override
  TwColorTheme lerp(covariant ThemeExtension<TwColorTheme>? other, double t) {
    if (other is! TwColorTheme) return this;
    return TwColorTheme(
      slate: _lerpColorFamily(slate, other.slate, t),
      gray: _lerpColorFamily(gray, other.gray, t),
      zinc: _lerpColorFamily(zinc, other.zinc, t),
      neutral: _lerpColorFamily(neutral, other.neutral, t),
      stone: _lerpColorFamily(stone, other.stone, t),
      red: _lerpColorFamily(red, other.red, t),
      orange: _lerpColorFamily(orange, other.orange, t),
      amber: _lerpColorFamily(amber, other.amber, t),
      yellow: _lerpColorFamily(yellow, other.yellow, t),
      lime: _lerpColorFamily(lime, other.lime, t),
      green: _lerpColorFamily(green, other.green, t),
      emerald: _lerpColorFamily(emerald, other.emerald, t),
      teal: _lerpColorFamily(teal, other.teal, t),
      cyan: _lerpColorFamily(cyan, other.cyan, t),
      sky: _lerpColorFamily(sky, other.sky, t),
      blue: _lerpColorFamily(blue, other.blue, t),
      indigo: _lerpColorFamily(indigo, other.indigo, t),
      violet: _lerpColorFamily(violet, other.violet, t),
      purple: _lerpColorFamily(purple, other.purple, t),
      fuchsia: _lerpColorFamily(fuchsia, other.fuchsia, t),
      pink: _lerpColorFamily(pink, other.pink, t),
      rose: _lerpColorFamily(rose, other.rose, t),
      black: Color.lerp(black, other.black, t)!,
      white: Color.lerp(white, other.white, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// 2. TwSpacingTheme
// ---------------------------------------------------------------------------

/// Theme extension providing the Tailwind CSS spacing scale.
///
/// Contains all 35 named spacing values. Each defaults to [TwSpacing]
/// constants.
class TwSpacingTheme extends ThemeExtension<TwSpacingTheme> {
  /// Creates a [TwSpacingTheme] with all 35 spacing values.
  const TwSpacingTheme({
    required this.s0,
    required this.sPx,
    required this.s0_5,
    required this.s1,
    required this.s1_5,
    required this.s2,
    required this.s2_5,
    required this.s3,
    required this.s3_5,
    required this.s4,
    required this.s5,
    required this.s6,
    required this.s7,
    required this.s8,
    required this.s9,
    required this.s10,
    required this.s11,
    required this.s12,
    required this.s14,
    required this.s16,
    required this.s20,
    required this.s24,
    required this.s28,
    required this.s32,
    required this.s36,
    required this.s40,
    required this.s44,
    required this.s48,
    required this.s52,
    required this.s56,
    required this.s60,
    required this.s64,
    required this.s72,
    required this.s80,
    required this.s96,
  });

  /// Default theme using all [TwSpacing] constants.
  static const defaults = TwSpacingTheme(
    s0: TwSpacing.s0,
    sPx: TwSpacing.sPx,
    s0_5: TwSpacing.s0_5,
    s1: TwSpacing.s1,
    s1_5: TwSpacing.s1_5,
    s2: TwSpacing.s2,
    s2_5: TwSpacing.s2_5,
    s3: TwSpacing.s3,
    s3_5: TwSpacing.s3_5,
    s4: TwSpacing.s4,
    s5: TwSpacing.s5,
    s6: TwSpacing.s6,
    s7: TwSpacing.s7,
    s8: TwSpacing.s8,
    s9: TwSpacing.s9,
    s10: TwSpacing.s10,
    s11: TwSpacing.s11,
    s12: TwSpacing.s12,
    s14: TwSpacing.s14,
    s16: TwSpacing.s16,
    s20: TwSpacing.s20,
    s24: TwSpacing.s24,
    s28: TwSpacing.s28,
    s32: TwSpacing.s32,
    s36: TwSpacing.s36,
    s40: TwSpacing.s40,
    s44: TwSpacing.s44,
    s48: TwSpacing.s48,
    s52: TwSpacing.s52,
    s56: TwSpacing.s56,
    s60: TwSpacing.s60,
    s64: TwSpacing.s64,
    s72: TwSpacing.s72,
    s80: TwSpacing.s80,
    s96: TwSpacing.s96,
  );

  /// 0px spacing.
  final TwSpace s0;

  /// 1px spacing.
  final TwSpace sPx;

  /// 2px spacing.
  final TwSpace s0_5;

  /// 4px spacing.
  final TwSpace s1;

  /// 6px spacing.
  final TwSpace s1_5;

  /// 8px spacing.
  final TwSpace s2;

  /// 10px spacing.
  final TwSpace s2_5;

  /// 12px spacing.
  final TwSpace s3;

  /// 14px spacing.
  final TwSpace s3_5;

  /// 16px spacing.
  final TwSpace s4;

  /// 20px spacing.
  final TwSpace s5;

  /// 24px spacing.
  final TwSpace s6;

  /// 28px spacing.
  final TwSpace s7;

  /// 32px spacing.
  final TwSpace s8;

  /// 36px spacing.
  final TwSpace s9;

  /// 40px spacing.
  final TwSpace s10;

  /// 44px spacing.
  final TwSpace s11;

  /// 48px spacing.
  final TwSpace s12;

  /// 56px spacing.
  final TwSpace s14;

  /// 64px spacing.
  final TwSpace s16;

  /// 80px spacing.
  final TwSpace s20;

  /// 96px spacing.
  final TwSpace s24;

  /// 112px spacing.
  final TwSpace s28;

  /// 128px spacing.
  final TwSpace s32;

  /// 144px spacing.
  final TwSpace s36;

  /// 160px spacing.
  final TwSpace s40;

  /// 176px spacing.
  final TwSpace s44;

  /// 192px spacing.
  final TwSpace s48;

  /// 208px spacing.
  final TwSpace s52;

  /// 224px spacing.
  final TwSpace s56;

  /// 240px spacing.
  final TwSpace s60;

  /// 256px spacing.
  final TwSpace s64;

  /// 288px spacing.
  final TwSpace s72;

  /// 320px spacing.
  final TwSpace s80;

  /// 384px spacing.
  final TwSpace s96;

  @override
  TwSpacingTheme copyWith({
    TwSpace? s0,
    TwSpace? sPx,
    TwSpace? s0_5,
    TwSpace? s1,
    TwSpace? s1_5,
    TwSpace? s2,
    TwSpace? s2_5,
    TwSpace? s3,
    TwSpace? s3_5,
    TwSpace? s4,
    TwSpace? s5,
    TwSpace? s6,
    TwSpace? s7,
    TwSpace? s8,
    TwSpace? s9,
    TwSpace? s10,
    TwSpace? s11,
    TwSpace? s12,
    TwSpace? s14,
    TwSpace? s16,
    TwSpace? s20,
    TwSpace? s24,
    TwSpace? s28,
    TwSpace? s32,
    TwSpace? s36,
    TwSpace? s40,
    TwSpace? s44,
    TwSpace? s48,
    TwSpace? s52,
    TwSpace? s56,
    TwSpace? s60,
    TwSpace? s64,
    TwSpace? s72,
    TwSpace? s80,
    TwSpace? s96,
  }) {
    return TwSpacingTheme(
      s0: s0 ?? this.s0,
      sPx: sPx ?? this.sPx,
      s0_5: s0_5 ?? this.s0_5,
      s1: s1 ?? this.s1,
      s1_5: s1_5 ?? this.s1_5,
      s2: s2 ?? this.s2,
      s2_5: s2_5 ?? this.s2_5,
      s3: s3 ?? this.s3,
      s3_5: s3_5 ?? this.s3_5,
      s4: s4 ?? this.s4,
      s5: s5 ?? this.s5,
      s6: s6 ?? this.s6,
      s7: s7 ?? this.s7,
      s8: s8 ?? this.s8,
      s9: s9 ?? this.s9,
      s10: s10 ?? this.s10,
      s11: s11 ?? this.s11,
      s12: s12 ?? this.s12,
      s14: s14 ?? this.s14,
      s16: s16 ?? this.s16,
      s20: s20 ?? this.s20,
      s24: s24 ?? this.s24,
      s28: s28 ?? this.s28,
      s32: s32 ?? this.s32,
      s36: s36 ?? this.s36,
      s40: s40 ?? this.s40,
      s44: s44 ?? this.s44,
      s48: s48 ?? this.s48,
      s52: s52 ?? this.s52,
      s56: s56 ?? this.s56,
      s60: s60 ?? this.s60,
      s64: s64 ?? this.s64,
      s72: s72 ?? this.s72,
      s80: s80 ?? this.s80,
      s96: s96 ?? this.s96,
    );
  }

  @override
  TwSpacingTheme lerp(
    covariant ThemeExtension<TwSpacingTheme>? other,
    double t,
  ) {
    if (other is! TwSpacingTheme) return this;
    return TwSpacingTheme(
      s0: TwSpace(lerpDouble(s0, other.s0, t)!),
      sPx: TwSpace(lerpDouble(sPx, other.sPx, t)!),
      s0_5: TwSpace(lerpDouble(s0_5, other.s0_5, t)!),
      s1: TwSpace(lerpDouble(s1, other.s1, t)!),
      s1_5: TwSpace(lerpDouble(s1_5, other.s1_5, t)!),
      s2: TwSpace(lerpDouble(s2, other.s2, t)!),
      s2_5: TwSpace(lerpDouble(s2_5, other.s2_5, t)!),
      s3: TwSpace(lerpDouble(s3, other.s3, t)!),
      s3_5: TwSpace(lerpDouble(s3_5, other.s3_5, t)!),
      s4: TwSpace(lerpDouble(s4, other.s4, t)!),
      s5: TwSpace(lerpDouble(s5, other.s5, t)!),
      s6: TwSpace(lerpDouble(s6, other.s6, t)!),
      s7: TwSpace(lerpDouble(s7, other.s7, t)!),
      s8: TwSpace(lerpDouble(s8, other.s8, t)!),
      s9: TwSpace(lerpDouble(s9, other.s9, t)!),
      s10: TwSpace(lerpDouble(s10, other.s10, t)!),
      s11: TwSpace(lerpDouble(s11, other.s11, t)!),
      s12: TwSpace(lerpDouble(s12, other.s12, t)!),
      s14: TwSpace(lerpDouble(s14, other.s14, t)!),
      s16: TwSpace(lerpDouble(s16, other.s16, t)!),
      s20: TwSpace(lerpDouble(s20, other.s20, t)!),
      s24: TwSpace(lerpDouble(s24, other.s24, t)!),
      s28: TwSpace(lerpDouble(s28, other.s28, t)!),
      s32: TwSpace(lerpDouble(s32, other.s32, t)!),
      s36: TwSpace(lerpDouble(s36, other.s36, t)!),
      s40: TwSpace(lerpDouble(s40, other.s40, t)!),
      s44: TwSpace(lerpDouble(s44, other.s44, t)!),
      s48: TwSpace(lerpDouble(s48, other.s48, t)!),
      s52: TwSpace(lerpDouble(s52, other.s52, t)!),
      s56: TwSpace(lerpDouble(s56, other.s56, t)!),
      s60: TwSpace(lerpDouble(s60, other.s60, t)!),
      s64: TwSpace(lerpDouble(s64, other.s64, t)!),
      s72: TwSpace(lerpDouble(s72, other.s72, t)!),
      s80: TwSpace(lerpDouble(s80, other.s80, t)!),
      s96: TwSpace(lerpDouble(s96, other.s96, t)!),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. TwTypographyTheme
// ---------------------------------------------------------------------------

/// Theme extension providing Tailwind CSS typography tokens.
///
/// Includes 13 font sizes, 9 font weights, 6 letter spacing values, and
/// 6 line height values. All default to their respective token class constants.
///
/// Font weight field `fontBlack` is named to avoid collision with the
/// `black` color concept. Letter spacing and line height fields use prefixed
/// names (`letterNormal`, `leadingNormal`) to avoid collisions with font
/// weight `normal`.
class TwTypographyTheme extends ThemeExtension<TwTypographyTheme> {
  /// Creates a [TwTypographyTheme] with all typography tokens.
  const TwTypographyTheme({
    // Font sizes
    required this.xs,
    required this.sm,
    required this.base,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.xl4,
    required this.xl5,
    required this.xl6,
    required this.xl7,
    required this.xl8,
    required this.xl9,
    // Font weights
    required this.thin,
    required this.extralight,
    required this.light,
    required this.normal,
    required this.medium,
    required this.semibold,
    required this.bold,
    required this.extrabold,
    required this.fontBlack,
    // Letter spacing
    required this.tighter,
    required this.tight,
    required this.letterNormal,
    required this.wide,
    required this.wider,
    required this.widest,
    // Line heights
    required this.leadingNone,
    required this.leadingTight,
    required this.leadingSnug,
    required this.leadingNormal,
    required this.leadingRelaxed,
    required this.leadingLoose,
  });

  /// Default theme using all typography token constants.
  static const defaults = TwTypographyTheme(
    // Font sizes
    xs: TwFontSizes.xs,
    sm: TwFontSizes.sm,
    base: TwFontSizes.base,
    lg: TwFontSizes.lg,
    xl: TwFontSizes.xl,
    xl2: TwFontSizes.xl2,
    xl3: TwFontSizes.xl3,
    xl4: TwFontSizes.xl4,
    xl5: TwFontSizes.xl5,
    xl6: TwFontSizes.xl6,
    xl7: TwFontSizes.xl7,
    xl8: TwFontSizes.xl8,
    xl9: TwFontSizes.xl9,
    // Font weights
    thin: TwFontWeights.thin,
    extralight: TwFontWeights.extralight,
    light: TwFontWeights.light,
    normal: TwFontWeights.normal,
    medium: TwFontWeights.medium,
    semibold: TwFontWeights.semibold,
    bold: TwFontWeights.bold,
    extrabold: TwFontWeights.extrabold,
    fontBlack: TwFontWeights.black,
    // Letter spacing
    tighter: TwLetterSpacing.tighter,
    tight: TwLetterSpacing.tight,
    letterNormal: TwLetterSpacing.normal,
    wide: TwLetterSpacing.wide,
    wider: TwLetterSpacing.wider,
    widest: TwLetterSpacing.widest,
    // Line heights
    leadingNone: TwLineHeights.none,
    leadingTight: TwLineHeights.tight,
    leadingSnug: TwLineHeights.snug,
    leadingNormal: TwLineHeights.normal,
    leadingRelaxed: TwLineHeights.relaxed,
    leadingLoose: TwLineHeights.loose,
  );

  // -- Font sizes --

  /// Extra-small font size (12px).
  final TwFontSize xs;

  /// Small font size (14px).
  final TwFontSize sm;

  /// Base font size (16px).
  final TwFontSize base;

  /// Large font size (18px).
  final TwFontSize lg;

  /// Extra-large font size (20px).
  final TwFontSize xl;

  /// 2x extra-large font size (24px).
  final TwFontSize xl2;

  /// 3x extra-large font size (30px).
  final TwFontSize xl3;

  /// 4x extra-large font size (36px).
  final TwFontSize xl4;

  /// 5x extra-large font size (48px).
  final TwFontSize xl5;

  /// 6x extra-large font size (60px).
  final TwFontSize xl6;

  /// 7x extra-large font size (72px).
  final TwFontSize xl7;

  /// 8x extra-large font size (96px).
  final TwFontSize xl8;

  /// 9x extra-large font size (128px).
  final TwFontSize xl9;

  // -- Font weights --

  /// Thin font weight (w100).
  final FontWeight thin;

  /// Extra-light font weight (w200).
  final FontWeight extralight;

  /// Light font weight (w300).
  final FontWeight light;

  /// Normal font weight (w400).
  final FontWeight normal;

  /// Medium font weight (w500).
  final FontWeight medium;

  /// Semibold font weight (w600).
  final FontWeight semibold;

  /// Bold font weight (w700).
  final FontWeight bold;

  /// Extra-bold font weight (w800).
  final FontWeight extrabold;

  /// Black font weight (w900). Named `fontBlack` to avoid color confusion.
  final FontWeight fontBlack;

  // -- Letter spacing --

  /// Tightest letter spacing (-0.05em).
  final double tighter;

  /// Tight letter spacing (-0.025em).
  final double tight;

  /// Normal letter spacing (0em). Named `letterNormal` to avoid ambiguity.
  final double letterNormal;

  /// Wide letter spacing (0.025em).
  final double wide;

  /// Wider letter spacing (0.05em).
  final double wider;

  /// Widest letter spacing (0.1em).
  final double widest;

  // -- Line heights --

  /// No extra leading (1.0). Named `leadingNone` to avoid ambiguity.
  final double leadingNone;

  /// Tight leading (1.25).
  final double leadingTight;

  /// Snug leading (1.375).
  final double leadingSnug;

  /// Normal leading (1.5).
  final double leadingNormal;

  /// Relaxed leading (1.625).
  final double leadingRelaxed;

  /// Loose leading (2.0).
  final double leadingLoose;

  @override
  TwTypographyTheme copyWith({
    // Font sizes
    TwFontSize? xs,
    TwFontSize? sm,
    TwFontSize? base,
    TwFontSize? lg,
    TwFontSize? xl,
    TwFontSize? xl2,
    TwFontSize? xl3,
    TwFontSize? xl4,
    TwFontSize? xl5,
    TwFontSize? xl6,
    TwFontSize? xl7,
    TwFontSize? xl8,
    TwFontSize? xl9,
    // Font weights
    FontWeight? thin,
    FontWeight? extralight,
    FontWeight? light,
    FontWeight? normal,
    FontWeight? medium,
    FontWeight? semibold,
    FontWeight? bold,
    FontWeight? extrabold,
    FontWeight? fontBlack,
    // Letter spacing
    double? tighter,
    double? tight,
    double? letterNormal,
    double? wide,
    double? wider,
    double? widest,
    // Line heights
    double? leadingNone,
    double? leadingTight,
    double? leadingSnug,
    double? leadingNormal,
    double? leadingRelaxed,
    double? leadingLoose,
  }) {
    return TwTypographyTheme(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      base: base ?? this.base,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
      xl3: xl3 ?? this.xl3,
      xl4: xl4 ?? this.xl4,
      xl5: xl5 ?? this.xl5,
      xl6: xl6 ?? this.xl6,
      xl7: xl7 ?? this.xl7,
      xl8: xl8 ?? this.xl8,
      xl9: xl9 ?? this.xl9,
      thin: thin ?? this.thin,
      extralight: extralight ?? this.extralight,
      light: light ?? this.light,
      normal: normal ?? this.normal,
      medium: medium ?? this.medium,
      semibold: semibold ?? this.semibold,
      bold: bold ?? this.bold,
      extrabold: extrabold ?? this.extrabold,
      fontBlack: fontBlack ?? this.fontBlack,
      tighter: tighter ?? this.tighter,
      tight: tight ?? this.tight,
      letterNormal: letterNormal ?? this.letterNormal,
      wide: wide ?? this.wide,
      wider: wider ?? this.wider,
      widest: widest ?? this.widest,
      leadingNone: leadingNone ?? this.leadingNone,
      leadingTight: leadingTight ?? this.leadingTight,
      leadingSnug: leadingSnug ?? this.leadingSnug,
      leadingNormal: leadingNormal ?? this.leadingNormal,
      leadingRelaxed: leadingRelaxed ?? this.leadingRelaxed,
      leadingLoose: leadingLoose ?? this.leadingLoose,
    );
  }

  @override
  TwTypographyTheme lerp(
    covariant ThemeExtension<TwTypographyTheme>? other,
    double t,
  ) {
    if (other is! TwTypographyTheme) return this;
    return TwTypographyTheme(
      // Font sizes: lerp both size and lineHeight components
      xs: TwFontSize(
        lerpDouble(xs.value, other.xs.value, t)!,
        lerpDouble(xs.lineHeight, other.xs.lineHeight, t)!,
      ),
      sm: TwFontSize(
        lerpDouble(sm.value, other.sm.value, t)!,
        lerpDouble(sm.lineHeight, other.sm.lineHeight, t)!,
      ),
      base: TwFontSize(
        lerpDouble(base.value, other.base.value, t)!,
        lerpDouble(base.lineHeight, other.base.lineHeight, t)!,
      ),
      lg: TwFontSize(
        lerpDouble(lg.value, other.lg.value, t)!,
        lerpDouble(lg.lineHeight, other.lg.lineHeight, t)!,
      ),
      xl: TwFontSize(
        lerpDouble(xl.value, other.xl.value, t)!,
        lerpDouble(xl.lineHeight, other.xl.lineHeight, t)!,
      ),
      xl2: TwFontSize(
        lerpDouble(xl2.value, other.xl2.value, t)!,
        lerpDouble(xl2.lineHeight, other.xl2.lineHeight, t)!,
      ),
      xl3: TwFontSize(
        lerpDouble(xl3.value, other.xl3.value, t)!,
        lerpDouble(xl3.lineHeight, other.xl3.lineHeight, t)!,
      ),
      xl4: TwFontSize(
        lerpDouble(xl4.value, other.xl4.value, t)!,
        lerpDouble(xl4.lineHeight, other.xl4.lineHeight, t)!,
      ),
      xl5: TwFontSize(
        lerpDouble(xl5.value, other.xl5.value, t)!,
        lerpDouble(xl5.lineHeight, other.xl5.lineHeight, t)!,
      ),
      xl6: TwFontSize(
        lerpDouble(xl6.value, other.xl6.value, t)!,
        lerpDouble(xl6.lineHeight, other.xl6.lineHeight, t)!,
      ),
      xl7: TwFontSize(
        lerpDouble(xl7.value, other.xl7.value, t)!,
        lerpDouble(xl7.lineHeight, other.xl7.lineHeight, t)!,
      ),
      xl8: TwFontSize(
        lerpDouble(xl8.value, other.xl8.value, t)!,
        lerpDouble(xl8.lineHeight, other.xl8.lineHeight, t)!,
      ),
      xl9: TwFontSize(
        lerpDouble(xl9.value, other.xl9.value, t)!,
        lerpDouble(xl9.lineHeight, other.xl9.lineHeight, t)!,
      ),
      // Font weights
      thin: FontWeight.lerp(thin, other.thin, t)!,
      extralight: FontWeight.lerp(extralight, other.extralight, t)!,
      light: FontWeight.lerp(light, other.light, t)!,
      normal: FontWeight.lerp(normal, other.normal, t)!,
      medium: FontWeight.lerp(medium, other.medium, t)!,
      semibold: FontWeight.lerp(semibold, other.semibold, t)!,
      bold: FontWeight.lerp(bold, other.bold, t)!,
      extrabold: FontWeight.lerp(extrabold, other.extrabold, t)!,
      fontBlack: FontWeight.lerp(fontBlack, other.fontBlack, t)!,
      // Letter spacing
      tighter: lerpDouble(tighter, other.tighter, t)!,
      tight: lerpDouble(tight, other.tight, t)!,
      letterNormal: lerpDouble(letterNormal, other.letterNormal, t)!,
      wide: lerpDouble(wide, other.wide, t)!,
      wider: lerpDouble(wider, other.wider, t)!,
      widest: lerpDouble(widest, other.widest, t)!,
      // Line heights
      leadingNone: lerpDouble(leadingNone, other.leadingNone, t)!,
      leadingTight: lerpDouble(leadingTight, other.leadingTight, t)!,
      leadingSnug: lerpDouble(leadingSnug, other.leadingSnug, t)!,
      leadingNormal: lerpDouble(leadingNormal, other.leadingNormal, t)!,
      leadingRelaxed: lerpDouble(leadingRelaxed, other.leadingRelaxed, t)!,
      leadingLoose: lerpDouble(leadingLoose, other.leadingLoose, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// 4. TwRadiusTheme
// ---------------------------------------------------------------------------

/// Theme extension providing the Tailwind CSS border radius scale.
///
/// Contains all 10 radius values from [TwRadii].
class TwRadiusTheme extends ThemeExtension<TwRadiusTheme> {
  /// Creates a [TwRadiusTheme] with all 10 radius values.
  const TwRadiusTheme({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.xl4,
    required this.full,
  });

  /// Default theme using all [TwRadii] constants.
  static const defaults = TwRadiusTheme(
    none: TwRadii.none,
    xs: TwRadii.xs,
    sm: TwRadii.sm,
    md: TwRadii.md,
    lg: TwRadii.lg,
    xl: TwRadii.xl,
    xl2: TwRadii.xl2,
    xl3: TwRadii.xl3,
    xl4: TwRadii.xl4,
    full: TwRadii.full,
  );

  /// No rounding (0px).
  final TwRadius none;

  /// Extra-small radius (2px).
  final TwRadius xs;

  /// Small radius (4px).
  final TwRadius sm;

  /// Medium radius (6px).
  final TwRadius md;

  /// Large radius (8px).
  final TwRadius lg;

  /// Extra-large radius (12px).
  final TwRadius xl;

  /// 2x extra-large radius (16px).
  final TwRadius xl2;

  /// 3x extra-large radius (24px).
  final TwRadius xl3;

  /// 4x extra-large radius (32px).
  final TwRadius xl4;

  /// Full radius (9999px -- pill shape).
  final TwRadius full;

  @override
  TwRadiusTheme copyWith({
    TwRadius? none,
    TwRadius? xs,
    TwRadius? sm,
    TwRadius? md,
    TwRadius? lg,
    TwRadius? xl,
    TwRadius? xl2,
    TwRadius? xl3,
    TwRadius? xl4,
    TwRadius? full,
  }) {
    return TwRadiusTheme(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
      xl3: xl3 ?? this.xl3,
      xl4: xl4 ?? this.xl4,
      full: full ?? this.full,
    );
  }

  @override
  TwRadiusTheme lerp(
    covariant ThemeExtension<TwRadiusTheme>? other,
    double t,
  ) {
    if (other is! TwRadiusTheme) return this;
    return TwRadiusTheme(
      none: TwRadius(lerpDouble(none, other.none, t)!),
      xs: TwRadius(lerpDouble(xs, other.xs, t)!),
      sm: TwRadius(lerpDouble(sm, other.sm, t)!),
      md: TwRadius(lerpDouble(md, other.md, t)!),
      lg: TwRadius(lerpDouble(lg, other.lg, t)!),
      xl: TwRadius(lerpDouble(xl, other.xl, t)!),
      xl2: TwRadius(lerpDouble(xl2, other.xl2, t)!),
      xl3: TwRadius(lerpDouble(xl3, other.xl3, t)!),
      xl4: TwRadius(lerpDouble(xl4, other.xl4, t)!),
      full: TwRadius(lerpDouble(full, other.full, t)!),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. TwShadowTheme
// ---------------------------------------------------------------------------

/// Theme extension providing the Tailwind CSS box shadow presets.
///
/// Contains all 9 shadow presets from [TwShadows].
class TwShadowTheme extends ThemeExtension<TwShadowTheme> {
  /// Creates a [TwShadowTheme] with all 9 shadow presets.
  const TwShadowTheme({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.inner,
    required this.none,
  });

  /// Default theme using all [TwShadows] constants.
  static const defaults = TwShadowTheme(
    xxs: TwShadows.xxs,
    xs: TwShadows.xs,
    sm: TwShadows.sm,
    md: TwShadows.md,
    lg: TwShadows.lg,
    xl: TwShadows.xl,
    xxl: TwShadows.xxl,
    inner: TwShadows.inner,
    none: TwShadows.none,
  );

  /// Extra-extra-small shadow.
  final List<BoxShadow> xxs;

  /// Extra-small shadow.
  final List<BoxShadow> xs;

  /// Small shadow.
  final List<BoxShadow> sm;

  /// Medium shadow.
  final List<BoxShadow> md;

  /// Large shadow.
  final List<BoxShadow> lg;

  /// Extra-large shadow.
  final List<BoxShadow> xl;

  /// Extra-extra-large shadow.
  final List<BoxShadow> xxl;

  /// Inner shadow approximation.
  final List<BoxShadow> inner;

  /// No shadow.
  final List<BoxShadow> none;

  @override
  TwShadowTheme copyWith({
    List<BoxShadow>? xxs,
    List<BoxShadow>? xs,
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
    List<BoxShadow>? xxl,
    List<BoxShadow>? inner,
    List<BoxShadow>? none,
  }) {
    return TwShadowTheme(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      inner: inner ?? this.inner,
      none: none ?? this.none,
    );
  }

  @override
  TwShadowTheme lerp(
    covariant ThemeExtension<TwShadowTheme>? other,
    double t,
  ) {
    if (other is! TwShadowTheme) return this;
    return TwShadowTheme(
      xxs: BoxShadow.lerpList(xxs, other.xxs, t) ?? const <BoxShadow>[],
      xs: BoxShadow.lerpList(xs, other.xs, t) ?? const <BoxShadow>[],
      sm: BoxShadow.lerpList(sm, other.sm, t) ?? const <BoxShadow>[],
      md: BoxShadow.lerpList(md, other.md, t) ?? const <BoxShadow>[],
      lg: BoxShadow.lerpList(lg, other.lg, t) ?? const <BoxShadow>[],
      xl: BoxShadow.lerpList(xl, other.xl, t) ?? const <BoxShadow>[],
      xxl: BoxShadow.lerpList(xxl, other.xxl, t) ?? const <BoxShadow>[],
      inner: BoxShadow.lerpList(inner, other.inner, t) ?? const <BoxShadow>[],
      none: BoxShadow.lerpList(none, other.none, t) ?? const <BoxShadow>[],
    );
  }
}

// ---------------------------------------------------------------------------
// 6. TwOpacityTheme
// ---------------------------------------------------------------------------

/// Theme extension providing the Tailwind CSS opacity scale.
///
/// Contains all 21 opacity values from [TwOpacity].
class TwOpacityTheme extends ThemeExtension<TwOpacityTheme> {
  /// Creates a [TwOpacityTheme] with all 21 opacity values.
  const TwOpacityTheme({
    required this.o0,
    required this.o5,
    required this.o10,
    required this.o15,
    required this.o20,
    required this.o25,
    required this.o30,
    required this.o35,
    required this.o40,
    required this.o45,
    required this.o50,
    required this.o55,
    required this.o60,
    required this.o65,
    required this.o70,
    required this.o75,
    required this.o80,
    required this.o85,
    required this.o90,
    required this.o95,
    required this.o100,
  });

  /// Default theme using all [TwOpacity] constants.
  static const defaults = TwOpacityTheme(
    o0: TwOpacity.o0,
    o5: TwOpacity.o5,
    o10: TwOpacity.o10,
    o15: TwOpacity.o15,
    o20: TwOpacity.o20,
    o25: TwOpacity.o25,
    o30: TwOpacity.o30,
    o35: TwOpacity.o35,
    o40: TwOpacity.o40,
    o45: TwOpacity.o45,
    o50: TwOpacity.o50,
    o55: TwOpacity.o55,
    o60: TwOpacity.o60,
    o65: TwOpacity.o65,
    o70: TwOpacity.o70,
    o75: TwOpacity.o75,
    o80: TwOpacity.o80,
    o85: TwOpacity.o85,
    o90: TwOpacity.o90,
    o95: TwOpacity.o95,
    o100: TwOpacity.o100,
  );

  /// 0% opacity.
  final double o0;

  /// 5% opacity.
  final double o5;

  /// 10% opacity.
  final double o10;

  /// 15% opacity.
  final double o15;

  /// 20% opacity.
  final double o20;

  /// 25% opacity.
  final double o25;

  /// 30% opacity.
  final double o30;

  /// 35% opacity.
  final double o35;

  /// 40% opacity.
  final double o40;

  /// 45% opacity.
  final double o45;

  /// 50% opacity.
  final double o50;

  /// 55% opacity.
  final double o55;

  /// 60% opacity.
  final double o60;

  /// 65% opacity.
  final double o65;

  /// 70% opacity.
  final double o70;

  /// 75% opacity.
  final double o75;

  /// 80% opacity.
  final double o80;

  /// 85% opacity.
  final double o85;

  /// 90% opacity.
  final double o90;

  /// 95% opacity.
  final double o95;

  /// 100% opacity.
  final double o100;

  @override
  TwOpacityTheme copyWith({
    double? o0,
    double? o5,
    double? o10,
    double? o15,
    double? o20,
    double? o25,
    double? o30,
    double? o35,
    double? o40,
    double? o45,
    double? o50,
    double? o55,
    double? o60,
    double? o65,
    double? o70,
    double? o75,
    double? o80,
    double? o85,
    double? o90,
    double? o95,
    double? o100,
  }) {
    return TwOpacityTheme(
      o0: o0 ?? this.o0,
      o5: o5 ?? this.o5,
      o10: o10 ?? this.o10,
      o15: o15 ?? this.o15,
      o20: o20 ?? this.o20,
      o25: o25 ?? this.o25,
      o30: o30 ?? this.o30,
      o35: o35 ?? this.o35,
      o40: o40 ?? this.o40,
      o45: o45 ?? this.o45,
      o50: o50 ?? this.o50,
      o55: o55 ?? this.o55,
      o60: o60 ?? this.o60,
      o65: o65 ?? this.o65,
      o70: o70 ?? this.o70,
      o75: o75 ?? this.o75,
      o80: o80 ?? this.o80,
      o85: o85 ?? this.o85,
      o90: o90 ?? this.o90,
      o95: o95 ?? this.o95,
      o100: o100 ?? this.o100,
    );
  }

  @override
  TwOpacityTheme lerp(
    covariant ThemeExtension<TwOpacityTheme>? other,
    double t,
  ) {
    if (other is! TwOpacityTheme) return this;
    return TwOpacityTheme(
      o0: lerpDouble(o0, other.o0, t)!,
      o5: lerpDouble(o5, other.o5, t)!,
      o10: lerpDouble(o10, other.o10, t)!,
      o15: lerpDouble(o15, other.o15, t)!,
      o20: lerpDouble(o20, other.o20, t)!,
      o25: lerpDouble(o25, other.o25, t)!,
      o30: lerpDouble(o30, other.o30, t)!,
      o35: lerpDouble(o35, other.o35, t)!,
      o40: lerpDouble(o40, other.o40, t)!,
      o45: lerpDouble(o45, other.o45, t)!,
      o50: lerpDouble(o50, other.o50, t)!,
      o55: lerpDouble(o55, other.o55, t)!,
      o60: lerpDouble(o60, other.o60, t)!,
      o65: lerpDouble(o65, other.o65, t)!,
      o70: lerpDouble(o70, other.o70, t)!,
      o75: lerpDouble(o75, other.o75, t)!,
      o80: lerpDouble(o80, other.o80, t)!,
      o85: lerpDouble(o85, other.o85, t)!,
      o90: lerpDouble(o90, other.o90, t)!,
      o95: lerpDouble(o95, other.o95, t)!,
      o100: lerpDouble(o100, other.o100, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// 7. TwBreakpointTheme
// ---------------------------------------------------------------------------

/// Theme extension providing the Tailwind CSS responsive breakpoints.
///
/// Contains all 5 breakpoint values from [TwBreakpoints].
class TwBreakpointTheme extends ThemeExtension<TwBreakpointTheme> {
  /// Creates a [TwBreakpointTheme] with all 5 breakpoint values.
  const TwBreakpointTheme({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  /// Default theme using all [TwBreakpoints] constants.
  static const defaults = TwBreakpointTheme(
    sm: TwBreakpoints.sm,
    md: TwBreakpoints.md,
    lg: TwBreakpoints.lg,
    xl: TwBreakpoints.xl,
    xxl: TwBreakpoints.xxl,
  );

  /// Small breakpoint (640px).
  final double sm;

  /// Medium breakpoint (768px).
  final double md;

  /// Large breakpoint (1024px).
  final double lg;

  /// Extra-large breakpoint (1280px).
  final double xl;

  /// 2x extra-large breakpoint (1536px).
  final double xxl;

  @override
  TwBreakpointTheme copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return TwBreakpointTheme(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  TwBreakpointTheme lerp(
    covariant ThemeExtension<TwBreakpointTheme>? other,
    double t,
  ) {
    if (other is! TwBreakpointTheme) return this;
    return TwBreakpointTheme(
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }
}
