import 'package:flutter/material.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

/// Demonstrates Tier 1: Design tokens (colors, spacing, typography).
class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  static const _colorFamilies = <String, TwColorFamily>{
    'slate': TwColors.slate,
    'gray': TwColors.gray,
    'zinc': TwColors.zinc,
    'neutral': TwColors.neutral,
    'stone': TwColors.stone,
    'red': TwColors.red,
    'orange': TwColors.orange,
    'amber': TwColors.amber,
    'yellow': TwColors.yellow,
    'lime': TwColors.lime,
    'green': TwColors.green,
    'emerald': TwColors.emerald,
    'teal': TwColors.teal,
    'cyan': TwColors.cyan,
    'sky': TwColors.sky,
    'blue': TwColors.blue,
    'indigo': TwColors.indigo,
    'violet': TwColors.violet,
    'purple': TwColors.purple,
    'fuchsia': TwColors.fuchsia,
    'pink': TwColors.pink,
    'rose': TwColors.rose,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Color palette --
          _sectionTitle('Color Palette', isDark: isDark),
          _sectionSubtitle('22 families, 11 shades each', isDark: isDark),
          ..._colorFamilies.entries.map(
            (entry) => _ColorFamilyRow(
              name: entry.key,
              family: entry.value,
            ),
          ),

          SizedBox(height: TwSpacing.s8),

          // -- Spacing samples --
          _sectionTitle('Spacing Scale', isDark: isDark),
          _sectionSubtitle('35 named values from 0px to 384px', isDark: isDark),
          _SpacingSamples(isDark: isDark),

          SizedBox(height: TwSpacing.s8),

          // -- Typography samples --
          _sectionTitle('Font Sizes', isDark: isDark),
          _sectionSubtitle(
            '13 sizes from xs (12px) to xl9 (128px)',
            isDark: isDark,
          ),
          const _TypographySamples(),

          SizedBox(height: TwSpacing.s8),
        ],
      ).p(TwSpacing.s4),
    );
  }
}

// ---------------------------------------------------------------------------
// Section helpers
// ---------------------------------------------------------------------------

Widget _sectionTitle(String text, {required bool isDark}) {
  return Text(text)
      .bold()
      .fontSize(TwFontSizes.xl)
      .textColor(isDark ? TwColors.white : TwColors.slate.shade900)
      .pb(TwSpacing.s2);
}

Widget _sectionSubtitle(String text, {required bool isDark}) {
  return Text(text)
      .fontSize(TwFontSizes.sm)
      .textColor(isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500)
      .pb(TwSpacing.s4);
}

// ---------------------------------------------------------------------------
// Color palette
// ---------------------------------------------------------------------------

class _ColorFamilyRow extends StatelessWidget {
  const _ColorFamilyRow({required this.name, required this.family});

  final String name;
  final TwColorFamily family;

  @override
  Widget build(BuildContext context) {
    final shades = <Color>[
      family.shade50,
      family.shade100,
      family.shade200,
      family.shade300,
      family.shade400,
      family.shade500,
      family.shade600,
      family.shade700,
      family.shade800,
      family.shade900,
      family.shade950,
    ];

    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(name)
              .fontSize(TwFontSizes.xs)
              .fontWeight(TwFontWeights.medium),
        ),
        ...shades.map(
          (color) => Expanded(
            child: Container(color: color).height(TwSpacing.s8),
          ),
        ),
      ],
    ).pb(TwSpacing.s1);
  }
}

// ---------------------------------------------------------------------------
// Spacing samples
// ---------------------------------------------------------------------------

class _SpacingSamples extends StatelessWidget {
  const _SpacingSamples({required this.isDark});

  final bool isDark;

  static const _samples = <String, TwSpace>{
    's1 (4px)': TwSpacing.s1,
    's2 (8px)': TwSpacing.s2,
    's4 (16px)': TwSpacing.s4,
    's8 (32px)': TwSpacing.s8,
    's12 (48px)': TwSpacing.s12,
    's16 (64px)': TwSpacing.s16,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _samples.entries.map((entry) {
        return Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(entry.key).fontSize(TwFontSizes.xs),
            ),
            Container(
              width: entry.value.toDouble(),
              height: TwSpacing.s6,
              color: TwColors.blue.shade400,
            ).rounded(TwRadii.sm),
          ],
        ).pb(TwSpacing.s2);
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Typography samples
// ---------------------------------------------------------------------------

class _TypographySamples extends StatelessWidget {
  const _TypographySamples();

  static const _sizes = <String, TwFontSize>{
    'xs': TwFontSizes.xs,
    'sm': TwFontSizes.sm,
    'base': TwFontSizes.base,
    'lg': TwFontSizes.lg,
    'xl': TwFontSizes.xl,
    'xl2': TwFontSizes.xl2,
    'xl3': TwFontSizes.xl3,
    'xl4': TwFontSizes.xl4,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _sizes.entries.map((entry) {
        return Text('${entry.key} (${entry.value.value.toInt()}px)')
            .textStyle(entry.value.textStyle)
            .pb(TwSpacing.s1);
      }).toList(),
    );
  }
}
