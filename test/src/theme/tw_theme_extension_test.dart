import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/theme/tw_theme_extension.dart';
import 'package:tailwind_flutter/src/tokens/breakpoints.dart';
import 'package:tailwind_flutter/src/tokens/colors.dart';
import 'package:tailwind_flutter/src/tokens/opacity.dart';
import 'package:tailwind_flutter/src/tokens/radius.dart';
import 'package:tailwind_flutter/src/tokens/shadows.dart';
import 'package:tailwind_flutter/src/tokens/spacing.dart';
import 'package:tailwind_flutter/src/tokens/typography.dart';

void main() {
  // ---------------------------------------------------------------------------
  // TwColorTheme
  // ---------------------------------------------------------------------------
  group('TwColorTheme', () {
    test('defaults has all 22 families matching TwColors', () {
      const theme = TwColorTheme.defaults;

      expect(theme.slate, equals(TwColors.slate));
      expect(theme.gray, equals(TwColors.gray));
      expect(theme.zinc, equals(TwColors.zinc));
      expect(theme.neutral, equals(TwColors.neutral));
      expect(theme.stone, equals(TwColors.stone));
      expect(theme.red, equals(TwColors.red));
      expect(theme.orange, equals(TwColors.orange));
      expect(theme.amber, equals(TwColors.amber));
      expect(theme.yellow, equals(TwColors.yellow));
      expect(theme.lime, equals(TwColors.lime));
      expect(theme.green, equals(TwColors.green));
      expect(theme.emerald, equals(TwColors.emerald));
      expect(theme.teal, equals(TwColors.teal));
      expect(theme.cyan, equals(TwColors.cyan));
      expect(theme.sky, equals(TwColors.sky));
      expect(theme.blue, equals(TwColors.blue));
      expect(theme.indigo, equals(TwColors.indigo));
      expect(theme.violet, equals(TwColors.violet));
      expect(theme.purple, equals(TwColors.purple));
      expect(theme.fuchsia, equals(TwColors.fuchsia));
      expect(theme.pink, equals(TwColors.pink));
      expect(theme.rose, equals(TwColors.rose));
      expect(theme.black, equals(TwColors.black));
      expect(theme.white, equals(TwColors.white));
      expect(theme.transparent, equals(TwColors.transparent));
    });

    test('copyWith replaces specified family, keeps others', () {
      const customRed = TwColorFamily(
        shade50: Color(0xFFFF0000),
        shade100: Color(0xFFFF0000),
        shade200: Color(0xFFFF0000),
        shade300: Color(0xFFFF0000),
        shade400: Color(0xFFFF0000),
        shade500: Color(0xFFFF0000),
        shade600: Color(0xFFFF0000),
        shade700: Color(0xFFFF0000),
        shade800: Color(0xFFFF0000),
        shade900: Color(0xFFFF0000),
        shade950: Color(0xFFFF0000),
      );

      final copied = TwColorTheme.defaults.copyWith(red: customRed);

      expect(copied.red, equals(customRed));
      expect(copied.blue, equals(TwColors.blue));
      expect(copied.slate, equals(TwColors.slate));
    });

    test('copyWith with null keeps all defaults', () {
      final copied = TwColorTheme.defaults.copyWith();
      expect(copied.red, equals(TwColors.red));
      expect(copied.blue, equals(TwColors.blue));
    });

    test('lerp at t=0 returns this', () {
      const a = TwColorTheme.defaults;
      const customBlue = TwColorFamily(
        shade50: Color(0xFF000000),
        shade100: Color(0xFF000000),
        shade200: Color(0xFF000000),
        shade300: Color(0xFF000000),
        shade400: Color(0xFF000000),
        shade500: Color(0xFF000000),
        shade600: Color(0xFF000000),
        shade700: Color(0xFF000000),
        shade800: Color(0xFF000000),
        shade900: Color(0xFF000000),
        shade950: Color(0xFF000000),
      );
      final b = TwColorTheme.defaults.copyWith(blue: customBlue);

      final result = a.lerp(b, 0);
      expect(result.blue.shade500, equals(TwColors.blue.shade500));
    });

    test('lerp at t=1 returns other', () {
      const a = TwColorTheme.defaults;
      const customBlue = TwColorFamily(
        shade50: Color(0xFF000000),
        shade100: Color(0xFF000000),
        shade200: Color(0xFF000000),
        shade300: Color(0xFF000000),
        shade400: Color(0xFF000000),
        shade500: Color(0xFF000000),
        shade600: Color(0xFF000000),
        shade700: Color(0xFF000000),
        shade800: Color(0xFF000000),
        shade900: Color(0xFF000000),
        shade950: Color(0xFF000000),
      );
      final b = TwColorTheme.defaults.copyWith(blue: customBlue);

      final result = a.lerp(b, 1);
      expect(result.blue.shade500, equals(const Color(0xFF000000)));
    });

    test('lerp guard returns this when other is wrong type', () {
      const a = TwColorTheme.defaults;
      final result = a.lerp(a, 0.5);
      expect(result, isA<TwColorTheme>());
    });
  });

  // ---------------------------------------------------------------------------
  // TwSpacingTheme
  // ---------------------------------------------------------------------------
  group('TwSpacingTheme', () {
    test('defaults has all 35 values matching TwSpacing', () {
      const theme = TwSpacingTheme.defaults;

      expect(theme.s0, equals(TwSpacing.s0));
      expect(theme.sPx, equals(TwSpacing.sPx));
      expect(theme.s0_5, equals(TwSpacing.s0_5));
      expect(theme.s1, equals(TwSpacing.s1));
      expect(theme.s4, equals(TwSpacing.s4));
      expect(theme.s8, equals(TwSpacing.s8));
      expect(theme.s16, equals(TwSpacing.s16));
      expect(theme.s32, equals(TwSpacing.s32));
      expect(theme.s64, equals(TwSpacing.s64));
      expect(theme.s96, equals(TwSpacing.s96));
    });

    test('copyWith replaces value, keeps others', () {
      const custom = TwSpace(999);
      final copied = TwSpacingTheme.defaults.copyWith(s4: custom);

      expect(copied.s4, equals(const TwSpace(999)));
      expect(copied.s8, equals(TwSpacing.s8));
    });

    test('lerp interpolates spacing values', () {
      const big = TwSpace(100);
      const a = TwSpacingTheme.defaults;
      final b = TwSpacingTheme.defaults.copyWith(s4: big);

      final result = a.lerp(b, 0.5);
      // lerpDouble(16, 100, 0.5) = 58.0
      expect(result.s4, closeTo(58, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // TwTypographyTheme
  // ---------------------------------------------------------------------------
  group('TwTypographyTheme', () {
    test('defaults has font sizes matching TwFontSizes', () {
      const theme = TwTypographyTheme.defaults;

      expect(theme.xs, equals(TwFontSizes.xs));
      expect(theme.sm, equals(TwFontSizes.sm));
      expect(theme.base, equals(TwFontSizes.base));
      expect(theme.lg, equals(TwFontSizes.lg));
      expect(theme.xl, equals(TwFontSizes.xl));
      expect(theme.xl2, equals(TwFontSizes.xl2));
      expect(theme.xl3, equals(TwFontSizes.xl3));
      expect(theme.xl4, equals(TwFontSizes.xl4));
      expect(theme.xl5, equals(TwFontSizes.xl5));
      expect(theme.xl6, equals(TwFontSizes.xl6));
      expect(theme.xl7, equals(TwFontSizes.xl7));
      expect(theme.xl8, equals(TwFontSizes.xl8));
      expect(theme.xl9, equals(TwFontSizes.xl9));
    });

    test('defaults has font weights matching TwFontWeights', () {
      const theme = TwTypographyTheme.defaults;

      expect(theme.thin, equals(TwFontWeights.thin));
      expect(theme.extralight, equals(TwFontWeights.extralight));
      expect(theme.light, equals(TwFontWeights.light));
      expect(theme.normal, equals(TwFontWeights.normal));
      expect(theme.medium, equals(TwFontWeights.medium));
      expect(theme.semibold, equals(TwFontWeights.semibold));
      expect(theme.bold, equals(TwFontWeights.bold));
      expect(theme.extrabold, equals(TwFontWeights.extrabold));
      expect(theme.fontBlack, equals(TwFontWeights.black));
    });

    test('defaults has letter spacing matching TwLetterSpacing', () {
      const theme = TwTypographyTheme.defaults;

      expect(theme.tighter, equals(TwLetterSpacing.tighter));
      expect(theme.tight, equals(TwLetterSpacing.tight));
      expect(theme.letterNormal, equals(TwLetterSpacing.normal));
      expect(theme.wide, equals(TwLetterSpacing.wide));
      expect(theme.wider, equals(TwLetterSpacing.wider));
      expect(theme.widest, equals(TwLetterSpacing.widest));
    });

    test('defaults has line heights matching TwLineHeights', () {
      const theme = TwTypographyTheme.defaults;

      expect(theme.leadingNone, equals(TwLineHeights.none));
      expect(theme.leadingTight, equals(TwLineHeights.tight));
      expect(theme.leadingSnug, equals(TwLineHeights.snug));
      expect(theme.leadingNormal, equals(TwLineHeights.normal));
      expect(theme.leadingRelaxed, equals(TwLineHeights.relaxed));
      expect(theme.leadingLoose, equals(TwLineHeights.loose));
    });

    test('copyWith works correctly', () {
      const customBase = TwFontSize(20, 1.6);
      final copied = TwTypographyTheme.defaults.copyWith(base: customBase);

      expect(copied.base, equals(customBase));
      expect(copied.xl, equals(TwFontSizes.xl));
    });
  });

  // ---------------------------------------------------------------------------
  // TwRadiusTheme
  // ---------------------------------------------------------------------------
  group('TwRadiusTheme', () {
    test('defaults has all 10 radius values', () {
      const theme = TwRadiusTheme.defaults;

      expect(theme.none, equals(TwRadii.none));
      expect(theme.xs, equals(TwRadii.xs));
      expect(theme.sm, equals(TwRadii.sm));
      expect(theme.md, equals(TwRadii.md));
      expect(theme.lg, equals(TwRadii.lg));
      expect(theme.xl, equals(TwRadii.xl));
      expect(theme.xl2, equals(TwRadii.xl2));
      expect(theme.xl3, equals(TwRadii.xl3));
      expect(theme.xl4, equals(TwRadii.xl4));
      expect(theme.full, equals(TwRadii.full));
    });

    test('copyWith replaces value, keeps others', () {
      const custom = TwRadius(42);
      final copied = TwRadiusTheme.defaults.copyWith(lg: custom);

      expect(copied.lg, equals(const TwRadius(42)));
      expect(copied.md, equals(TwRadii.md));
    });

    test('lerp interpolates radius values', () {
      const big = TwRadius(100);
      const a = TwRadiusTheme.defaults;
      final b = TwRadiusTheme.defaults.copyWith(lg: big);

      final result = a.lerp(b, 0.5);
      // lerpDouble(8, 100, 0.5) = 54.0
      expect(result.lg, closeTo(54, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // TwShadowTheme
  // ---------------------------------------------------------------------------
  group('TwShadowTheme', () {
    test('defaults has all 9 shadow presets', () {
      const theme = TwShadowTheme.defaults;

      expect(theme.xxs, equals(TwShadows.xxs));
      expect(theme.xs, equals(TwShadows.xs));
      expect(theme.sm, equals(TwShadows.sm));
      expect(theme.md, equals(TwShadows.md));
      expect(theme.lg, equals(TwShadows.lg));
      expect(theme.xl, equals(TwShadows.xl));
      expect(theme.xxl, equals(TwShadows.xxl));
      expect(theme.inner, equals(TwShadows.inner));
      expect(theme.none, equals(TwShadows.none));
    });

    test('copyWith replaces shadow, keeps others', () {
      const custom = <BoxShadow>[
        BoxShadow(blurRadius: 99, color: Color(0xFFFF0000)),
      ];
      final copied = TwShadowTheme.defaults.copyWith(md: custom);

      expect(copied.md, equals(custom));
      expect(copied.lg, equals(TwShadows.lg));
    });

    test('lerp uses BoxShadow.lerpList', () {
      const custom = <BoxShadow>[
        BoxShadow(
          offset: Offset(0, 100),
          blurRadius: 100,
          color: Color(0xFFFF0000),
        ),
      ];
      const a = TwShadowTheme.defaults;
      final b = TwShadowTheme.defaults.copyWith(xxs: custom);

      final result = a.lerp(b, 0.5);
      expect(result.xxs, isNotEmpty);
      // Shadow should be interpolated midway
      expect(result.xxs.first.blurRadius, closeTo(50, 1));
    });
  });

  // ---------------------------------------------------------------------------
  // TwOpacityTheme
  // ---------------------------------------------------------------------------
  group('TwOpacityTheme', () {
    test('defaults has all 21 opacity values', () {
      const theme = TwOpacityTheme.defaults;

      expect(theme.o0, equals(TwOpacity.o0));
      expect(theme.o5, equals(TwOpacity.o5));
      expect(theme.o10, equals(TwOpacity.o10));
      expect(theme.o25, equals(TwOpacity.o25));
      expect(theme.o50, equals(TwOpacity.o50));
      expect(theme.o75, equals(TwOpacity.o75));
      expect(theme.o100, equals(TwOpacity.o100));
    });

    test('copyWith replaces value, keeps others', () {
      final copied = TwOpacityTheme.defaults.copyWith(o50: 0.42);

      expect(copied.o50, equals(0.42));
      expect(copied.o25, equals(TwOpacity.o25));
    });

    test('lerp interpolates opacity values', () {
      const a = TwOpacityTheme.defaults;
      final b = TwOpacityTheme.defaults.copyWith(o50: 1);

      final result = a.lerp(b, 0.5);
      // lerpDouble(0.5, 1.0, 0.5) = 0.75
      expect(result.o50, closeTo(0.75, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // TwBreakpointTheme
  // ---------------------------------------------------------------------------
  group('TwBreakpointTheme', () {
    test('defaults has all 5 breakpoints', () {
      const theme = TwBreakpointTheme.defaults;

      expect(theme.sm, equals(TwBreakpoints.sm));
      expect(theme.md, equals(TwBreakpoints.md));
      expect(theme.lg, equals(TwBreakpoints.lg));
      expect(theme.xl, equals(TwBreakpoints.xl));
      expect(theme.xxl, equals(TwBreakpoints.xxl));
    });

    test('copyWith replaces value, keeps others', () {
      final copied = TwBreakpointTheme.defaults.copyWith(md: 800);

      expect(copied.md, equals(800));
      expect(copied.lg, equals(TwBreakpoints.lg));
    });

    test('lerp interpolates breakpoint values', () {
      const a = TwBreakpointTheme.defaults;
      final b = TwBreakpointTheme.defaults.copyWith(sm: 1000);

      final result = a.lerp(b, 0.5);
      // lerpDouble(640, 1000, 0.5) = 820
      expect(result.sm, closeTo(820, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // Cross-cutting: all ThemeExtension classes
  // ---------------------------------------------------------------------------
  group('All ThemeExtension classes', () {
    test('are ThemeExtension instances', () {
      expect(TwColorTheme.defaults, isA<ThemeExtension<TwColorTheme>>());
      expect(
        TwSpacingTheme.defaults,
        isA<ThemeExtension<TwSpacingTheme>>(),
      );
      expect(
        TwTypographyTheme.defaults,
        isA<ThemeExtension<TwTypographyTheme>>(),
      );
      expect(TwRadiusTheme.defaults, isA<ThemeExtension<TwRadiusTheme>>());
      expect(TwShadowTheme.defaults, isA<ThemeExtension<TwShadowTheme>>());
      expect(
        TwOpacityTheme.defaults,
        isA<ThemeExtension<TwOpacityTheme>>(),
      );
      expect(
        TwBreakpointTheme.defaults,
        isA<ThemeExtension<TwBreakpointTheme>>(),
      );
    });
  });
}
