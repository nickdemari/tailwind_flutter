import 'package:flutter/material.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

import 'package:tailwind_flutter_example/pages/extensions_page.dart';
import 'package:tailwind_flutter_example/pages/layouts_page.dart';
import 'package:tailwind_flutter_example/pages/styles_page.dart';
import 'package:tailwind_flutter_example/pages/tokens_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tailwind_flutter',
      debugShowCheckedModeBanner: false,
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: TwTheme(
        data: _isDark ? TwThemeData.dark() : TwThemeData.light(),
        child: _HomeScreen(
          isDark: _isDark,
          onToggleDark: () => setState(() => _isDark = !_isDark),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({
    required this.isDark,
    required this.onToggleDark,
  });

  final bool isDark;
  final VoidCallback onToggleDark;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('tailwind_flutter')
              .bold()
              .textColor(TwColors.blue.shade500),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
              onPressed: onToggleDark,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tokens'),
              Tab(text: 'Extensions'),
              Tab(text: 'Styles'),
              Tab(text: 'Layouts'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TokensPage(),
            ExtensionsPage(),
            StylesPage(),
            LayoutsPage(),
          ],
        ),
      ),
    );
  }
}
