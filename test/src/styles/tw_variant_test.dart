library;

/// Tests for [TwVariant] sealed class.
///
/// Covers brightness matching, const identity, and exhaustive switch.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  group('TwVariant', () {
    group('brightness matching', () {
      test('dark matches Brightness.dark', () {
        expect(TwVariant.dark.matches(Brightness.dark), isTrue);
      });

      test('dark does not match Brightness.light', () {
        expect(TwVariant.dark.matches(Brightness.light), isFalse);
      });

      test('light matches Brightness.light', () {
        expect(TwVariant.light.matches(Brightness.light), isTrue);
      });

      test('light does not match Brightness.dark', () {
        expect(TwVariant.light.matches(Brightness.dark), isFalse);
      });
    });

    group('const identity', () {
      test('dark is const (identical across references)', () {
        const a = TwVariant.dark;
        const b = TwVariant.dark;
        expect(identical(a, b), isTrue);
      });

      test('light is const (identical across references)', () {
        const a = TwVariant.light;
        const b = TwVariant.light;
        expect(identical(a, b), isTrue);
      });
    });

    test('exhaustive switch covers both cases without default', () {
      // This test verifies that the sealed class enables exhaustive switching.
      // If the switch is not exhaustive, the analyzer would produce a warning.
      String describe(TwVariant variant) {
        return switch (variant) {
          TwDarkVariant() => 'dark',
          TwLightVariant() => 'light',
        };
      }

      expect(describe(TwVariant.dark), equals('dark'));
      expect(describe(TwVariant.light), equals('light'));
    });
  });
}
