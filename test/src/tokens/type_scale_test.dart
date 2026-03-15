import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/type_scale.dart';
import 'package:tailwind_flutter/src/tokens/typography.dart';

void main() {
  group('TwTypeVariant', () {
    test('has 3 values', () {
      expect(TwTypeVariant.values.length, 3);
    });
  });

  group('TwFontRole', () {
    test('exposes sm, md, lg getters', () {
      const role = TwFontRole(
        sm: TwFontSizes.xs,
        md: TwFontSizes.sm,
        lg: TwFontSizes.base,
      );
      expect(role.sm.value, 12.0);
      expect(role.md.value, 14.0);
      expect(role.lg.value, 16.0);
    });

    test('resolve returns correct variant', () {
      const role = TwFontRole(
        sm: TwFontSizes.xs,
        md: TwFontSizes.sm,
        lg: TwFontSizes.base,
      );
      expect(role.resolve(TwTypeVariant.sm).value, 12.0);
      expect(role.resolve(TwTypeVariant.md).value, 14.0);
      expect(role.resolve(TwTypeVariant.lg).value, 16.0);
    });
  });

  group('TwTypeScale', () {
    test('display maps to xl4, xl5, xl6', () {
      expect(TwTypeScale.display.sm.value, 36.0);
      expect(TwTypeScale.display.md.value, 48.0);
      expect(TwTypeScale.display.lg.value, 60.0);
    });

    test('headline maps to xl2, xl3, xl4', () {
      expect(TwTypeScale.headline.sm.value, 24.0);
      expect(TwTypeScale.headline.md.value, 30.0);
      expect(TwTypeScale.headline.lg.value, 36.0);
    });

    test('title maps to sm, base, xl', () {
      expect(TwTypeScale.title.sm.value, 14.0);
      expect(TwTypeScale.title.md.value, 16.0);
      expect(TwTypeScale.title.lg.value, 20.0);
    });

    test('body maps to xs, sm, base', () {
      expect(TwTypeScale.body.sm.value, 12.0);
      expect(TwTypeScale.body.md.value, 14.0);
      expect(TwTypeScale.body.lg.value, 16.0);
    });

    test('label maps to xxs, xs, sm', () {
      expect(TwTypeScale.label.sm.value, 11.0);
      expect(TwTypeScale.label.md.value, 12.0);
      expect(TwTypeScale.label.lg.value, 14.0);
    });

    test('each role preserves paired lineHeight', () {
      expect(TwTypeScale.display.lg.lineHeight, 1.0);
      expect(TwTypeScale.headline.md.lineHeight, 1.2);
      expect(TwTypeScale.body.md.lineHeight, closeTo(1.4286, 0.001));
      expect(TwTypeScale.label.sm.lineHeight, closeTo(1.4545, 0.001));
    });
  });
}
