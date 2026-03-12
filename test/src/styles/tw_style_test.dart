library;

/// Tests for [TwStyle] immutable data class.
///
/// Covers construction, equality, copyWith, and merge.

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  group('TwStyle', () {
    group('construction', () {
      test('no args creates style with all null properties', () {
        const style = TwStyle();
        expect(style.padding, isNull);
        expect(style.margin, isNull);
        expect(style.backgroundColor, isNull);
        expect(style.borderRadius, isNull);
        expect(style.shadows, isNull);
        expect(style.opacity, isNull);
        expect(style.constraints, isNull);
        expect(style.textStyle, isNull);
        expect(style.variants, isNull);
      });

      test('all 8 properties set retains each value', () {
        final style = TwStyle(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(4),
          shadows: const [BoxShadow(blurRadius: 2)],
          opacity: 0.5,
          constraints: const BoxConstraints(maxWidth: 200),
          textStyle: const TextStyle(fontSize: 14),
        );
        expect(style.padding, equals(const EdgeInsets.all(8)));
        expect(style.margin, equals(const EdgeInsets.all(16)));
        expect(style.backgroundColor, equals(const Color(0xFF000000)));
        expect(style.borderRadius, equals(BorderRadius.circular(4)));
        expect(style.shadows, equals(const [BoxShadow(blurRadius: 2)]));
        expect(style.opacity, equals(0.5));
        expect(
          style.constraints,
          equals(const BoxConstraints(maxWidth: 200)),
        );
        expect(style.textStyle, equals(const TextStyle(fontSize: 14)));
      });

      test('variants map retains variants', () {
        const darkOverride = TwStyle(
          backgroundColor: Color(0xFF111111),
        );
        const style = TwStyle(
          backgroundColor: Color(0xFFFFFFFF),
          variants: {
            TwVariant.dark: darkOverride,
          },
        );
        expect(style.variants, isNotNull);
        expect(style.variants!.length, equals(1));
        expect(style.variants![TwVariant.dark], equals(darkOverride));
      });
    });

    group('equality', () {
      test('two empty TwStyles are equal', () {
        const a = TwStyle();
        const b = TwStyle();
        expect(a, equals(b));
      });

      test('two TwStyles with identical properties are equal', () {
        final a = TwStyle(
          padding: const EdgeInsets.all(8),
          backgroundColor: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(4),
          shadows: const [BoxShadow(blurRadius: 2)],
          opacity: 0.5,
        );
        final b = TwStyle(
          padding: const EdgeInsets.all(8),
          backgroundColor: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(4),
          shadows: const [BoxShadow(blurRadius: 2)],
          opacity: 0.5,
        );
        expect(a, equals(b));
      });

      test('two TwStyles with different backgroundColor are not equal', () {
        const a = TwStyle(backgroundColor: Color(0xFF000000));
        const b = TwStyle(backgroundColor: Color(0xFFFFFFFF));
        expect(a, isNot(equals(b)));
      });

      test('identical shadow lists (different List instances) are equal', () {
        final shadowsA = [
          const BoxShadow(blurRadius: 2, color: Color(0x33000000)),
        ];
        final shadowsB = [
          const BoxShadow(blurRadius: 2, color: Color(0x33000000)),
        ];
        // Prove they're different list instances.
        expect(identical(shadowsA, shadowsB), isFalse);
        final a = TwStyle(shadows: shadowsA);
        final b = TwStyle(shadows: shadowsB);
        expect(a, equals(b));
      });

      test('hashCode is consistent with equality', () {
        final a = TwStyle(
          padding: const EdgeInsets.all(8),
          shadows: const [BoxShadow(blurRadius: 2)],
          borderRadius: BorderRadius.circular(4),
        );
        final b = TwStyle(
          padding: const EdgeInsets.all(8),
          shadows: const [BoxShadow(blurRadius: 2)],
          borderRadius: BorderRadius.circular(4),
        );
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('copyWith', () {
      test('no args returns equal but not identical instance', () {
        const original = TwStyle(
          padding: EdgeInsets.all(8),
          backgroundColor: Color(0xFF000000),
        );
        final copied = original.copyWith();
        expect(copied, equals(original));
        expect(identical(copied, original), isFalse);
      });

      test('backgroundColor changes only backgroundColor', () {
        const original = TwStyle(
          padding: EdgeInsets.all(8),
          backgroundColor: Color(0xFF000000),
        );
        final updated = original.copyWith(
          backgroundColor: const Color(0xFFFF0000),
        );
        expect(updated.backgroundColor, equals(const Color(0xFFFF0000)));
        expect(updated.padding, equals(const EdgeInsets.all(8)));
      });

      test('preserves unspecified properties', () {
        final original = TwStyle(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(4),
          shadows: const [BoxShadow(blurRadius: 2)],
          opacity: 0.5,
          constraints: const BoxConstraints(maxWidth: 200),
          textStyle: const TextStyle(fontSize: 14),
        );
        final updated = original.copyWith(opacity: 0.9);
        expect(updated.padding, equals(original.padding));
        expect(updated.margin, equals(original.margin));
        expect(updated.backgroundColor, equals(original.backgroundColor));
        expect(updated.borderRadius, equals(original.borderRadius));
        expect(updated.shadows, equals(original.shadows));
        expect(updated.opacity, equals(0.9));
        expect(updated.constraints, equals(original.constraints));
        expect(updated.textStyle, equals(original.textStyle));
      });
    });

    group('merge', () {
      test('with empty style returns equivalent of original', () {
        const original = TwStyle(
          padding: EdgeInsets.all(8),
          backgroundColor: Color(0xFF000000),
        );
        final merged = original.merge(const TwStyle());
        expect(merged.padding, equals(original.padding));
        expect(merged.backgroundColor, equals(original.backgroundColor));
      });

      test('with fully specified other returns other values', () {
        const base = TwStyle(
          padding: EdgeInsets.all(8),
          backgroundColor: Color(0xFF000000),
        );
        const other = TwStyle(
          padding: EdgeInsets.all(16),
          backgroundColor: Color(0xFFFFFFFF),
          opacity: 0.5,
        );
        final merged = base.merge(other);
        expect(merged.padding, equals(const EdgeInsets.all(16)));
        expect(merged.backgroundColor, equals(const Color(0xFFFFFFFF)));
        expect(merged.opacity, equals(0.5));
      });

      test('partially specified other overrides only those properties', () {
        const base = TwStyle(
          padding: EdgeInsets.all(8),
          backgroundColor: Color(0xFF000000),
          opacity: 0.5,
        );
        const other = TwStyle(
          backgroundColor: Color(0xFFFF0000),
        );
        final merged = base.merge(other);
        // Right-side wins for backgroundColor.
        expect(merged.backgroundColor, equals(const Color(0xFFFF0000)));
        // Left-side preserved for padding and opacity.
        expect(merged.padding, equals(const EdgeInsets.all(8)));
        expect(merged.opacity, equals(0.5));
      });

      test('null properties in right-side are ignored', () {
        const base = TwStyle(
          padding: EdgeInsets.all(8),
          backgroundColor: Color(0xFF000000),
        );
        const other = TwStyle(
          padding: EdgeInsets.all(16),
          // backgroundColor is null -- should preserve left-side.
        );
        final merged = base.merge(other);
        expect(merged.padding, equals(const EdgeInsets.all(16)));
        expect(merged.backgroundColor, equals(const Color(0xFF000000)));
      });

      test('does NOT carry over variants from either side', () {
        const base = TwStyle(
          backgroundColor: Color(0xFFFFFFFF),
          variants: {
            TwVariant.dark: TwStyle(backgroundColor: Color(0xFF111111)),
          },
        );
        const other = TwStyle(
          opacity: 0.5,
          variants: {
            TwVariant.light: TwStyle(backgroundColor: Color(0xFFEEEEEE)),
          },
        );
        final merged = base.merge(other);
        expect(merged.variants, isNull);
      });
    });
  });
}
