import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  group('TwBreakpoints', () {
    test('sm equals 640.0', () {
      expect(TwBreakpoints.sm, 640.0);
    });

    test('md equals 768.0', () {
      expect(TwBreakpoints.md, 768.0);
    });

    test('lg equals 1024.0', () {
      expect(TwBreakpoints.lg, 1024.0);
    });

    test('xl equals 1280.0', () {
      expect(TwBreakpoints.xl, 1280.0);
    });

    test('xxl equals 1536.0', () {
      expect(TwBreakpoints.xxl, 1536.0);
    });

    test('has exactly 5 breakpoints in ascending order', () {
      final values = <double>[
        TwBreakpoints.sm,
        TwBreakpoints.md,
        TwBreakpoints.lg,
        TwBreakpoints.xl,
        TwBreakpoints.xxl,
      ];

      expect(values.length, 5);

      // Verify ascending order
      for (var i = 1; i < values.length; i++) {
        expect(
          values[i],
          greaterThan(values[i - 1]),
          reason: 'breakpoints should be in ascending order',
        );
      }
    });

    test('all breakpoint values are positive pixel values', () {
      final values = <double>[
        TwBreakpoints.sm,
        TwBreakpoints.md,
        TwBreakpoints.lg,
        TwBreakpoints.xl,
        TwBreakpoints.xxl,
      ];

      for (final value in values) {
        expect(value, greaterThan(0.0));
      }
    });
  });
}
