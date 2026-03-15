# Semantic Type Scale Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add semantic font role aliases (display, headline, title, body, label) as Text extension methods that bridge Tailwind's scale to Material's type roles.

**Architecture:** New `TwFontRole` extension type + `TwTypeScale` constants class in `lib/src/tokens/type_scale.dart`. Five extension methods added to `TwTextExtensions` that delegate through `TwTypeScale`. New `TwFontSizes.xxs` token at 11px.

**Tech Stack:** Dart 3 extension types, Flutter widget tests

---

### Task 1: Add `TwFontSizes.xxs` token

**Files:**
- Modify: `lib/src/tokens/typography.dart:39-41` (insert before `xs`)
- Modify: `test/src/tokens/typography_test.dart:6-24` (update count + add entry + add test)

**Step 1: Write the failing test**

Add to `test/src/tokens/typography_test.dart`. In the `TwFontSizes` group, update the exhaustive list test and add a value test:

```dart
// In the 'has 13 entries' test, change to 'has 14 entries':
test('has 14 entries', () {
  final entries = <TwFontSize>[
    TwFontSizes.xxs, // ← add this line first
    TwFontSizes.xs,
    TwFontSizes.sm,
    // ... rest unchanged
  ];
  expect(entries.length, 14);
});

// Add new test after the group's opening, before the xs test:
test('xxs has value 11.0 and lineHeight ~1.4545', () {
  expect(TwFontSizes.xxs.value, 11.0);
  expect(TwFontSizes.xxs.lineHeight, closeTo(1.4545, 0.001));
});
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test test/src/tokens/typography_test.dart`
Expected: Compile error — `TwFontSizes.xxs` does not exist

**Step 3: Write minimal implementation**

In `lib/src/tokens/typography.dart`, insert before the `xs` entry (line 40), and update the doc comment on line 35:

```dart
// Update doc comment on line 35:
/// 14 size classes from [xxs] (11px) to [xl9] (128px), each with a paired

// Insert before line 40 (the xs entry):
  /// 11px, line-height 16/11 = ~1.4545
  static const xxs = TwFontSize(11, 1.4545);
```

**Step 4: Run test to verify it passes**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test test/src/tokens/typography_test.dart`
Expected: All tests PASS

**Step 5: Commit**

```bash
git add lib/src/tokens/typography.dart test/src/tokens/typography_test.dart
git commit -m "feat: add TwFontSizes.xxs (11px) token for label.sm mapping"
```

---

### Task 2: Create `TwTypeVariant`, `TwFontRole`, and `TwTypeScale`

**Files:**
- Create: `lib/src/tokens/type_scale.dart`
- Create: `test/src/tokens/type_scale_test.dart`

**Step 1: Write the failing test**

Create `test/src/tokens/type_scale_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tailwind_flutter/src/tokens/type_scale.dart';
import 'package:tailwind_flutter/src/tokens/typography.dart';

void main() {
  group('TwTypeVariant', () {
    test('has 3 values', () {
      expect(TwTypeVariant.values.length, 3);
    });
  });

  group('TwFontRole', () {
    test('exposes sm, md, lg getters', () {
      const role = TwFontRole(
        sm: TwFontSizes.xs,
        md: TwFontSizes.sm,
        lg: TwFontSizes.base,
      );
      expect(role.sm.value, 12.0);
      expect(role.md.value, 14.0);
      expect(role.lg.value, 16.0);
    });

    test('resolve returns correct variant', () {
      const role = TwFontRole(
        sm: TwFontSizes.xs,
        md: TwFontSizes.sm,
        lg: TwFontSizes.base,
      );
      expect(role.resolve(TwTypeVariant.sm).value, 12.0);
      expect(role.resolve(TwTypeVariant.md).value, 14.0);
      expect(role.resolve(TwTypeVariant.lg).value, 16.0);
    });
  });

  group('TwTypeScale', () {
    test('display maps to xl4, xl5, xl6', () {
      expect(TwTypeScale.display.sm.value, 36.0);
      expect(TwTypeScale.display.md.value, 48.0);
      expect(TwTypeScale.display.lg.value, 60.0);
    });

    test('headline maps to xl2, xl3, xl4', () {
      expect(TwTypeScale.headline.sm.value, 24.0);
      expect(TwTypeScale.headline.md.value, 30.0);
      expect(TwTypeScale.headline.lg.value, 36.0);
    });

    test('title maps to sm, base, xl', () {
      expect(TwTypeScale.title.sm.value, 14.0);
      expect(TwTypeScale.title.md.value, 16.0);
      expect(TwTypeScale.title.lg.value, 20.0);
    });

    test('body maps to xs, sm, base', () {
      expect(TwTypeScale.body.sm.value, 12.0);
      expect(TwTypeScale.body.md.value, 14.0);
      expect(TwTypeScale.body.lg.value, 16.0);
    });

    test('label maps to xxs, xs, sm', () {
      expect(TwTypeScale.label.sm.value, 11.0);
      expect(TwTypeScale.label.md.value, 12.0);
      expect(TwTypeScale.label.lg.value, 14.0);
    });

    test('each role preserves paired lineHeight', () {
      expect(TwTypeScale.display.lg.lineHeight, 1.0);
      expect(TwTypeScale.headline.md.lineHeight, 1.2);
      expect(TwTypeScale.body.md.lineHeight, closeTo(1.4286, 0.001));
      expect(TwTypeScale.label.sm.lineHeight, closeTo(1.4545, 0.001));
    });
  });
}
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test test/src/tokens/type_scale_test.dart`
Expected: Compile error — `type_scale.dart` does not exist

**Step 3: Write minimal implementation**

Create `lib/src/tokens/type_scale.dart`:

```dart
import 'package:tailwind_flutter/src/tokens/typography.dart';

/// Size variant for semantic type roles.
///
/// Each [TwFontRole] provides three size variants following Material Design's
/// small / medium / large convention.
enum TwTypeVariant { sm, md, lg }

/// A semantic font role grouping three size variants of [TwFontSize].
///
/// Mirrors [TwColorFamily]'s extension-type pattern — zero-cost at runtime,
/// const-constructible, and record-backed.
///
/// ```dart
/// TwTypeScale.headline.md  // → TwFontSize(30, 1.2)
/// TwTypeScale.headline.resolve(TwTypeVariant.lg)  // → TwFontSize(36, ~1.1111)
/// ```
extension type const TwFontRole._(
    ({TwFontSize sm, TwFontSize md, TwFontSize lg}) _) {
  /// Creates a font role with three size variants.
  const TwFontRole(
      {required TwFontSize sm,
      required TwFontSize md,
      required TwFontSize lg})
      : this._((sm: sm, md: md, lg: lg));

  /// The small variant.
  TwFontSize get sm => _.sm;

  /// The medium variant.
  TwFontSize get md => _.md;

  /// The large variant.
  TwFontSize get lg => _.lg;

  /// Returns the [TwFontSize] for the given [variant].
  TwFontSize resolve(TwTypeVariant variant) => switch (variant) {
        TwTypeVariant.sm => _.sm,
        TwTypeVariant.md => _.md,
        TwTypeVariant.lg => _.lg,
      };
}

/// Material Design type roles mapped to Tailwind CSS font size tokens.
///
/// Five semantic roles — [display], [headline], [title], [body], [label] —
/// each with three size variants accessed via [TwFontRole.sm], [.md], [.lg],
/// or resolved dynamically with [TwFontRole.resolve].
///
/// ```dart
/// Text('Welcome').headline(.lg).bold()
/// Text('Details').body(.md)
///
/// // Standalone usage:
/// final style = TwTypeScale.headline.md.textStyle;
/// ```
abstract final class TwTypeScale {
  /// Display role — xl4 (36px) / xl5 (48px) / xl6 (60px).
  static const display = TwFontRole(
      sm: TwFontSizes.xl4, md: TwFontSizes.xl5, lg: TwFontSizes.xl6);

  /// Headline role — xl2 (24px) / xl3 (30px) / xl4 (36px).
  static const headline = TwFontRole(
      sm: TwFontSizes.xl2, md: TwFontSizes.xl3, lg: TwFontSizes.xl4);

  /// Title role — sm (14px) / base (16px) / xl (20px).
  static const title = TwFontRole(
      sm: TwFontSizes.sm, md: TwFontSizes.base, lg: TwFontSizes.xl);

  /// Body role — xs (12px) / sm (14px) / base (16px).
  static const body = TwFontRole(
      sm: TwFontSizes.xs, md: TwFontSizes.sm, lg: TwFontSizes.base);

  /// Label role — xxs (11px) / xs (12px) / sm (14px).
  static const label = TwFontRole(
      sm: TwFontSizes.xxs, md: TwFontSizes.xs, lg: TwFontSizes.sm);
}
```

**Step 4: Run test to verify it passes**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test test/src/tokens/type_scale_test.dart`
Expected: All tests PASS

**Step 5: Commit**

```bash
git add lib/src/tokens/type_scale.dart test/src/tokens/type_scale_test.dart
git commit -m "feat: add TwFontRole, TwTypeVariant, and TwTypeScale with 5 semantic roles"
```

---

### Task 3: Add type role extension methods to `TwTextExtensions`

**Files:**
- Modify: `lib/src/extensions/text_extensions.dart:31-32` (add import + 5 methods before `_copyWith`)
- Modify: `test/src/extensions/text_extensions_test.dart` (add new test group)

**Step 1: Write the failing tests**

Add a new group to the end of `test/src/extensions/text_extensions_test.dart`, inside the top-level `TwTextExtensions` group (before the closing `});` on line 392):

```dart
    group('type role extensions', () {
      testWidgets('.display() sets fontSize and lineHeight from TwTypeScale',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text('Hello').display(TwTypeVariant.sm)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 36.0); // xl4
        expect(text.style?.height, closeTo(1.1111, 0.001));
        expect(text.data, 'Hello');
      });

      testWidgets('.headline() sets fontSize and lineHeight from TwTypeScale',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text('Hello').headline(TwTypeVariant.md)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 30.0); // xl3
        expect(text.style?.height, 1.2);
        expect(text.data, 'Hello');
      });

      testWidgets('.title() sets fontSize and lineHeight from TwTypeScale',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text('Hello').title(TwTypeVariant.lg)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 20.0); // xl
        expect(text.style?.height, 1.4);
        expect(text.data, 'Hello');
      });

      testWidgets('.body() sets fontSize and lineHeight from TwTypeScale',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text('Hello').body(TwTypeVariant.sm)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 12.0); // xs
        expect(text.style?.height, closeTo(1.3333, 0.001));
        expect(text.data, 'Hello');
      });

      testWidgets('.label() sets fontSize and lineHeight from TwTypeScale',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text('Hello').label(TwTypeVariant.sm)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 11.0); // xxs
        expect(text.style?.height, closeTo(1.4545, 0.001));
        expect(text.data, 'Hello');
      });

      testWidgets('role methods chain with other text extensions',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text('Hello')
                  .headline(TwTypeVariant.lg)
                  .bold()
                  .textColor(Colors.red)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 36.0); // xl4
        expect(text.style?.fontWeight, FontWeight.bold);
        expect(text.style?.color, Colors.red);
      });

      testWidgets('role methods preserve Text constructor parameters',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
              home: Text(
            'Hello',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).headline(TwTypeVariant.md)),
        );
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, 30.0);
        expect(text.maxLines, 2);
        expect(text.overflow, TextOverflow.ellipsis);
      });
    });
```

Also add the import at the top of the test file:

```dart
import 'package:tailwind_flutter/src/tokens/type_scale.dart';
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test test/src/extensions/text_extensions_test.dart`
Expected: Compile error — `.display()`, `.headline()`, etc. do not exist on `Text`

**Step 3: Write minimal implementation**

In `lib/src/extensions/text_extensions.dart`:

Add import after existing imports (line 31):

```dart
import 'package:tailwind_flutter/src/tokens/type_scale.dart';
```

Add 5 methods before `_copyWith` (insert before line 244, the `_copyWith` doc comment):

```dart
  /// Sets the font size to the [display] type role variant.
  ///
  /// Maps to [TwTypeScale.display]: xl4 (36px) / xl5 (48px) / xl6 (60px).
  ///
  /// ```dart
  /// Text('Hero').display(TwTypeVariant.lg) // 60px
  /// ```
  Text display(TwTypeVariant variant) =>
      fontSize(TwTypeScale.display.resolve(variant));

  /// Sets the font size to the [headline] type role variant.
  ///
  /// Maps to [TwTypeScale.headline]: xl2 (24px) / xl3 (30px) / xl4 (36px).
  ///
  /// ```dart
  /// Text('Welcome').headline(TwTypeVariant.md) // 30px
  /// ```
  Text headline(TwTypeVariant variant) =>
      fontSize(TwTypeScale.headline.resolve(variant));

  /// Sets the font size to the [title] type role variant.
  ///
  /// Maps to [TwTypeScale.title]: sm (14px) / base (16px) / xl (20px).
  ///
  /// ```dart
  /// Text('Section').title(TwTypeVariant.lg) // 20px
  /// ```
  Text title(TwTypeVariant variant) =>
      fontSize(TwTypeScale.title.resolve(variant));

  /// Sets the font size to the [body] type role variant.
  ///
  /// Maps to [TwTypeScale.body]: xs (12px) / sm (14px) / base (16px).
  ///
  /// ```dart
  /// Text('Content').body(TwTypeVariant.md) // 14px
  /// ```
  Text body(TwTypeVariant variant) =>
      fontSize(TwTypeScale.body.resolve(variant));

  /// Sets the font size to the [label] type role variant.
  ///
  /// Maps to [TwTypeScale.label]: xxs (11px) / xs (12px) / sm (14px).
  ///
  /// ```dart
  /// Text('Hint').label(TwTypeVariant.sm) // 11px
  /// ```
  Text label(TwTypeVariant variant) =>
      fontSize(TwTypeScale.label.resolve(variant));
```

**Step 4: Run test to verify it passes**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test test/src/extensions/text_extensions_test.dart`
Expected: All tests PASS

**Step 5: Commit**

```bash
git add lib/src/extensions/text_extensions.dart test/src/extensions/text_extensions_test.dart
git commit -m "feat: add display/headline/title/body/label extension methods on Text"
```

---

### Task 4: Export from barrel and run full suite

**Files:**
- Modify: `lib/tailwind_flutter.dart:22` (add export)

**Step 1: Add the export**

In `lib/tailwind_flutter.dart`, add after line 22 (`export 'src/tokens/typography.dart';`):

```dart
export 'src/tokens/type_scale.dart';
```

**Step 2: Run the full test suite**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && flutter test`
Expected: All tests PASS (no regressions)

**Step 3: Run the analyzer**

Run: `cd /Users/nicolasdemari/dev/tailwind_flutter && dart analyze`
Expected: No issues found

**Step 4: Commit**

```bash
git add lib/tailwind_flutter.dart
git commit -m "feat: export TwTypeScale, TwFontRole, and TwTypeVariant from barrel"
```
