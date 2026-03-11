import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/radius.dart';

void main() {
  group('TwRadii', () {
    test('has 10 entries', () {
      final entries = <TwRadius>[
        TwRadii.none,
        TwRadii.xs,
        TwRadii.sm,
        TwRadii.md,
        TwRadii.lg,
        TwRadii.xl,
        TwRadii.xl2,
        TwRadii.xl3,
        TwRadii.xl4,
        TwRadii.full,
      ];
      expect(entries.length, 10);
    });

    test('none == 0.0', () {
      expect(TwRadii.none, 0.0);
    });

    test('xs == 2.0', () {
      expect(TwRadii.xs, 2.0);
    });

    test('sm == 4.0', () {
      expect(TwRadii.sm, 4.0);
    });

    test('md == 6.0', () {
      expect(TwRadii.md, 6.0);
    });

    test('lg == 8.0', () {
      expect(TwRadii.lg, 8.0);
    });

    test('xl == 12.0', () {
      expect(TwRadii.xl, 12.0);
    });

    test('xl2 == 16.0', () {
      expect(TwRadii.xl2, 16.0);
    });

    test('xl3 == 24.0', () {
      expect(TwRadii.xl3, 24.0);
    });

    test('xl4 == 32.0', () {
      expect(TwRadii.xl4, 32.0);
    });

    test('full == 9999.0', () {
      expect(TwRadii.full, 9999.0);
    });
  });

  group('TwRadius implements double', () {
    test('TwRadii.lg can be used as a double', () {
      // ignore: avoid_redundant_argument_values
      final double value = TwRadii.lg;
      expect(value, 8.0);
    });

    test('TwRadii.lg can be used in arithmetic', () {
      final result = TwRadii.lg + 2.0;
      expect(result, 10.0);
    });
  });

  group('TwRadius BorderRadius getters', () {
    test('.all returns BorderRadius.circular with the radius value', () {
      expect(TwRadii.lg.all, BorderRadius.circular(8));
    });

    test('.top returns BorderRadius with only top corners', () {
      final br = TwRadii.lg.top;
      expect(br.topLeft, const Radius.circular(8));
      expect(br.topRight, const Radius.circular(8));
      expect(br.bottomLeft, Radius.zero);
      expect(br.bottomRight, Radius.zero);
    });

    test('.bottom returns BorderRadius with only bottom corners', () {
      final br = TwRadii.lg.bottom;
      expect(br.topLeft, Radius.zero);
      expect(br.topRight, Radius.zero);
      expect(br.bottomLeft, const Radius.circular(8));
      expect(br.bottomRight, const Radius.circular(8));
    });

    test('.left returns BorderRadius with only left corners', () {
      final br = TwRadii.lg.left;
      expect(br.topLeft, const Radius.circular(8));
      expect(br.topRight, Radius.zero);
      expect(br.bottomLeft, const Radius.circular(8));
      expect(br.bottomRight, Radius.zero);
    });

    test('.right returns BorderRadius with only right corners', () {
      final br = TwRadii.lg.right;
      expect(br.topLeft, Radius.zero);
      expect(br.topRight, const Radius.circular(8));
      expect(br.bottomLeft, Radius.zero);
      expect(br.bottomRight, const Radius.circular(8));
    });

    test('.all works with none (zero radius)', () {
      expect(TwRadii.none.all, BorderRadius.zero);
    });

    test('.all works with full (9999)', () {
      expect(TwRadii.full.all, BorderRadius.circular(9999));
    });
  });
}
