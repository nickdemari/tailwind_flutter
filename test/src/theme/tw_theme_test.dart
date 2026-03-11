import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/theme/tw_theme.dart';
import 'package:tailwind_flutter/src/theme/tw_theme_data.dart';
import 'package:tailwind_flutter/src/theme/tw_theme_extension.dart';
import 'package:tailwind_flutter/src/tokens/colors.dart';

void main() {
  group('TwTheme widget', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TwTheme(
            data: TwThemeData.light(),
            child: const Text('Hello'),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('injects ThemeExtensions accessible via context.tw',
        (tester) async {
      late TwThemeData resolvedData;

      await tester.pumpWidget(
        MaterialApp(
          home: TwTheme(
            data: TwThemeData.light(),
            child: Builder(
              builder: (context) {
                resolvedData = context.tw;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolvedData, isA<TwThemeData>());
      expect(resolvedData.colors.blue.shade500, equals(TwColors.blue.shade500));
    });

    testWidgets('context.tw.colors returns TwColorTheme with defaults',
        (tester) async {
      late TwColorTheme colors;

      await tester.pumpWidget(
        MaterialApp(
          home: TwTheme(
            data: TwThemeData.light(),
            child: Builder(
              builder: (context) {
                colors = context.tw.colors;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(colors.blue, equals(TwColors.blue));
      expect(colors.red, equals(TwColors.red));
    });

    testWidgets('uses dark preset', (tester) async {
      late TwThemeData resolvedData;

      await tester.pumpWidget(
        MaterialApp(
          home: TwTheme(
            data: TwThemeData.dark(),
            child: Builder(
              builder: (context) {
                resolvedData = context.tw;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolvedData.brightness, equals(Brightness.dark));
    });
  });
}
