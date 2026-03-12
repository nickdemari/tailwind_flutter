import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tailwind_flutter_example/main.dart';

void main() {
  testWidgets('App renders with three tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tokens'), findsOneWidget);
    expect(find.text('Extensions'), findsOneWidget);
    expect(find.text('Styles'), findsOneWidget);
  });

  testWidgets('Dark mode toggle switches theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
