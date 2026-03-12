# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-03-12

### Changed

- `.fontSize()` now accepts `TwFontSize` tokens directly — no more `.value`
  needed. When a `TwFontSize` is passed, the paired Tailwind line-height is
  automatically applied.

## [0.1.0] - 2026-03-12

### Added

- Complete Tailwind CSS v4 color palette (22 families x 11 shades = 242 colors)
  plus semantic colors (black, white, transparent)
- Spacing scale (35 values from `s0` through `s96`) with `EdgeInsets`
  convenience getters (`.all`, `.x`, `.y`)
- Typography tokens: 13 font sizes with paired line-heights, 9 font weights, 6
  letter spacings, 6 line heights
- Border radius scale (10 values from `none` through `full`) with
  `BorderRadius` convenience getters
- Box shadow presets (7 levels from `xxs` through `xl2` plus `inner` and
  `none`)
- Opacity scale (21 values from `o0` through `o100`) and responsive breakpoint
  constants (5 thresholds)
- Theme integration: 7 `ThemeExtension` classes, `TwTheme` widget,
  `TwThemeData` with `.light()` / `.dark()` presets, `context.tw` accessor
- Widget extensions: `.p()`, `.px()`, `.py()`, `.m()`, `.mx()`, `.my()`,
  `.bg()`, `.rounded()`, `.opacity()`, `.shadow()`, `.width()`, `.height()`,
  `.center()`, `.align()`, `.clipRect()`, `.clipOval()`
- Text extensions: `.bold()`, `.italic()`, `.fontSize()`, `.textColor()`,
  `.letterSpacing()`, `.lineHeight()`, `.fontWeight()`, `.textStyle()`
- `TwStyle` composable styling with `.merge()`, `.apply()`, `.resolve()`, and
  `TwVariant` (`.dark` / `.light`) for brightness-conditional overrides
- Example app demonstrating all three API tiers (tokens, extensions, styles)
- Golden tests for styled widgets across light and dark themes

## 0.0.1-dev.1

- Initial package scaffold
- Project structure with placeholder files
- CI pipeline (analyze, test, publish check)
- Strict lint rules via very_good_analysis
