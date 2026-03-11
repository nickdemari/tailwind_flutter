import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/spacing.dart';

void main() {
  group('TwSpacing', () {
    group('value correctness (all 35 values)', () {
      test('s0 == 0.0', () => expect(TwSpacing.s0, 0.0));
      test('sPx == 1.0', () => expect(TwSpacing.sPx, 1.0));
      test('s0_5 == 2.0', () => expect(TwSpacing.s0_5, 2.0));
      test('s1 == 4.0', () => expect(TwSpacing.s1, 4.0));
      test('s1_5 == 6.0', () => expect(TwSpacing.s1_5, 6.0));
      test('s2 == 8.0', () => expect(TwSpacing.s2, 8.0));
      test('s2_5 == 10.0', () => expect(TwSpacing.s2_5, 10.0));
      test('s3 == 12.0', () => expect(TwSpacing.s3, 12.0));
      test('s3_5 == 14.0', () => expect(TwSpacing.s3_5, 14.0));
      test('s4 == 16.0', () => expect(TwSpacing.s4, 16.0));
      test('s5 == 20.0', () => expect(TwSpacing.s5, 20.0));
      test('s6 == 24.0', () => expect(TwSpacing.s6, 24.0));
      test('s7 == 28.0', () => expect(TwSpacing.s7, 28.0));
      test('s8 == 32.0', () => expect(TwSpacing.s8, 32.0));
      test('s9 == 36.0', () => expect(TwSpacing.s9, 36.0));
      test('s10 == 40.0', () => expect(TwSpacing.s10, 40.0));
      test('s11 == 44.0', () => expect(TwSpacing.s11, 44.0));
      test('s12 == 48.0', () => expect(TwSpacing.s12, 48.0));
      test('s14 == 56.0', () => expect(TwSpacing.s14, 56.0));
      test('s16 == 64.0', () => expect(TwSpacing.s16, 64.0));
      test('s20 == 80.0', () => expect(TwSpacing.s20, 80.0));
      test('s24 == 96.0', () => expect(TwSpacing.s24, 96.0));
      test('s28 == 112.0', () => expect(TwSpacing.s28, 112.0));
      test('s32 == 128.0', () => expect(TwSpacing.s32, 128.0));
      test('s36 == 144.0', () => expect(TwSpacing.s36, 144.0));
      test('s40 == 160.0', () => expect(TwSpacing.s40, 160.0));
      test('s44 == 176.0', () => expect(TwSpacing.s44, 176.0));
      test('s48 == 192.0', () => expect(TwSpacing.s48, 192.0));
      test('s52 == 208.0', () => expect(TwSpacing.s52, 208.0));
      test('s56 == 224.0', () => expect(TwSpacing.s56, 224.0));
      test('s60 == 240.0', () => expect(TwSpacing.s60, 240.0));
      test('s64 == 256.0', () => expect(TwSpacing.s64, 256.0));
      test('s72 == 288.0', () => expect(TwSpacing.s72, 288.0));
      test('s80 == 320.0', () => expect(TwSpacing.s80, 320.0));
      test('s96 == 384.0', () => expect(TwSpacing.s96, 384.0));
    });

    group('TwSpace implements double', () {
      test('can be used as a double', () {
        // ignore: unnecessary_type_check
        expect(TwSpacing.s4 is double, isTrue);
        expect(TwSpacing.s4, 16.0);
      });

      test('works in arithmetic with plain doubles', () {
        final result = TwSpacing.s4 + TwSpacing.s2;
        expect(result, 24.0);
        expect(result, isA<double>());
      });

      test('usable where double is expected', () {
        double takeDouble(double value) => value;
        expect(takeDouble(TwSpacing.s4), 16.0);
      });
    });

    group('EdgeInsets getters', () {
      test('.all returns EdgeInsets.all(value)', () {
        expect(TwSpacing.s4.all, EdgeInsets.all(16));
      });

      test('.x returns EdgeInsets.symmetric(horizontal: value)', () {
        expect(
          TwSpacing.s4.x,
          const EdgeInsets.symmetric(horizontal: 16),
        );
      });

      test('.y returns EdgeInsets.symmetric(vertical: value)', () {
        expect(
          TwSpacing.s4.y,
          const EdgeInsets.symmetric(vertical: 16),
        );
      });

      test('.top returns EdgeInsets.only(top: value)', () {
        expect(TwSpacing.s4.top, const EdgeInsets.only(top: 16));
      });

      test('.bottom returns EdgeInsets.only(bottom: value)', () {
        expect(TwSpacing.s4.bottom, const EdgeInsets.only(bottom: 16));
      });

      test('.left returns EdgeInsets.only(left: value)', () {
        expect(TwSpacing.s4.left, const EdgeInsets.only(left: 16));
      });

      test('.right returns EdgeInsets.only(right: value)', () {
        expect(TwSpacing.s4.right, const EdgeInsets.only(right: 16));
      });

      test('getters work on zero spacing', () {
        expect(TwSpacing.s0.all, EdgeInsets.zero);
        expect(TwSpacing.s0.x, EdgeInsets.zero);
        expect(TwSpacing.s0.y, EdgeInsets.zero);
      });

      test('getters produce correct values for different spacings', () {
        expect(TwSpacing.s1.all, EdgeInsets.all(4));
        expect(TwSpacing.s8.x, const EdgeInsets.symmetric(horizontal: 32));
        expect(TwSpacing.s96.top, const EdgeInsets.only(top: 384));
      });
    });
  });
}
