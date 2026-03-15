# Semantic Type Scale Aliases

## Problem

Tailwind's font size scale (`xs`, `sm`, `base`, `lg`, `xl`...) is numeric and low-level. Material Design's type roles (`display`, `headline`, `title`, `body`, `label`) carry semantic meaning. Users familiar with Material need a bridge between the two systems.

## API

```dart
Text('Welcome back').headline(.lg).bold()
Text('Read more').label(.md).textColor(TwColors.zinc.shade500)
Text('$price/mo').display(.sm)

// Also usable standalone for TwStyle:
TwTypeScale.headline.md.textStyle
```

## New Types

### `TwTypeVariant` enum

```dart
enum TwTypeVariant { sm, md, lg }
```

### `TwFontRole` extension type

Zero-cost wrapper (mirrors `TwColorFamily` pattern) holding 3 size variants:

```dart
extension type const TwFontRole._(({TwFontSize sm, TwFontSize md, TwFontSize lg}) _) {
  const TwFontRole({required TwFontSize sm, required TwFontSize md, required TwFontSize lg})
      : this._((sm: sm, md: md, lg: lg));

  TwFontSize get sm => _.sm;
  TwFontSize get md => _.md;
  TwFontSize get lg => _.lg;
}
```

Includes `_resolve(TwTypeVariant)` method for extension method delegation.

### `TwTypeScale` abstract final class

Source of truth for role-to-scale mappings:

| Role | `.sm` | `.md` | `.lg` |
|------|-------|-------|-------|
| display | xl4 (36px) | xl5 (48px) | xl6 (60px) |
| headline | xl2 (24px) | xl3 (30px) | xl4 (36px) |
| title | sm (14px) | base (16px) | xl (20px) |
| body | xs (12px) | sm (14px) | base (16px) |
| label | xxs (11px) | xs (12px) | sm (14px) |

### `TwFontSizes.xxs` new token

11px font size with line-height 16/11 = ~1.4545, needed for `label.sm`.

## Extension Methods

5 methods added to `TwTextExtensions`, each takes required `TwTypeVariant`:

```dart
Text display(TwTypeVariant v)
Text headline(TwTypeVariant v)
Text title(TwTypeVariant v)
Text body(TwTypeVariant v)
Text label(TwTypeVariant v)
```

Each delegates to existing `fontSize()` via `TwTypeScale.<role>._resolve(v)`.

## File Changes

- `lib/src/tokens/type_scale.dart` — new file: `TwTypeVariant`, `TwFontRole`, `TwTypeScale`
- `lib/src/tokens/typography.dart` — add `TwFontSizes.xxs`
- `lib/src/extensions/text_extensions.dart` — add 5 role methods
- `lib/tailwind_flutter.dart` — export new file

## Scope Boundaries

- No font weight or letter spacing baked into roles
- No theme integration for `TwTypeScale`
- Variant parameter is required (no default)
