import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/typography.dart';

void main() {
  group('TwFontSizes', () {
    test('has 13 entries', () {
      // Exhaustive list -- if any are missing, the import will fail.
      final entries = <TwFontSize>[
        TwFontSizes.xs,
        TwFontSizes.sm,
        TwFontSizes.base,
        TwFontSizes.lg,
        TwFontSizes.xl,
        TwFontSizes.xl2,
        TwFontSizes.xl3,
        TwFontSizes.xl4,
        TwFontSizes.xl5,
        TwFontSizes.xl6,
        TwFontSizes.xl7,
        TwFontSizes.xl8,
        TwFontSizes.xl9,
      ];
      expect(entries.length, 13);
    });

    test('xs has value 12.0 and lineHeight ~1.3333', () {
      expect(TwFontSizes.xs.value, 12.0);
      expect(TwFontSizes.xs.lineHeight, closeTo(1.3333, 0.001));
    });

    test('sm has value 14.0 and lineHeight ~1.4286', () {
      expect(TwFontSizes.sm.value, 14.0);
      expect(TwFontSizes.sm.lineHeight, closeTo(1.4286, 0.001));
    });

    test('base has value 16.0 and lineHeight 1.5', () {
      expect(TwFontSizes.base.value, 16.0);
      expect(TwFontSizes.base.lineHeight, 1.5);
    });

    test('lg has value 18.0 and lineHeight ~1.5556', () {
      expect(TwFontSizes.lg.value, 18.0);
      expect(TwFontSizes.lg.lineHeight, closeTo(1.5556, 0.001));
    });

    test('xl has value 20.0 and lineHeight 1.4', () {
      expect(TwFontSizes.xl.value, 20.0);
      expect(TwFontSizes.xl.lineHeight, 1.4);
    });

    test('xl2 has value 24.0 and lineHeight ~1.3333', () {
      expect(TwFontSizes.xl2.value, 24.0);
      expect(TwFontSizes.xl2.lineHeight, closeTo(1.3333, 0.001));
    });

    test('xl3 has value 30.0 and lineHeight 1.2', () {
      expect(TwFontSizes.xl3.value, 30.0);
      expect(TwFontSizes.xl3.lineHeight, 1.2);
    });

    test('xl4 has value 36.0 and lineHeight ~1.1111', () {
      expect(TwFontSizes.xl4.value, 36.0);
      expect(TwFontSizes.xl4.lineHeight, closeTo(1.1111, 0.001));
    });

    test('xl5 has value 48.0 and lineHeight 1.0', () {
      expect(TwFontSizes.xl5.value, 48.0);
      expect(TwFontSizes.xl5.lineHeight, 1.0);
    });

    test('xl6 has value 60.0 and lineHeight 1.0', () {
      expect(TwFontSizes.xl6.value, 60.0);
      expect(TwFontSizes.xl6.lineHeight, 1.0);
    });

    test('xl7 has value 72.0 and lineHeight 1.0', () {
      expect(TwFontSizes.xl7.value, 72.0);
      expect(TwFontSizes.xl7.lineHeight, 1.0);
    });

    test('xl8 has value 96.0 and lineHeight 1.0', () {
      expect(TwFontSizes.xl8.value, 96.0);
      expect(TwFontSizes.xl8.lineHeight, 1.0);
    });

    test('xl9 has value 128.0 and lineHeight 1.0', () {
      expect(TwFontSizes.xl9.value, 128.0);
      expect(TwFontSizes.xl9.lineHeight, 1.0);
    });

    test('lg.textStyle returns TextStyle with fontSize and height', () {
      final style = TwFontSizes.lg.textStyle;
      expect(style, isA<TextStyle>());
      expect(style.fontSize, 18.0);
      expect(style.height, closeTo(1.5556, 0.001));
    });

    test('base.textStyle returns TextStyle with fontSize and height', () {
      final style = TwFontSizes.base.textStyle;
      expect(style.fontSize, 16.0);
      expect(style.height, 1.5);
    });
  });

  group('TwFontWeights', () {
    test('has 9 entries', () {
      final entries = <FontWeight>[
        TwFontWeights.thin,
        TwFontWeights.extralight,
        TwFontWeights.light,
        TwFontWeights.normal,
        TwFontWeights.medium,
        TwFontWeights.semibold,
        TwFontWeights.bold,
        TwFontWeights.extrabold,
        TwFontWeights.black,
      ];
      expect(entries.length, 9);
    });

    test('thin == FontWeight.w100', () {
      expect(TwFontWeights.thin, FontWeight.w100);
    });

    test('extralight == FontWeight.w200', () {
      expect(TwFontWeights.extralight, FontWeight.w200);
    });

    test('light == FontWeight.w300', () {
      expect(TwFontWeights.light, FontWeight.w300);
    });

    test('normal == FontWeight.w400', () {
      expect(TwFontWeights.normal, FontWeight.w400);
    });

    test('medium == FontWeight.w500', () {
      expect(TwFontWeights.medium, FontWeight.w500);
    });

    test('semibold == FontWeight.w600', () {
      expect(TwFontWeights.semibold, FontWeight.w600);
    });

    test('bold == FontWeight.w700', () {
      expect(TwFontWeights.bold, FontWeight.w700);
    });

    test('extrabold == FontWeight.w800', () {
      expect(TwFontWeights.extrabold, FontWeight.w800);
    });

    test('black == FontWeight.w900', () {
      expect(TwFontWeights.black, FontWeight.w900);
    });
  });

  group('TwLetterSpacing', () {
    test('has 6 entries', () {
      final entries = <double>[
        TwLetterSpacing.tighter,
        TwLetterSpacing.tight,
        TwLetterSpacing.normal,
        TwLetterSpacing.wide,
        TwLetterSpacing.wider,
        TwLetterSpacing.widest,
      ];
      expect(entries.length, 6);
    });

    test('tighter == -0.05', () {
      expect(TwLetterSpacing.tighter, -0.05);
    });

    test('tight == -0.025', () {
      expect(TwLetterSpacing.tight, -0.025);
    });

    test('normal == 0.0', () {
      expect(TwLetterSpacing.normal, 0.0);
    });

    test('wide == 0.025', () {
      expect(TwLetterSpacing.wide, 0.025);
    });

    test('wider == 0.05', () {
      expect(TwLetterSpacing.wider, 0.05);
    });

    test('widest == 0.1', () {
      expect(TwLetterSpacing.widest, 0.1);
    });
  });

  group('TwLineHeights', () {
    test('has 6 entries', () {
      final entries = <double>[
        TwLineHeights.none,
        TwLineHeights.tight,
        TwLineHeights.snug,
        TwLineHeights.normal,
        TwLineHeights.relaxed,
        TwLineHeights.loose,
      ];
      expect(entries.length, 6);
    });

    test('none == 1.0', () {
      expect(TwLineHeights.none, 1.0);
    });

    test('tight == 1.25', () {
      expect(TwLineHeights.tight, 1.25);
    });

    test('snug == 1.375', () {
      expect(TwLineHeights.snug, 1.375);
    });

    test('normal == 1.5', () {
      expect(TwLineHeights.normal, 1.5);
    });

    test('relaxed == 1.625', () {
      expect(TwLineHeights.relaxed, 1.625);
    });

    test('loose == 2.0', () {
      expect(TwLineHeights.loose, 2.0);
    });
  });
}
