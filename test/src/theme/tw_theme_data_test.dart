import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/theme/tw_theme_data.dart';
import 'package:tailwind_flutter/src/theme/tw_theme_extension.dart';
import 'package:tailwind_flutter/src/tokens/colors.dart';

void main() {
  group('TwThemeData', () {
    test('light() creates TwThemeData with Brightness.light', () {
      final data = TwThemeData.light();
      expect(data.brightness, equals(Brightness.light));
    });

    test('dark() creates TwThemeData with Brightness.dark', () {
      final data = TwThemeData.dark();
      expect(data.brightness, equals(Brightness.dark));
    });

    test('light() uses all default extensions', () {
      final data = TwThemeData.light();
      expect(data.colors, isA<TwColorTheme>());
      expect(data.spacing, isA<TwSpacingTheme>());
      expect(data.typography, isA<TwTypographyTheme>());
      expect(data.radius, isA<TwRadiusTheme>());
      expect(data.shadows, isA<TwShadowTheme>());
      expect(data.opacity, isA<TwOpacityTheme>());
      expect(data.breakpoints, isA<TwBreakpointTheme>());
    });

    test('light() with custom colors overrides colors, keeps other defaults',
        () {
      const customColors = TwColorTheme(
        slate: TwColors.slate,
        gray: TwColors.gray,
        zinc: TwColors.zinc,
        neutral: TwColors.neutral,
        stone: TwColors.stone,
        red: TwColors.red,
        orange: TwColors.orange,
        amber: TwColors.amber,
        yellow: TwColors.yellow,
        lime: TwColors.lime,
        green: TwColors.green,
        emerald: TwColors.emerald,
        teal: TwColors.teal,
        cyan: TwColors.cyan,
        sky: TwColors.sky,
        blue: TwColors.blue,
        indigo: TwColors.indigo,
        violet: TwColors.violet,
        purple: TwColors.purple,
        fuchsia: TwColors.fuchsia,
        pink: TwColors.pink,
        rose: TwColors.rose,
        black: Color(0xFFAAAAAA),
        white: TwColors.white,
        transparent: TwColors.transparent,
      );
      final data = TwThemeData.light(colors: customColors);

      expect(data.colors.black, equals(const Color(0xFFAAAAAA)));
      expect(data.spacing, isA<TwSpacingTheme>());
    });

    test('extensions returns Iterable of all 7 ThemeExtension instances', () {
      final data = TwThemeData.light();
      final extensions = data.extensions;

      expect(extensions.length, equals(7));
      expect(extensions.whereType<TwColorTheme>().length, equals(1));
      expect(extensions.whereType<TwSpacingTheme>().length, equals(1));
      expect(extensions.whereType<TwTypographyTheme>().length, equals(1));
      expect(extensions.whereType<TwRadiusTheme>().length, equals(1));
      expect(extensions.whereType<TwShadowTheme>().length, equals(1));
      expect(extensions.whereType<TwOpacityTheme>().length, equals(1));
      expect(extensions.whereType<TwBreakpointTheme>().length, equals(1));
    });

    test('accessor getters return correct instances', () {
      final data = TwThemeData.light();

      expect(data.colors.blue.shade500, equals(TwColors.blue.shade500));
      expect(data.spacing.s4, equals(16.0));
    });

    test('copyWith overrides specific fields', () {
      final original = TwThemeData.light();
      final copied = original.copyWith(brightness: Brightness.dark);

      expect(copied.brightness, equals(Brightness.dark));
      expect(copied.colors, equals(original.colors));
    });
  });

  group('context.tw', () {
    testWidgets('resolves TwThemeData when TwTheme ancestor exists',
        (tester) async {
      late TwThemeData resolvedData;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: TwThemeData.light().extensions,
          ),
          home: Builder(
            builder: (context) {
              resolvedData = context.tw;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedData, isA<TwThemeData>());
      expect(resolvedData.colors.blue.shade500, equals(TwColors.blue.shade500));
    });

    testWidgets('context.tw throws FlutterError when no TwTheme ancestor',
        (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          // No TwTheme extensions injected
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        () => capturedContext.tw,
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            contains('TwTheme'),
          ),
        ),
      );
    });

    testWidgets('context.twMaybe returns null when no TwTheme ancestor',
        (tester) async {
      TwThemeData? maybeData;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              maybeData = context.twMaybe;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(maybeData, isNull);
    });

    testWidgets('context.twMaybe returns TwThemeData when TwTheme exists',
        (tester) async {
      TwThemeData? maybeData;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: TwThemeData.light().extensions,
          ),
          home: Builder(
            builder: (context) {
              maybeData = context.twMaybe;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(maybeData, isNotNull);
      expect(maybeData!.colors, isA<TwColorTheme>());
    });
  });
}
