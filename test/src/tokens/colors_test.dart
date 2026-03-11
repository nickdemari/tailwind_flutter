import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/colors.dart';

void main() {
  group('TwColors', () {
    group('structure', () {
      test('has exactly 22 color families', () {
        // Access all 22 families to verify they exist as TwColorFamily
        final families = <TwColorFamily>[
          TwColors.slate,
          TwColors.gray,
          TwColors.zinc,
          TwColors.neutral,
          TwColors.stone,
          TwColors.red,
          TwColors.orange,
          TwColors.amber,
          TwColors.yellow,
          TwColors.lime,
          TwColors.green,
          TwColors.emerald,
          TwColors.teal,
          TwColors.cyan,
          TwColors.sky,
          TwColors.blue,
          TwColors.indigo,
          TwColors.violet,
          TwColors.purple,
          TwColors.fuchsia,
          TwColors.pink,
          TwColors.rose,
        ];
        expect(families.length, 22);
      });

      test('each family has 11 shade getters', () {
        // Verify all 11 shades are accessible on a representative family
        final red = TwColors.red;
        expect(red.shade50, isA<Color>());
        expect(red.shade100, isA<Color>());
        expect(red.shade200, isA<Color>());
        expect(red.shade300, isA<Color>());
        expect(red.shade400, isA<Color>());
        expect(red.shade500, isA<Color>());
        expect(red.shade600, isA<Color>());
        expect(red.shade700, isA<Color>());
        expect(red.shade800, isA<Color>());
        expect(red.shade900, isA<Color>());
        expect(red.shade950, isA<Color>());
      });
    });

    group('semantic colors', () {
      test('black is Color(0xFF000000)', () {
        expect(TwColors.black, const Color(0xFF000000));
      });

      test('white is Color(0xFFFFFFFF)', () {
        expect(TwColors.white, const Color(0xFFFFFFFF));
      });

      test('transparent is Color(0x00000000)', () {
        expect(TwColors.transparent, const Color(0x00000000));
      });
    });

    group('alpha channel', () {
      test('all color family shades have 0xFF alpha (opaque)', () {
        // Spot check several families across all shades
        void verifyOpaque(TwColorFamily family, String name) {
          for (final shade in [
            family.shade50,
            family.shade100,
            family.shade200,
            family.shade300,
            family.shade400,
            family.shade500,
            family.shade600,
            family.shade700,
            family.shade800,
            family.shade900,
            family.shade950,
          ]) {
            expect(
              shade.a,
              1.0,
              reason: '$name shade should be fully opaque',
            );
          }
        }

        verifyOpaque(TwColors.red, 'red');
        verifyOpaque(TwColors.blue, 'blue');
        verifyOpaque(TwColors.green, 'green');
        verifyOpaque(TwColors.slate, 'slate');
        verifyOpaque(TwColors.purple, 'purple');
      });

      test('transparent has 0x00 alpha', () {
        expect(TwColors.transparent.a, 0.0);
      });
    });

    group('red family boundary values (Tailwind v4)', () {
      test('shade50 is #FEF2F2', () {
        expect(TwColors.red.shade50, const Color(0xFFFEF2F2));
      });
      test('shade100 is #FEE2E2', () {
        expect(TwColors.red.shade100, const Color(0xFFFEE2E2));
      });
      test('shade200 is #FECACA', () {
        expect(TwColors.red.shade200, const Color(0xFFFECACA));
      });
      test('shade300 is #FCA5A5', () {
        expect(TwColors.red.shade300, const Color(0xFFFCA5A5));
      });
      test('shade400 is #F87171', () {
        expect(TwColors.red.shade400, const Color(0xFFF87171));
      });
      test('shade500 is #FB2C36', () {
        expect(TwColors.red.shade500, const Color(0xFFFB2C36));
      });
      test('shade600 is #E7000B', () {
        expect(TwColors.red.shade600, const Color(0xFFE7000B));
      });
      test('shade700 is #C10007', () {
        expect(TwColors.red.shade700, const Color(0xFFC10007));
      });
      test('shade800 is #9F0712', () {
        expect(TwColors.red.shade800, const Color(0xFF9F0712));
      });
      test('shade900 is #7F1118', () {
        expect(TwColors.red.shade900, const Color(0xFF7F1118));
      });
      test('shade950 is #460809', () {
        expect(TwColors.red.shade950, const Color(0xFF460809));
      });
    });

    group('blue family boundary values (Tailwind v4)', () {
      test('shade50 is #EFF6FF', () {
        expect(TwColors.blue.shade50, const Color(0xFFEFF6FF));
      });
      test('shade500 is #2B7FFF', () {
        expect(TwColors.blue.shade500, const Color(0xFF2B7FFF));
      });
      test('shade950 is #162556', () {
        expect(TwColors.blue.shade950, const Color(0xFF162556));
      });
    });

    group('green family boundary values (Tailwind v4)', () {
      test('shade50 is #F0FDF4', () {
        expect(TwColors.green.shade50, const Color(0xFFF0FDF4));
      });
      test('shade500 is #00C950', () {
        expect(TwColors.green.shade500, const Color(0xFF00C950));
      });
      test('shade950 is #032E15', () {
        expect(TwColors.green.shade950, const Color(0xFF032E15));
      });
    });

    group('slate family boundary values (Tailwind v4)', () {
      test('shade50 is #F8FAFC', () {
        expect(TwColors.slate.shade50, const Color(0xFFF8FAFC));
      });
      test('shade500 is #62748E', () {
        expect(TwColors.slate.shade500, const Color(0xFF62748E));
      });
      test('shade950 is #020618', () {
        expect(TwColors.slate.shade950, const Color(0xFF020618));
      });
    });
  });
}
