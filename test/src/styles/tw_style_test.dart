library;

/// Tests for [TwStyle] immutable data class.
///
/// Covers construction, equality, copyWith, merge, apply, and resolve.

import 'package:flutter/material.dart';
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

    group('apply', () {
      testWidgets(
        'all properties set produces correct widget tree order',
        (tester) async {
          final style = TwStyle(
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 200),
            opacity: 0.8,
            backgroundColor: const Color(0xFFFF0000),
            borderRadius: BorderRadius.circular(8),
            shadows: const [BoxShadow(blurRadius: 4)],
            padding: const EdgeInsets.all(8),
            textStyle: const TextStyle(fontSize: 14),
          );

          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          // Navigate the widget tree from the child outward to verify order.
          // The tree should be:
          //   Padding(margin) > ConstrainedBox > Opacity > DecoratedBox >
          //   Padding(padding) > DefaultTextStyle > child

          // DefaultTextStyle is the nearest ancestor of the child
          final defaultTS = tester.widget<DefaultTextStyle>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(DefaultTextStyle),
            ).first,
          );
          expect(defaultTS.style.fontSize, 14);

          // Inner Padding wraps DefaultTextStyle
          final innerPadding = tester.widget<Padding>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(Padding),
            ).first,
          );
          expect(innerPadding.padding, const EdgeInsets.all(8));

          // DecoratedBox wraps inner Padding
          final decoratedBox = tester.widget<DecoratedBox>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(DecoratedBox),
            ).first,
          );
          final decoration = decoratedBox.decoration as BoxDecoration;
          expect(decoration.color, const Color(0xFFFF0000));
          expect(decoration.borderRadius, BorderRadius.circular(8));
          expect(decoration.boxShadow, const [BoxShadow(blurRadius: 4)]);

          // Opacity wraps DecoratedBox
          final opacity = tester.widget<Opacity>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(Opacity),
            ).first,
          );
          expect(opacity.opacity, 0.8);

          // ConstrainedBox wraps Opacity
          final constrained = tester.widget<ConstrainedBox>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(ConstrainedBox),
            ).first,
          );
          expect(
            constrained.constraints,
            const BoxConstraints(maxWidth: 200),
          );

          // Outermost margin Padding wraps ConstrainedBox.
          // Find all Padding ancestors of the child, the outermost
          // relevant one should have margin value.
          final marginPaddings = find.ancestor(
            of: find.byKey(const Key('child')),
            matching: find.byType(Padding),
          );
          // The last Padding ancestor (before MaterialApp internals)
          // should be the margin. Check that one of them has margin=16.
          final allPaddings = tester
              .widgetList<Padding>(marginPaddings)
              .toList();
          final marginPadding = allPaddings.firstWhere(
            (p) => p.padding == const EdgeInsets.all(16),
          );
          expect(marginPadding.padding, const EdgeInsets.all(16));
        },
      );

      testWidgets(
        'only padding wraps child in single Padding widget',
        (tester) async {
          const style = TwStyle(padding: EdgeInsets.all(12));
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          // Should find Padding wrapping the child
          final padding = tester.widget<Padding>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(Padding),
            ).first,
          );
          expect(padding.padding, const EdgeInsets.all(12));

          // Should NOT find DecoratedBox, Opacity, ConstrainedBox
          // (skipping MaterialApp internals -- check only our ancestors)
          expect(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(Opacity),
            ),
            findsNothing,
          );
          expect(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(ConstrainedBox),
            ),
            findsNothing,
          );
        },
      );

      testWidgets(
        'only backgroundColor wraps child in DecoratedBox',
        (tester) async {
          const style = TwStyle(backgroundColor: Color(0xFF00FF00));
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          final decoratedBox = tester.widget<DecoratedBox>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(DecoratedBox),
            ).first,
          );
          final decoration = decoratedBox.decoration as BoxDecoration;
          expect(decoration.color, const Color(0xFF00FF00));
        },
      );

      testWidgets(
        'bg + borderRadius + shadows produce single DecoratedBox',
        (tester) async {
          final style = TwStyle(
            backgroundColor: const Color(0xFF0000FF),
            borderRadius: BorderRadius.circular(12),
            shadows: const [BoxShadow(blurRadius: 6, color: Color(0x33000000))],
          );
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          // Only one DecoratedBox wrapping the child
          final decoratedBoxes = find.ancestor(
            of: find.byKey(const Key('child')),
            matching: find.byType(DecoratedBox),
          );
          expect(decoratedBoxes, findsOneWidget);

          final decoration = (tester.widget<DecoratedBox>(decoratedBoxes.first)
                  .decoration) as BoxDecoration;
          expect(decoration.color, const Color(0xFF0000FF));
          expect(decoration.borderRadius, BorderRadius.circular(12));
          expect(
            decoration.boxShadow,
            const [BoxShadow(blurRadius: 6, color: Color(0x33000000))],
          );
        },
      );

      testWidgets(
        'empty style (all null) returns child unchanged',
        (tester) async {
          const style = TwStyle();
          final child = const SizedBox(key: Key('child'));
          final result = style.apply(child: child);
          // Should be the exact same widget instance
          expect(identical(result, child), isTrue);
        },
      );

      testWidgets(
        'skips Opacity widget when opacity is null',
        (tester) async {
          const style = TwStyle(padding: EdgeInsets.all(8));
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          expect(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(Opacity),
            ),
            findsNothing,
          );
        },
      );

      testWidgets(
        'skips ConstrainedBox when constraints is null',
        (tester) async {
          const style = TwStyle(padding: EdgeInsets.all(8));
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          expect(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(ConstrainedBox),
            ),
            findsNothing,
          );
        },
      );

      testWidgets(
        'skips margin Padding when margin is null',
        (tester) async {
          const style = TwStyle(padding: EdgeInsets.all(8));
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          // Only one Padding (inner), not two
          final paddings = find.ancestor(
            of: find.byKey(const Key('child')),
            matching: find.byType(Padding),
          );
          expect(paddings, findsOneWidget);
        },
      );

      testWidgets(
        'textStyle uses DefaultTextStyle.merge (inherits, not replaces)',
        (tester) async {
          const style = TwStyle(textStyle: TextStyle(fontSize: 20));
          final child = const Text('hello', key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(
              home: DefaultTextStyle(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
                child: style.apply(child: child),
              ),
            ),
          );

          // The DefaultTextStyle created by apply() should merge with
          // the parent, so both fontSize and fontWeight should be present.
          final defaultTextStyle = tester.widget<DefaultTextStyle>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(DefaultTextStyle),
            ).first,
          );
          expect(defaultTextStyle.style.fontSize, 20);
          // fontWeight should be inherited from the parent.
          expect(defaultTextStyle.style.fontWeight, FontWeight.bold);
        },
      );

      testWidgets(
        'style with unresolved variants uses base properties only',
        (tester) async {
          const style = TwStyle(
            padding: EdgeInsets.all(8),
            backgroundColor: Color(0xFFFFFFFF),
            variants: {
              TwVariant.dark: TwStyle(
                backgroundColor: Color(0xFF000000),
                padding: EdgeInsets.all(16),
              ),
            },
          );
          final child = const SizedBox(key: Key('child'));
          await tester.pumpWidget(
            MaterialApp(home: style.apply(child: child)),
          );

          // Should use base backgroundColor (white), not dark variant (black)
          final decoratedBox = tester.widget<DecoratedBox>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(DecoratedBox),
            ).first,
          );
          final decoration = decoratedBox.decoration as BoxDecoration;
          expect(decoration.color, const Color(0xFFFFFFFF));

          // Should use base padding (8), not dark variant (16)
          final padding = tester.widget<Padding>(
            find.ancestor(
              of: find.byKey(const Key('child')),
              matching: find.byType(Padding),
            ).first,
          );
          expect(padding.padding, const EdgeInsets.all(8));
        },
      );
    });

    group('resolve', () {
      testWidgets(
        'in dark mode returns base merged with dark variant',
        (tester) async {
          const style = TwStyle(
            backgroundColor: Color(0xFFFFFFFF),
            padding: EdgeInsets.all(8),
            variants: {
              TwVariant.dark: TwStyle(
                backgroundColor: Color(0xFF000000),
              ),
            },
          );

          late TwStyle resolved;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: Brightness.dark),
              home: Builder(
                builder: (context) {
                  resolved = style.resolve(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          // Dark variant overrides backgroundColor
          expect(resolved.backgroundColor, const Color(0xFF000000));
          // Base padding preserved (dark variant has null padding)
          expect(resolved.padding, const EdgeInsets.all(8));
        },
      );

      testWidgets(
        'in light mode returns base merged with light variant',
        (tester) async {
          const style = TwStyle(
            backgroundColor: Color(0xFF000000),
            padding: EdgeInsets.all(8),
            variants: {
              TwVariant.light: TwStyle(
                backgroundColor: Color(0xFFFFFFFF),
              ),
            },
          );

          late TwStyle resolved;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: Brightness.light),
              home: Builder(
                builder: (context) {
                  resolved = style.resolve(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          expect(resolved.backgroundColor, const Color(0xFFFFFFFF));
          expect(resolved.padding, const EdgeInsets.all(8));
        },
      );

      testWidgets(
        'returns base without variants when no variant matches',
        (tester) async {
          const style = TwStyle(
            backgroundColor: Color(0xFFFFFFFF),
            padding: EdgeInsets.all(8),
            variants: {
              TwVariant.dark: TwStyle(
                backgroundColor: Color(0xFF000000),
              ),
            },
          );

          late TwStyle resolved;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: Brightness.light),
              home: Builder(
                builder: (context) {
                  resolved = style.resolve(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          // Base properties preserved, no dark override applied
          expect(resolved.backgroundColor, const Color(0xFFFFFFFF));
          expect(resolved.padding, const EdgeInsets.all(8));
        },
      );

      testWidgets(
        'with no variants map returns self (no-op)',
        (tester) async {
          const style = TwStyle(
            backgroundColor: Color(0xFFAAAAAA),
            padding: EdgeInsets.all(4),
          );

          late TwStyle resolved;
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  resolved = style.resolve(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          // Should return self when no variants
          expect(identical(resolved, style), isTrue);
        },
      );

      testWidgets(
        'resolved style has no variants (variants stripped)',
        (tester) async {
          const style = TwStyle(
            backgroundColor: Color(0xFFFFFFFF),
            variants: {
              TwVariant.dark: TwStyle(backgroundColor: Color(0xFF000000)),
            },
          );

          late TwStyle resolved;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: Brightness.dark),
              home: Builder(
                builder: (context) {
                  resolved = style.resolve(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          expect(resolved.variants, isNull);
        },
      );

      testWidgets(
        'merges variant over base (variant overrides, base fills gaps)',
        (tester) async {
          const style = TwStyle(
            backgroundColor: Color(0xFFFFFFFF),
            padding: EdgeInsets.all(8),
            opacity: 0.9,
            textStyle: TextStyle(fontSize: 16),
            variants: {
              TwVariant.dark: TwStyle(
                backgroundColor: Color(0xFF111111),
                opacity: 0.7,
                // padding and textStyle are null in variant -- base values kept
              ),
            },
          );

          late TwStyle resolved;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: Brightness.dark),
              home: Builder(
                builder: (context) {
                  resolved = style.resolve(context);
                  return const SizedBox();
                },
              ),
            ),
          );

          // Variant overrides
          expect(resolved.backgroundColor, const Color(0xFF111111));
          expect(resolved.opacity, 0.7);
          // Base fills gaps
          expect(resolved.padding, const EdgeInsets.all(8));
          expect(resolved.textStyle, const TextStyle(fontSize: 16));
          // No variants in resolved style
          expect(resolved.variants, isNull);
        },
      );
    });
  });
}
