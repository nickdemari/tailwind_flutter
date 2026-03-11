import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/extensions/widget_extensions.dart';

void main() {
  group('TwWidgetExtensions', () {
    group('padding extensions', () {
      testWidgets('.p() wraps in Padding with EdgeInsets.all', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().p(16)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.all(16));
      });

      testWidgets('.px() wraps in Padding with horizontal symmetric',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().px(12)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.symmetric(horizontal: 12));
      });

      testWidgets('.py() wraps in Padding with vertical symmetric',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().py(8)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.symmetric(vertical: 8));
      });

      testWidgets('.pt() wraps in Padding with top only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().pt(24)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(top: 24));
      });

      testWidgets('.pb() wraps in Padding with bottom only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().pb(24)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(bottom: 24));
      });

      testWidgets('.pl() wraps in Padding with left only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().pl(10)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(left: 10));
      });

      testWidgets('.pr() wraps in Padding with right only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().pr(10)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(right: 10));
      });
    });

    group('margin extensions', () {
      testWidgets('.m() wraps in Padding with EdgeInsets.all',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().m(16)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.all(16));
      });

      testWidgets('.mx() wraps in Padding with horizontal symmetric',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().mx(12)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.symmetric(horizontal: 12));
      });

      testWidgets('.my() wraps in Padding with vertical symmetric',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().my(8)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.symmetric(vertical: 8));
      });

      testWidgets('.mt() wraps in Padding with top only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().mt(24)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(top: 24));
      });

      testWidgets('.mb() wraps in Padding with bottom only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().mb(24)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(bottom: 24));
      });

      testWidgets('.ml() wraps in Padding with left only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().ml(10)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(left: 10));
      });

      testWidgets('.mr() wraps in Padding with right only', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().mr(10)),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(right: 10));
      });
    });

    group('background extension', () {
      testWidgets('.bg() wraps in ColoredBox with specified color',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().bg(Colors.red)),
        );

        // Find the ColoredBox that is an ancestor of our SizedBox,
        // avoiding MaterialApp's internal ColoredBoxes.
        final coloredBox = tester.widget<ColoredBox>(
          find.ancestor(
            of: find.byType(SizedBox),
            matching: find.byType(ColoredBox),
          ).first,
        );
        expect(coloredBox.color, Colors.red);
      });
    });

    group('border radius extensions', () {
      testWidgets('.rounded() wraps in ClipRRect with circular radius',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().rounded(8)),
        );

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, BorderRadius.circular(8));
      });

      testWidgets('.roundedFull() wraps in ClipRRect with 9999 radius',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().roundedFull()),
        );

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, BorderRadius.circular(9999));
      });
    });

    group('opacity extension', () {
      testWidgets('.opacity() wraps in Opacity with specified value',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().opacity(0.5)),
        );

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
      });
    });

    group('shadow extension', () {
      testWidgets('.shadow() wraps in DecoratedBox with BoxDecoration',
          (tester) async {
        const shadows = [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().shadow(shadows)),
        );

        final decoratedBox =
            tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.boxShadow, shadows);
      });
    });

    group('sizing extensions', () {
      testWidgets('.width() wraps in SizedBox with specified width',
          (tester) async {
        // Use Placeholder instead of SizedBox to avoid shadowing --
        // SizedBox already has a `width` property that hides the extension.
        await tester.pumpWidget(
          MaterialApp(home: const Placeholder().width(100)),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 100);
      });

      testWidgets('.height() wraps in SizedBox with specified height',
          (tester) async {
        // Use Placeholder to avoid SizedBox.height shadowing the extension.
        await tester.pumpWidget(
          MaterialApp(home: const Placeholder().height(100)),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 100);
      });

      testWidgets('.size() wraps in SizedBox with width and height',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const Placeholder().size(100, 200)),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 100);
        expect(sizedBox.height, 200);
      });
    });

    group('alignment extensions', () {
      testWidgets('.center() wraps in Center', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().center()),
        );

        expect(find.byType(Center), findsOneWidget);
      });

      testWidgets('.align() wraps in Align with specified alignment',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().align(Alignment.topLeft)),
        );

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.topLeft);
      });
    });

    group('clip extensions', () {
      testWidgets('.clipRect() wraps in ClipRect', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().clipRect()),
        );

        expect(find.byType(ClipRect), findsOneWidget);
      });

      testWidgets('.clipOval() wraps in ClipOval', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().clipOval()),
        );

        expect(find.byType(ClipOval), findsOneWidget);
      });
    });

    group('chaining', () {
      testWidgets(
          'chained calls produce correct nesting (last call outermost)',
          (tester) async {
        // .p(8).bg(Colors.blue) should produce:
        // ColoredBox (outermost, from .bg() called last)
        //   -> Padding (innermost, from .p() called first)
        //     -> SizedBox (original child)
        await tester.pumpWidget(
          MaterialApp(home: const SizedBox().p(8).bg(Colors.blue)),
        );

        // Find our ColoredBox (the one wrapping a Padding, not
        // MaterialApp's internal ones).
        final coloredBox = tester.widget<ColoredBox>(
          find.ancestor(
            of: find.byType(Padding),
            matching: find.byType(ColoredBox),
          ).first,
        );
        expect(coloredBox.child, isA<Padding>());

        // Padding should be the parent of SizedBox
        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.child, isA<SizedBox>());
        expect(padding.padding, const EdgeInsets.all(8));
      });

      testWidgets('multi-level chaining preserves all wrappers',
          (tester) async {
        // .p(4).bg(Colors.red).rounded(8).opacity(0.5) should nest:
        // Opacity -> ClipRRect -> ColoredBox -> Padding -> SizedBox
        await tester.pumpWidget(
          MaterialApp(
            home: const SizedBox()
                .p(4)
                .bg(Colors.red)
                .rounded(8)
                .opacity(0.5),
          ),
        );

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
        expect(opacity.child, isA<ClipRRect>());

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, BorderRadius.circular(8));
        expect(clipRRect.child, isA<ColoredBox>());

        // Find the ColoredBox that is our extension wrapper (ancestor of
        // our SizedBox child, not MaterialApp internals).
        final coloredBox = tester.widget<ColoredBox>(
          find.ancestor(
            of: find.byType(SizedBox),
            matching: find.byType(ColoredBox),
          ).first,
        );
        expect(coloredBox.color, Colors.red);
        expect(coloredBox.child, isA<Padding>());

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.all(4));
        expect(padding.child, isA<SizedBox>());
      });
    });
  });
}
