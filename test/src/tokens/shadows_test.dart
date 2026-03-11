import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/shadows.dart';

void main() {
  group('TwShadows', () {
    test('has 9 entries', () {
      final entries = <List<BoxShadow>>[
        TwShadows.xxs,
        TwShadows.xs,
        TwShadows.sm,
        TwShadows.md,
        TwShadows.lg,
        TwShadows.xl,
        TwShadows.xxl,
        TwShadows.inner,
        TwShadows.none,
      ];
      expect(entries.length, 9);
    });

    test('none is an empty list', () {
      expect(TwShadows.none, isEmpty);
      expect(TwShadows.none, isA<List<BoxShadow>>());
    });

    group('xxs (2xs)', () {
      test('has 1 shadow', () {
        expect(TwShadows.xxs.length, 1);
      });

      test('has correct values', () {
        final shadow = TwShadows.xxs.first;
        expect(shadow.offset, const Offset(0, 1));
        expect(shadow.blurRadius, 0);
        expect(shadow.spreadRadius, 0);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.05));
      });
    });

    group('xs', () {
      test('has 1 shadow', () {
        expect(TwShadows.xs.length, 1);
      });

      test('has correct values', () {
        final shadow = TwShadows.xs.first;
        expect(shadow.offset, const Offset(0, 1));
        expect(shadow.blurRadius, 2);
        expect(shadow.spreadRadius, 0);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.05));
      });
    });

    group('sm', () {
      test('has 2 shadows', () {
        expect(TwShadows.sm.length, 2);
      });

      test('first shadow has correct values', () {
        final shadow = TwShadows.sm[0];
        expect(shadow.offset, const Offset(0, 1));
        expect(shadow.blurRadius, 3);
        expect(shadow.spreadRadius, 0);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });

      test('second shadow has correct values', () {
        final shadow = TwShadows.sm[1];
        expect(shadow.offset, const Offset(0, 1));
        expect(shadow.blurRadius, 2);
        expect(shadow.spreadRadius, -1);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });
    });

    group('md', () {
      test('has 2 shadows', () {
        expect(TwShadows.md.length, 2);
      });

      test('first shadow has correct values', () {
        final shadow = TwShadows.md[0];
        expect(shadow.offset, const Offset(0, 4));
        expect(shadow.blurRadius, 6);
        expect(shadow.spreadRadius, -1);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });

      test('second shadow has correct values', () {
        final shadow = TwShadows.md[1];
        expect(shadow.offset, const Offset(0, 2));
        expect(shadow.blurRadius, 4);
        expect(shadow.spreadRadius, -2);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });
    });

    group('lg', () {
      test('has 2 shadows', () {
        expect(TwShadows.lg.length, 2);
      });

      test('first shadow has correct values', () {
        final shadow = TwShadows.lg[0];
        expect(shadow.offset, const Offset(0, 10));
        expect(shadow.blurRadius, 15);
        expect(shadow.spreadRadius, -3);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });

      test('second shadow has correct values', () {
        final shadow = TwShadows.lg[1];
        expect(shadow.offset, const Offset(0, 4));
        expect(shadow.blurRadius, 6);
        expect(shadow.spreadRadius, -4);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });
    });

    group('xl', () {
      test('has 2 shadows', () {
        expect(TwShadows.xl.length, 2);
      });

      test('first shadow has correct values', () {
        final shadow = TwShadows.xl[0];
        expect(shadow.offset, const Offset(0, 20));
        expect(shadow.blurRadius, 25);
        expect(shadow.spreadRadius, -5);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });

      test('second shadow has correct values', () {
        final shadow = TwShadows.xl[1];
        expect(shadow.offset, const Offset(0, 8));
        expect(shadow.blurRadius, 10);
        expect(shadow.spreadRadius, -6);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.1));
      });
    });

    group('xxl (2xl)', () {
      test('has 1 shadow', () {
        expect(TwShadows.xxl.length, 1);
      });

      test('has correct values', () {
        final shadow = TwShadows.xxl.first;
        expect(shadow.offset, const Offset(0, 25));
        expect(shadow.blurRadius, 50);
        expect(shadow.spreadRadius, -12);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.25));
      });
    });

    group('inner', () {
      test('has 1 shadow', () {
        expect(TwShadows.inner.length, 1);
      });

      test('has correct approximation values', () {
        // Flutter does not natively support inset shadows.
        // This is an inner shadow approximation.
        final shadow = TwShadows.inner.first;
        expect(shadow.offset, const Offset(0, 2));
        expect(shadow.blurRadius, 4);
        expect(shadow.spreadRadius, 0);
        expect(shadow.color, const Color.fromRGBO(0, 0, 0, 0.05));
      });
    });
  });
}
