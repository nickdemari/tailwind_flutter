import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

void main() {
  test('package can be imported', () {
    // Verifies the package compiles and exports are reachable.
    expect(tailwindFlutterVersion, isNotEmpty);
  });
}
