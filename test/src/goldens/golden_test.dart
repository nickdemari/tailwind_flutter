import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

/// Golden harness that wraps test content in a MaterialApp + TwTheme scaffold.
Widget _goldenHarness({
  required TwThemeData twThemeData,
  required ThemeData materialTheme,
  required Widget child,
}) {
  return MaterialApp(
    theme: materialTheme,
    debugShowCheckedModeBanner: false,
    home: TwTheme(
      data: twThemeData,
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

/// Theme configurations for light and dark.
final _themes = {
  'light': (TwThemeData.light(), ThemeData.light()),
  'dark': (TwThemeData.dark(), ThemeData.dark()),
};

void main() {
  for (final entry in _themes.entries) {
    final themeName = entry.key;
    final (twData, materialData) = entry.value;

    group('golden ($themeName)', () {
      testWidgets('styled card using extensions', (tester) async {
        await tester.pumpWidget(
          _goldenHarness(
            twThemeData: twData,
            materialTheme: materialData,
            child: SizedBox(
              width: 300,
              height: 200,
              child: Text('Extensions Card')
                  .bold()
                  .textColor(TwColors.white)
                  .p(TwSpacing.s4)
                  .bg(TwColors.blue.shade500)
                  .rounded(TwRadii.lg)
                  .shadow(TwShadows.md),
            ),
          ),
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../goldens/golden_styled_card_extensions_$themeName.png',
          ),
        );
      });

      testWidgets('styled card using TwStyle.apply', (tester) async {
        final cardStyle = TwStyle(
          padding: TwSpacing.s4.all,
          backgroundColor: TwColors.blue.shade500,
          borderRadius: TwRadii.lg.all,
          shadows: TwShadows.md,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TwColors.white,
          ),
        );

        await tester.pumpWidget(
          _goldenHarness(
            twThemeData: twData,
            materialTheme: materialData,
            child: SizedBox(
              width: 300,
              height: 200,
              child: cardStyle.apply(
                child: const Text('TwStyle Card'),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../goldens/golden_styled_card_tw_style_$themeName.png',
          ),
        );
      });

      testWidgets('text styling', (tester) async {
        await tester.pumpWidget(
          _goldenHarness(
            twThemeData: twData,
            materialTheme: materialData,
            child: SizedBox(
              width: 300,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bold Large')
                      .bold()
                      .fontSize(24)
                      .textColor(TwColors.slate.shade900),
                  const SizedBox(height: 8),
                  Text('Italic Colored')
                      .italic()
                      .textColor(TwColors.blue.shade600),
                  const SizedBox(height: 8),
                  Text('Spaced Weighted')
                      .letterSpacing(2)
                      .fontWeight(FontWeight.w300)
                      .textColor(TwColors.gray.shade700),
                ],
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../goldens/golden_text_styling_$themeName.png',
          ),
        );
      });

      testWidgets('composition merge', (tester) async {
        const baseStyle = TwStyle(
          padding: EdgeInsets.all(16),
          backgroundColor: TwColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        );

        final accentStyle = TwStyle(
          backgroundColor: TwColors.indigo.shade100,
          shadows: TwShadows.lg,
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: TwColors.indigo.shade800,
          ),
        );

        final merged = baseStyle.merge(accentStyle);

        await tester.pumpWidget(
          _goldenHarness(
            twThemeData: twData,
            materialTheme: materialData,
            child: SizedBox(
              width: 300,
              height: 200,
              child: merged.apply(
                child: const Text('Merged Style'),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../goldens/golden_composition_merge_$themeName.png',
          ),
        );
      });
    });
  }
}
