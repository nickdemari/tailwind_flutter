import 'package:flutter/material.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

/// Demonstrates Tier 3: TwStyle composable styling with merge, resolve,
/// and apply.
class StylesPage extends StatelessWidget {
  const StylesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Composable Styles')
              .bold()
              .fontSize(TwFontSizes.xl)
              .textColor(fg)
              .pb(TwSpacing.s1),
          Text('Define reusable styles, merge overrides, resolve variants.')
              .fontSize(TwFontSizes.sm)
              .textColor(muted)
              .pb(TwSpacing.s6),

          // -- Base card --
          Text('Base Card Style')
              .bold()
              .fontSize(TwFontSizes.base)
              .textColor(fg)
              .pb(TwSpacing.s2),
          _BaseCardDemo(isDark: isDark),

          SizedBox(height: TwSpacing.s8),

          // -- Merged card --
          Text('Merged Style (base + accent)')
              .bold()
              .fontSize(TwFontSizes.base)
              .textColor(fg)
              .pb(TwSpacing.s2),
          _MergedCardDemo(isDark: isDark),

          SizedBox(height: TwSpacing.s8),

          // -- Variant card --
          Text('Dark Variant Resolution')
              .bold()
              .fontSize(TwFontSizes.base)
              .textColor(fg)
              .pb(TwSpacing.s1),
          Text('Toggle dark mode to see the variant resolve.')
              .fontSize(TwFontSizes.xs)
              .textColor(muted)
              .pb(TwSpacing.s2),
          _VariantCardDemo(isDark: isDark),

          SizedBox(height: TwSpacing.s8),
        ],
      ).p(TwSpacing.s4),
    );
  }
}

// ---------------------------------------------------------------------------
// Base card demo
// ---------------------------------------------------------------------------

class _BaseCardDemo extends StatelessWidget {
  const _BaseCardDemo({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final baseCard = TwStyle(
      padding: TwSpacing.s5.all,
      backgroundColor: isDark ? TwColors.zinc.shade800 : TwColors.white,
      borderRadius: TwRadii.xl.all,
      shadows: TwShadows.md,
    );

    return baseCard.apply(child: _profileCardContent(isDark: isDark));
  }
}

// ---------------------------------------------------------------------------
// Merged card demo
// ---------------------------------------------------------------------------

class _MergedCardDemo extends StatelessWidget {
  const _MergedCardDemo({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final baseCard = TwStyle(
      padding: TwSpacing.s5.all,
      backgroundColor: isDark ? TwColors.zinc.shade800 : TwColors.white,
      borderRadius: TwRadii.xl.all,
      shadows: TwShadows.md,
    );

    final accentOverride = TwStyle(
      backgroundColor: isDark
          ? TwColors.indigo.shade900
          : TwColors.indigo.shade50,
      shadows: TwShadows.lg,
    );

    final merged = baseCard.merge(accentOverride);

    return merged.apply(
      child: _profileCardContent(
        isDark: isDark,
        accentColor: TwColors.indigo.shade500,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Variant card demo
// ---------------------------------------------------------------------------

class _VariantCardDemo extends StatelessWidget {
  const _VariantCardDemo({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final themedCard = TwStyle(
      padding: TwSpacing.s5.all,
      backgroundColor: TwColors.white,
      borderRadius: TwRadii.xl.all,
      shadows: TwShadows.md,
      textStyle: TextStyle(color: TwColors.slate.shade800),
      variants: {
        TwVariant.dark: TwStyle(
          backgroundColor: TwColors.zinc.shade800,
          shadows: TwShadows.lg,
          textStyle: TextStyle(color: TwColors.zinc.shade100),
        ),
      },
    );

    // Canonical two-step pattern: resolve then apply.
    final resolved = themedCard.resolve(context);

    return resolved.apply(
      child: _profileCardContent(isDark: isDark),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared card content
// ---------------------------------------------------------------------------

Widget _profileCardContent({
  required bool isDark,
  Color? accentColor,
}) {
  final accent = accentColor ?? TwColors.blue.shade500;
  final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
  final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;

  return Row(
    children: [
      // Avatar placeholder
      Icon(Icons.person, size: 40, color: TwColors.white)
          .p(TwSpacing.s2)
          .bg(accent)
          .rounded(TwRadii.full),
      SizedBox(width: TwSpacing.s4),
      // Name and subtitle
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jane Developer')
                .bold()
                .fontSize(TwFontSizes.lg)
                .textColor(fg),
            SizedBox(height: TwSpacing.s1),
            Text('Flutter engineer who ships with style.')
                .fontSize(TwFontSizes.sm)
                .textColor(muted),
          ],
        ),
      ),
      // Action button area
      Icon(Icons.arrow_forward_ios, size: 16, color: muted),
    ],
  );
}
