# tailwind_flutter

[![pub package](https://img.shields.io/pub/v/tailwind_flutter.svg)](https://pub.dev/packages/tailwind_flutter)
[![CI](https://github.com/user/tailwind_flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/user/tailwind_flutter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

Tailwind CSS design tokens and utility-first styling API for Flutter. Type-safe
constants, chainable widget extensions, and composable styles -- all integrated
with Flutter's theme system.

## Features

- **Complete Tailwind v4 token set** -- 242 colors, 35 spacing values, 13 font
  sizes, 9 font weights, 10 border radii, 7 shadow levels, 21 opacity steps,
  and 5 responsive breakpoints
- **Widget extensions** -- chain `.p()`, `.bg()`, `.rounded()`, `.shadow()` on
  any widget instead of nesting Padding/ColoredBox/ClipRRect manually
- **Text extensions** -- `.bold()`, `.fontSize()`, `.textColor()` directly on
  Text widgets
- **Composable styles** -- define reusable `TwStyle` objects (like CSS classes),
  merge them, and apply them to widgets
- **Theme integration** -- 7 `ThemeExtension` classes, `TwTheme` widget,
  `context.tw` accessor, light/dark presets
- **Dark mode** -- `TwVariant.dark` / `TwVariant.light` for
  brightness-conditional style overrides

## Quick Start

**1. Add the dependency**

```yaml
dependencies:
  tailwind_flutter: ^0.1.0
```

**2. Wrap your app in TwTheme**

```dart
import 'package:tailwind_flutter/tailwind_flutter.dart';

MaterialApp(
  home: TwTheme(
    data: TwThemeData.light(),
    child: MyHomePage(),
  ),
)
```

**3. Style a widget**

```dart
Text('Hello, Tailwind!')
  .bold()
  .fontSize(TwFontSizes.lg)
  .textColor(TwColors.blue.shade600)
  .p(TwSpacing.s4)
  .bg(TwColors.blue.shade50)
  .rounded(TwRadii.lg)
```

That's it. Three steps, one styled widget.

## API Overview

tailwind_flutter is organized in three tiers, from low-level tokens to
high-level composable styles.

### Tier 1: Design Tokens

Type-safe, `const` values that mirror the Tailwind CSS design system. Every
token is autocomplete-friendly in your IDE.

| Category | Class | Example |
|----------|-------|---------|
| Colors | `TwColors` | `TwColors.blue.shade500` |
| Spacing | `TwSpacing` | `TwSpacing.s4` (16.0) |
| Font sizes | `TwFontSizes` | `TwFontSizes.lg` (18px + paired line-height) |
| Font weights | `TwFontWeights` | `TwFontWeights.semibold` |
| Border radius | `TwRadii` | `TwRadii.lg` (8.0) |
| Shadows | `TwShadows` | `TwShadows.md` |
| Opacity | `TwOpacity` | `TwOpacity.o50` (0.5) |
| Breakpoints | `TwBreakpoints` | `TwBreakpoints.md` (768.0) |

Spacing and radius tokens implement `double`, so they work anywhere Flutter
expects a number. They also provide convenience getters for common types:

```dart
// Spacing as EdgeInsets
Padding(padding: TwSpacing.s4.all)   // EdgeInsets.all(16.0)
Padding(padding: TwSpacing.s4.x)     // EdgeInsets.symmetric(horizontal: 16.0)

// Radius as BorderRadius
BoxDecoration(borderRadius: TwRadii.lg.all)  // BorderRadius.circular(8.0)

// Font size as TextStyle (includes paired line-height)
Text('Hello', style: TwFontSizes.lg.textStyle)
```

### Tier 2: Widget Extensions

Chain methods on any `Widget` (or `Text`) to apply styling without manual
widget nesting. Each method wraps the widget in exactly one Flutter widget.

**Widget extensions** (on any Widget):

```dart
Container(child: Text('Card content'))
  .p(TwSpacing.s4)              // inner padding
  .bg(TwColors.white)           // background color
  .rounded(TwRadii.lg)          // rounded corners
  .shadow(TwShadows.md)         // box shadow
  .opacity(TwOpacity.o90)       // opacity
  .m(TwSpacing.s2)              // outer margin
```

**Text extensions** (on Text widgets):

```dart
Text('Styled text')
  .bold()
  .fontSize(TwFontSizes.xl)
  .textColor(TwColors.slate.shade700)
  .letterSpacing(0.5)
  .lineHeight(1.6)
```

> **Order matters:** Text extensions must come before widget extensions in the
> chain, because text extensions return `Text` while widget extensions return
> `Widget`. Once you call a widget extension, text-specific methods are no
> longer available.

### Tier 3: Composable Styles (TwStyle)

Define reusable style objects -- the Flutter equivalent of CSS classes. Merge
them, resolve dark mode variants, and apply them to widgets.

**Define a style:**

```dart
const card = TwStyle(
  padding: EdgeInsets.all(16),
  backgroundColor: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(8)),
  shadows: TwShadows.md,
);
```

**Merge styles** (right-side-wins):

```dart
final highlighted = card.merge(TwStyle(
  backgroundColor: TwColors.blue.shade50,
  shadows: TwShadows.lg,
));
// highlighted keeps card's padding and borderRadius,
// but overrides backgroundColor and shadows
```

**Dark mode variants:**

```dart
final themed = TwStyle(
  backgroundColor: TwColors.white,
  textStyle: TextStyle(color: TwColors.slate.shade900),
  variants: {
    TwVariant.dark: TwStyle(
      backgroundColor: TwColors.zinc.shade900,
      textStyle: TextStyle(color: TwColors.zinc.shade100),
    ),
  },
);

// In your build method -- resolve then apply:
Widget build(BuildContext context) {
  return themed.resolve(context).apply(child: Text('Adaptive card'));
}
```

## Tailwind CSS Comparison

Coming from Tailwind CSS on the web? Here's how utilities map to
tailwind_flutter:

| Tailwind CSS | tailwind_flutter | Notes |
|---|---|---|
| `bg-blue-500` | `.bg(TwColors.blue.shade500)` | Widget extension |
| `p-4` | `.p(TwSpacing.s4)` | 16px padding all sides |
| `px-6` | `.px(TwSpacing.s6)` | Horizontal padding |
| `py-2` | `.py(TwSpacing.s2)` | Vertical padding |
| `m-4` | `.m(TwSpacing.s4)` | Outer margin |
| `rounded-lg` | `.rounded(TwRadii.lg)` | 8px border radius |
| `text-lg` | `.fontSize(TwFontSizes.lg)` | 18px font size + paired line-height |
| `font-bold` | `.bold()` | Text extension |
| `font-semibold` | `.fontWeight(TwFontWeights.semibold)` | Text extension |
| `shadow-md` | `.shadow(TwShadows.md)` | Widget extension |
| `opacity-50` | `.opacity(TwOpacity.o50)` | Widget extension |
| `text-slate-700` | `.textColor(TwColors.slate.shade700)` | Text extension |
| `w-64` | `.width(TwSpacing.s64)` | 256px width |
| `dark:bg-gray-800` | `TwVariant.dark` in TwStyle variants | Resolve with context |

## Theme Setup

### Basic setup

Wrap your app (or a subtree) in `TwTheme` to make all tokens available via
Flutter's theme system:

```dart
MaterialApp(
  home: TwTheme(
    data: TwThemeData.light(),
    child: MyHomePage(),
  ),
)
```

### Dark mode

Switch to the dark preset:

```dart
TwTheme(
  data: TwThemeData.dark(),
  child: MyApp(),
)
```

### Custom overrides

Override specific token categories while keeping defaults for the rest:

```dart
TwTheme(
  data: TwThemeData.light(
    colors: myBrandColors,
  ),
  child: MyApp(),
)
```

### Accessing tokens from context

Use `context.tw` in any build method to access theme-aware tokens:

```dart
Widget build(BuildContext context) {
  final primary = context.tw.colors.blue.shade500;
  final space = context.tw.spacing.s4;

  return Container(
    padding: EdgeInsets.all(space),
    color: primary,
    child: Text('Themed widget'),
  );
}
```

## Contributing

Contributions are welcome.

- **Bugs and feature requests:** [open an issue](https://github.com/user/tailwind_flutter/issues)
- **Code contributions:** fork the repo, create a branch, and submit a PR
- **Lint rules:** this project uses [very_good_analysis](https://pub.dev/packages/very_good_analysis) --
  run `dart format .` and `flutter analyze` before submitting

## License

MIT License. See [LICENSE](LICENSE) for details.
