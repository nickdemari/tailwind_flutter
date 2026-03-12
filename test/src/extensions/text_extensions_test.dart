import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/extensions/text_extensions.dart';
import 'package:tailwind_flutter/src/tokens/typography.dart';

void main() {
  group('TwTextExtensions', () {
    group('style extensions', () {
      testWidgets('.bold() sets fontWeight to bold', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').bold()),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontWeight, FontWeight.bold);
        expect(text.data, 'Hello');
      });

      testWidgets('.italic() sets fontStyle to italic', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').italic()),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontStyle, FontStyle.italic);
        expect(text.data, 'Hello');
      });

      testWidgets('.fontSize(18) sets fontSize to 18', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').fontSize(18)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 18);
        expect(text.data, 'Hello');
      });

      testWidgets('.fontSize(TwFontSize) sets fontSize and lineHeight',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').fontSize(TwFontSizes.lg)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 18);
        expect(text.style?.height, closeTo(1.5556, 0.001));
        expect(text.data, 'Hello');
      });

      testWidgets('.fontSize(TwFontSize) lineHeight can be overridden',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text('Hello').fontSize(TwFontSizes.lg).lineHeight(2.0),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 18);
        expect(text.style?.height, 2.0);
      });

      testWidgets('.textColor(Colors.red) sets color to red', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').textColor(Colors.red)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, Colors.red);
        expect(text.data, 'Hello');
      });

      testWidgets('.letterSpacing(1.5) sets letterSpacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').letterSpacing(1.5)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.letterSpacing, 1.5);
        expect(text.data, 'Hello');
      });

      testWidgets('.lineHeight(1.5) sets height to 1.5', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').lineHeight(1.5)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.height, 1.5);
        expect(text.data, 'Hello');
      });

      testWidgets('.fontWeight(w300) sets fontWeight to w300', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Text('Hello').fontWeight(FontWeight.w300)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontWeight, FontWeight.w300);
        expect(text.data, 'Hello');
      });

      testWidgets('.textStyle() merges provided style into existing',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hello',
              style: const TextStyle(color: Colors.red),
            ).textStyle(const TextStyle(fontSize: 20, color: Colors.blue)),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        // .merge means the incoming style wins for overlapping properties
        expect(text.style?.fontSize, 20);
        expect(text.style?.color, Colors.blue);
      });

      testWidgets('.textStyle() preserves non-overlapping existing properties',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hello',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ).textStyle(const TextStyle(fontSize: 20)),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 20);
        expect(text.style?.color, Colors.red);
        expect(text.style?.fontWeight, FontWeight.bold);
      });
    });

    group('parameter preservation', () {
      testWidgets('.bold() preserves all Text constructor parameters',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hello',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
              semanticsLabel: 'greeting',
              selectionColor: Colors.green,
              textDirection: TextDirection.rtl,
              textWidthBasis: TextWidthBasis.longestLine,
            ).bold(),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontWeight, FontWeight.bold);
        expect(text.maxLines, 2);
        expect(text.overflow, TextOverflow.ellipsis);
        expect(text.textAlign, TextAlign.center);
        expect(text.softWrap, false);
        expect(text.semanticsLabel, 'greeting');
        expect(text.selectionColor, Colors.green);
        expect(text.textDirection, TextDirection.rtl);
        expect(text.textWidthBasis, TextWidthBasis.longestLine);
        expect(text.data, 'Hello');
      });

      testWidgets('.fontSize() preserves textScaler', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hello',
              textScaler: const TextScaler.linear(2),
            ).fontSize(24),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 24);
        expect(text.textScaler, const TextScaler.linear(2));
      });

      testWidgets('.italic() preserves locale and strutStyle',
          (tester) async {
        const strut = StrutStyle(fontSize: 14, leading: 0.5);
        const locale = Locale('es', 'ES');
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hello',
              strutStyle: strut,
              locale: locale,
            ).italic(),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontStyle, FontStyle.italic);
        expect(text.strutStyle, strut);
        expect(text.locale, locale);
      });
    });

    group('style merging', () {
      testWidgets('preserves existing style when adding new properties',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hi',
              style: const TextStyle(color: Colors.red),
            ).bold(),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, Colors.red);
        expect(text.style?.fontWeight, FontWeight.bold);
      });

      testWidgets('preserves existing fontSize when setting color',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text(
              'Hi',
              style: const TextStyle(fontSize: 24),
            ).textColor(Colors.blue),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 24);
        expect(text.style?.color, Colors.blue);
      });
    });

    group('chaining', () {
      testWidgets('.bold().italic().fontSize(18) combines all styles',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text('Hello').bold().italic().fontSize(18),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontWeight, FontWeight.bold);
        expect(text.style?.fontStyle, FontStyle.italic);
        expect(text.style?.fontSize, 18);
        expect(text.data, 'Hello');
      });

      testWidgets('full chain preserves all properties', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Text('Hello', maxLines: 1)
                .bold()
                .italic()
                .fontSize(18)
                .textColor(Colors.red)
                .letterSpacing(1.5)
                .lineHeight(1.2),
          ),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontWeight, FontWeight.bold);
        expect(text.style?.fontStyle, FontStyle.italic);
        expect(text.style?.fontSize, 18);
        expect(text.style?.color, Colors.red);
        expect(text.style?.letterSpacing, 1.5);
        expect(text.style?.height, 1.2);
        expect(text.maxLines, 1);
        expect(text.data, 'Hello');
      });
    });
  });
}
