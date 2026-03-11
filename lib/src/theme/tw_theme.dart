import 'package:flutter/material.dart';

import 'package:tailwind_flutter/src/theme/tw_theme_data.dart';

/// A convenience widget that injects all Tailwind CSS [ThemeExtension]
/// instances into the widget tree via [Theme].
///
/// Wraps the subtree in a [Theme] widget whose [ThemeData.extensions] contain
/// all 7 token theme extensions from [TwThemeData.extensions].
///
/// ```dart
/// MaterialApp(
///   home: TwTheme(
///     data: TwThemeData.light(),
///     child: MyHomePage(),
///   ),
/// )
/// ```
///
/// Downstream widgets access tokens via [TwThemeContext.tw]:
///
/// ```dart
/// final primary = context.tw.colors.blue.shade500;
/// ```
class TwTheme extends StatelessWidget {
  /// Creates a [TwTheme] that provides [data] to descendant widgets.
  const TwTheme({
    required this.data,
    required this.child,
    super.key,
  });

  /// The Tailwind theme data to inject.
  final TwThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parent = Theme.of(context);
    return Theme(
      data: parent.copyWith(
        extensions: data.extensions,
        colorScheme: parent.colorScheme.copyWith(
          brightness: data.brightness,
        ),
      ),
      child: child,
    );
  }
}
