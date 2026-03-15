// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Benchmark: build 1000 styled widgets via each approach and compare timing
  // ---------------------------------------------------------------------------

  group('Build-time benchmarks (1000 iterations)', () {
    testWidgets('chained extensions', (tester) async {
      final sw = Stopwatch()..start();

      for (var i = 0; i < 1000; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: const Text('Hello')
                .p(TwSpacing.s4)
                .bg(TwColors.blue.shade100)
                .rounded(TwRadii.lg)
                .shadow(TwShadows.md)
                .m(TwSpacing.s3),
          ),
        );
      }

      sw.stop();
      print('Chained extensions: ${sw.elapsedMilliseconds}ms (1000 pumps)');
    });

    testWidgets('manual nesting (equivalent widgets)', (tester) async {
      final sw = Stopwatch()..start();

      for (var i = 0; i < 1000; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Padding(
              padding: const EdgeInsets.all(12), // margin
              child: DecoratedBox(
                decoration: const BoxDecoration(boxShadow: TwShadows.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TwRadii.lg),
                  child: ColoredBox(
                    color: TwColors.blue.shade100,
                    child: const Padding(
                      padding: EdgeInsets.all(16), // inner padding
                      child: Text('Hello'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      sw.stop();
      print('Manual nesting:     ${sw.elapsedMilliseconds}ms (1000 pumps)');
    });

    testWidgets('single Container', (tester) async {
      final sw = Stopwatch()..start();

      for (var i = 0; i < 1000; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TwColors.blue.shade100,
                borderRadius: BorderRadius.circular(TwRadii.lg),
                boxShadow: TwShadows.md,
              ),
              child: const Text('Hello'),
            ),
          ),
        );
      }

      sw.stop();
      print('Single Container:   ${sw.elapsedMilliseconds}ms (1000 pumps)');
    });

    testWidgets('TwStyle.apply() (consolidated DecoratedBox)', (tester) async {
      final style = TwStyle(
        padding: TwSpacing.s4.all,
        margin: TwSpacing.s3.all,
        backgroundColor: TwColors.blue.shade100,
        borderRadius: TwRadii.lg.all,
        shadows: TwShadows.md,
      );

      final sw = Stopwatch()..start();

      for (var i = 0; i < 1000; i++) {
        await tester.pumpWidget(
          MaterialApp(home: style.apply(child: const Text('Hello'))),
        );
      }

      sw.stop();
      print('TwStyle.apply():    ${sw.elapsedMilliseconds}ms (1000 pumps)');
    });
  });

  // ---------------------------------------------------------------------------
  // Element tree depth comparison
  // ---------------------------------------------------------------------------

  group('Element tree depth comparison', () {
    /// Walk the element tree and return the maximum depth from [root].
    int treeDepth(Element root) {
      var maxDepth = 0;

      void visit(Element element, int depth) {
        if (depth > maxDepth) maxDepth = depth;
        element.visitChildren((child) => visit(child, depth + 1));
      }

      visit(root, 0);
      return maxDepth;
    }

    testWidgets(
      'chained extensions produce same depth as manual nesting',
      (tester) async {
        // -- Chained extensions --
        await tester.pumpWidget(
          MaterialApp(
            home: const Text('A')
                .p(TwSpacing.s4)
                .bg(TwColors.blue.shade100)
                .rounded(TwRadii.lg)
                .shadow(TwShadows.md)
                .m(TwSpacing.s3),
          ),
        );

        // Measure depth starting from the outermost Padding (margin).
        // The outermost widget produced by the chain is a Padding (from .m()).
        final chainedPaddings =
            tester.elementList(find.byType(Padding)).toList();
        // The outermost Padding that is NOT from MaterialApp scaffolding is the
        // margin Padding. We find the first Padding whose padding == all(12).
        final chainedMargin = chainedPaddings.firstWhere((el) {
          final widget = el.widget;
          return widget is Padding &&
              widget.padding == const EdgeInsets.all(12);
        });
        final chainedDepth = treeDepth(chainedMargin);

        // -- Manual nesting (identical widget structure) --
        await tester.pumpWidget(
          MaterialApp(
            home: Padding(
              padding: const EdgeInsets.all(12),
              child: DecoratedBox(
                decoration: const BoxDecoration(boxShadow: TwShadows.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TwRadii.lg),
                  child: ColoredBox(
                    color: TwColors.blue.shade100,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('A'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final manualPaddings =
            tester.elementList(find.byType(Padding)).toList();
        final manualMargin = manualPaddings.firstWhere((el) {
          final widget = el.widget;
          return widget is Padding &&
              widget.padding == const EdgeInsets.all(12);
        });
        final manualDepth = treeDepth(manualMargin);

        print('Chained extension tree depth: $chainedDepth');
        print('Manual nesting tree depth:    $manualDepth');

        expect(
          chainedDepth,
          equals(manualDepth),
          reason: 'Chained extensions should produce the exact same '
              'widget tree depth as manual nesting',
        );
      },
    );

    testWidgets(
      'chained extensions produce identical widget types as manual nesting',
      (tester) async {
        // -- Chained extensions --
        await tester.pumpWidget(
          MaterialApp(
            home: const Text('B')
                .p(TwSpacing.s4)
                .bg(TwColors.blue.shade100)
                .rounded(TwRadii.lg)
                .shadow(TwShadows.md)
                .m(TwSpacing.s3),
          ),
        );

        List<Type> collectTypes(Element root) {
          final types = <Type>[];
          void visit(Element element) {
            types.add(element.widget.runtimeType);
            element.visitChildren(visit);
          }
          visit(root);
          return types;
        }

        final chainedPaddings =
            tester.elementList(find.byType(Padding)).toList();
        final chainedRoot = chainedPaddings.firstWhere((el) {
          final widget = el.widget;
          return widget is Padding &&
              widget.padding == const EdgeInsets.all(12);
        });
        final chainedTypes = collectTypes(chainedRoot);

        // -- Manual nesting --
        await tester.pumpWidget(
          MaterialApp(
            home: Padding(
              padding: const EdgeInsets.all(12),
              child: DecoratedBox(
                decoration: const BoxDecoration(boxShadow: TwShadows.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TwRadii.lg),
                  child: ColoredBox(
                    color: TwColors.blue.shade100,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('B'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final manualPaddings =
            tester.elementList(find.byType(Padding)).toList();
        final manualRoot = manualPaddings.firstWhere((el) {
          final widget = el.widget;
          return widget is Padding &&
              widget.padding == const EdgeInsets.all(12);
        });
        final manualTypes = collectTypes(manualRoot);

        print('Chained types: $chainedTypes');
        print('Manual types:  $manualTypes');

        expect(
          chainedTypes,
          equals(manualTypes),
          reason: 'Chained extensions should produce the exact same '
              'widget type sequence as manual nesting',
        );
      },
    );
  });
}
