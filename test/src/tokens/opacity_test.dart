import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  group('TwOpacity', () {
    test('o0 equals 0.0', () {
      expect(TwOpacity.o0, 0.0);
    });

    test('o5 equals 0.05', () {
      expect(TwOpacity.o5, 0.05);
    });

    test('o10 equals 0.1', () {
      expect(TwOpacity.o10, 0.1);
    });

    test('o15 equals 0.15', () {
      expect(TwOpacity.o15, 0.15);
    });

    test('o20 equals 0.2', () {
      expect(TwOpacity.o20, 0.2);
    });

    test('o25 equals 0.25', () {
      expect(TwOpacity.o25, 0.25);
    });

    test('o30 equals 0.3', () {
      expect(TwOpacity.o30, 0.3);
    });

    test('o35 equals 0.35', () {
      expect(TwOpacity.o35, 0.35);
    });

    test('o40 equals 0.4', () {
      expect(TwOpacity.o40, 0.4);
    });

    test('o45 equals 0.45', () {
      expect(TwOpacity.o45, 0.45);
    });

    test('o50 equals 0.5', () {
      expect(TwOpacity.o50, 0.5);
    });

    test('o55 equals 0.55', () {
      expect(TwOpacity.o55, 0.55);
    });

    test('o60 equals 0.6', () {
      expect(TwOpacity.o60, 0.6);
    });

    test('o65 equals 0.65', () {
      expect(TwOpacity.o65, 0.65);
    });

    test('o70 equals 0.7', () {
      expect(TwOpacity.o70, 0.7);
    });

    test('o75 equals 0.75', () {
      expect(TwOpacity.o75, 0.75);
    });

    test('o80 equals 0.8', () {
      expect(TwOpacity.o80, 0.8);
    });

    test('o85 equals 0.85', () {
      expect(TwOpacity.o85, 0.85);
    });

    test('o90 equals 0.9', () {
      expect(TwOpacity.o90, 0.9);
    });

    test('o95 equals 0.95', () {
      expect(TwOpacity.o95, 0.95);
    });

    test('o100 equals 1.0', () {
      expect(TwOpacity.o100, 1.0);
    });

    test('has exactly 21 values from o0 to o100 in steps of 5', () {
      final values = <double>[
        TwOpacity.o0,
        TwOpacity.o5,
        TwOpacity.o10,
        TwOpacity.o15,
        TwOpacity.o20,
        TwOpacity.o25,
        TwOpacity.o30,
        TwOpacity.o35,
        TwOpacity.o40,
        TwOpacity.o45,
        TwOpacity.o50,
        TwOpacity.o55,
        TwOpacity.o60,
        TwOpacity.o65,
        TwOpacity.o70,
        TwOpacity.o75,
        TwOpacity.o80,
        TwOpacity.o85,
        TwOpacity.o90,
        TwOpacity.o95,
        TwOpacity.o100,
      ];

      expect(values.length, 21);

      // Verify all values are monotonically increasing
      for (var i = 1; i < values.length; i++) {
        expect(
          values[i],
          greaterThan(values[i - 1]),
          reason: 'o${i * 5} should be greater than o${(i - 1) * 5}',
        );
      }

      // Verify range
      expect(values.first, 0.0);
      expect(values.last, 1.0);
    });

    test('all values are within valid opacity range [0.0, 1.0]', () {
      final values = <double>[
        TwOpacity.o0,
        TwOpacity.o5,
        TwOpacity.o10,
        TwOpacity.o15,
        TwOpacity.o20,
        TwOpacity.o25,
        TwOpacity.o30,
        TwOpacity.o35,
        TwOpacity.o40,
        TwOpacity.o45,
        TwOpacity.o50,
        TwOpacity.o55,
        TwOpacity.o60,
        TwOpacity.o65,
        TwOpacity.o70,
        TwOpacity.o75,
        TwOpacity.o80,
        TwOpacity.o85,
        TwOpacity.o90,
        TwOpacity.o95,
        TwOpacity.o100,
      ];

      for (final value in values) {
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThanOrEqualTo(1.0));
      }
    });
  });
}
