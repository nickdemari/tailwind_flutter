import 'package:flutter/material.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

/// Demonstrates Tier 2: Widget and Text extensions (before/after comparisons).
class ExtensionsPage extends StatelessWidget {
  const ExtensionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? TwColors.zinc.shade900 : TwColors.white;
    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Widget Extensions')
              .bold()
              .fontSize(TwFontSizes.xl)
              .textColor(fg)
              .pb(TwSpacing.s1),
          Text('Same visual result, dramatically less boilerplate.')
              .fontSize(TwFontSizes.sm)
              .textColor(muted)
              .pb(TwSpacing.s6),

          // -- Example 1: Styled container --
          _ComparisonCard(
            title: '1. Styled Container',
            subtitle: 'padding + background + rounded corners',
            isDark: isDark,
            rawFlutter: _rawStyledContainer(),
            tailwindFlutter: _twStyledContainer(),
          ),

          SizedBox(height: TwSpacing.s6),

          // -- Example 2: Text styling --
          _ComparisonCard(
            title: '2. Text Styling',
            subtitle: 'bold + fontSize + color',
            isDark: isDark,
            rawFlutter: _rawStyledText(),
            tailwindFlutter: _twStyledText(),
          ),

          SizedBox(height: TwSpacing.s6),

          // -- Example 3: Composed widget --
          _ComparisonCard(
            title: '3. Composed Widget',
            subtitle: 'margin + padding + bg + shadow + rounded',
            isDark: isDark,
            rawFlutter: _rawComposedWidget(bg),
            tailwindFlutter: _twComposedWidget(bg),
          ),

          SizedBox(height: TwSpacing.s6),

          // -- Example 4: Borders & Gradient --
          _ComparisonCard(
            title: '4. Borders & Gradient',
            subtitle: 'border + gradient background',
            isDark: isDark,
            rawFlutter: _rawBorderGradient(),
            tailwindFlutter: _twBorderGradient(),
          ),

          SizedBox(height: TwSpacing.s6),

          // -- Example 5: Text Decorations & Transforms --
          _ComparisonCard(
            title: '5. Text Decorations',
            subtitle: 'underline + fontFamily + capitalize',
            isDark: isDark,
            rawFlutter: _rawTextDecorations(),
            tailwindFlutter: _twTextDecorations(),
          ),

          SizedBox(height: TwSpacing.s6),

          // -- Example 6: Visibility & Aspect Ratio --
          _ComparisonCard(
            title: '6. Visibility & Aspect Ratio',
            subtitle: 'aspectRatio + visible/invisible',
            isDark: isDark,
            rawFlutter: _rawVisibilityAspect(),
            tailwindFlutter: _twVisibilityAspect(),
          ),

          SizedBox(height: TwSpacing.s6),

          // -- Example 7: Flex & Tooltip --
          _ComparisonCard(
            title: '7. Flex & Tooltip',
            subtitle: 'expanded + tooltip',
            isDark: isDark,
            rawFlutter: _rawFlexTooltip(),
            tailwindFlutter: _twFlexTooltip(),
          ),

          SizedBox(height: TwSpacing.s8),
        ],
      ).p(TwSpacing.s4),
    );
  }

  // -------------------------------------------------------------------------
  // Example 1: Styled container
  // -------------------------------------------------------------------------

  Widget _rawStyledContainer() {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TwRadii.lg),
        child: ColoredBox(
          color: TwColors.blue.shade100,
          child: Padding(
            padding: EdgeInsets.all(TwSpacing.s4),
            child: Text('Raw Flutter')
                .bold()
                .textColor(TwColors.blue.shade800),
          ),
        ),
      ),
    );
  }

  Widget _twStyledContainer() {
    return Text('tailwind_flutter')
        .bold()
        .textColor(TwColors.blue.shade800)
        .p(TwSpacing.s4)
        .bg(TwColors.blue.shade100)
        .rounded(TwRadii.lg)
        .p(TwSpacing.s4);
  }

  // -------------------------------------------------------------------------
  // Example 2: Text styling
  // -------------------------------------------------------------------------

  Widget _rawStyledText() {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s4),
      child: const Text(
        'Raw Flutter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFFBE185D), // pink-700
        ),
      ),
    );
  }

  Widget _twStyledText() {
    return Text('tailwind_flutter')
        .bold()
        .fontSize(TwFontSizes.xl)
        .textColor(TwColors.pink.shade700)
        .p(TwSpacing.s4);
  }

  // -------------------------------------------------------------------------
  // Example 3: Composed widget
  // -------------------------------------------------------------------------

  Widget _rawComposedWidget(Color bgColor) {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s3),
      child: DecoratedBox(
        decoration: BoxDecoration(boxShadow: TwShadows.md),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TwRadii.xl),
          child: ColoredBox(
            color: bgColor,
            child: Padding(
              padding: EdgeInsets.all(TwSpacing.s5),
              child: Text('Raw Flutter')
                  .bold()
                  .textColor(TwColors.emerald.shade600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _twComposedWidget(Color bgColor) {
    return Text('tailwind_flutter')
        .bold()
        .textColor(TwColors.emerald.shade600)
        .p(TwSpacing.s5)
        .bg(bgColor)
        .rounded(TwRadii.xl)
        .shadow(TwShadows.md)
        .m(TwSpacing.s3);
  }

  // -------------------------------------------------------------------------
  // Example 4: Borders & Gradient
  // -------------------------------------------------------------------------

  Widget _rawBorderGradient() {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: TwColors.purple.shade300,
            width: 2,
          ),
          gradient: LinearGradient(
            colors: [
              TwColors.blue.shade400,
              TwColors.purple.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(TwRadii.lg),
        ),
        child: Padding(
          padding: EdgeInsets.all(TwSpacing.s4),
          child: Text('Raw Flutter')
              .bold()
              .textColor(TwColors.white),
        ),
      ),
    );
  }

  Widget _twBorderGradient() {
    return Text('tailwind_flutter')
        .bold()
        .textColor(TwColors.white)
        .p(TwSpacing.s4)
        .gradient(
          LinearGradient(
            colors: [
              TwColors.blue.shade400,
              TwColors.purple.shade400,
            ],
          ),
        )
        .border(color: TwColors.purple.shade300, width: 2)
        .rounded(TwRadii.lg)
        .p(TwSpacing.s4);
  }

  // -------------------------------------------------------------------------
  // Example 5: Text Decorations & Transforms
  // -------------------------------------------------------------------------

  Widget _rawTextDecorations() {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s4),
      child: Text(
        'Hello World',
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: TwColors.indigo.shade600,
        ),
      ),
    );
  }

  Widget _twTextDecorations() {
    return Text('hello world')
        .underline()
        .fontFamily('monospace')
        .bold()
        .fontSize(TwFontSizes.base)
        .textColor(TwColors.indigo.shade600)
        .capitalize()
        .p(TwSpacing.s4);
  }

  // -------------------------------------------------------------------------
  // Example 6: Visibility & Aspect Ratio
  // -------------------------------------------------------------------------

  Widget _rawVisibilityAspect() {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(TwRadii.md),
              child: ColoredBox(
                color: TwColors.amber.shade200,
                child: Center(
                  child: Text('16:9')
                      .bold()
                      .textColor(TwColors.amber.shade800),
                ),
              ),
            ),
          ),
          SizedBox(height: TwSpacing.s2),
          Visibility(
            visible: false,
            child: Text('I am hidden')
                .textColor(TwColors.red.shade500),
          ),
          Text('(hidden text above)')
              .fontSize(TwFontSizes.xs)
              .textColor(TwColors.slate.shade400),
        ],
      ),
    );
  }

  Widget _twVisibilityAspect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('16:9')
            .bold()
            .textColor(TwColors.amber.shade800)
            .center()
            .bg(TwColors.amber.shade200)
            .rounded(TwRadii.md)
            .aspectRatio(16 / 9),
        SizedBox(height: TwSpacing.s2),
        Text('I am hidden')
            .textColor(TwColors.red.shade500)
            .visible(visible: false),
        Text('(hidden text above)')
            .fontSize(TwFontSizes.xs)
            .textColor(TwColors.slate.shade400),
      ],
    ).p(TwSpacing.s4);
  }

  // -------------------------------------------------------------------------
  // Example 7: Flex & Tooltip
  // -------------------------------------------------------------------------

  Widget _rawFlexTooltip() {
    return Padding(
      padding: EdgeInsets.all(TwSpacing.s4),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: 'This fills available space',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(TwRadii.md),
                child: ColoredBox(
                  color: TwColors.teal.shade100,
                  child: Padding(
                    padding: EdgeInsets.all(TwSpacing.s3),
                    child: Text('Expanded')
                        .bold()
                        .textColor(TwColors.teal.shade700),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: TwSpacing.s2),
          ClipRRect(
            borderRadius: BorderRadius.circular(TwRadii.md),
            child: ColoredBox(
              color: TwColors.orange.shade100,
              child: Padding(
                padding: EdgeInsets.all(TwSpacing.s3),
                child: Text('Fixed')
                    .bold()
                    .textColor(TwColors.orange.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twFlexTooltip() {
    return Row(
      children: [
        Text('Expanded')
            .bold()
            .textColor(TwColors.teal.shade700)
            .p(TwSpacing.s3)
            .bg(TwColors.teal.shade100)
            .rounded(TwRadii.md)
            .tooltip('This fills available space')
            .expanded(),
        SizedBox(width: TwSpacing.s2),
        Text('Fixed')
            .bold()
            .textColor(TwColors.orange.shade700)
            .p(TwSpacing.s3)
            .bg(TwColors.orange.shade100)
            .rounded(TwRadii.md),
      ],
    ).p(TwSpacing.s4);
  }
}

// ---------------------------------------------------------------------------
// Comparison card layout
// ---------------------------------------------------------------------------

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.rawFlutter,
    required this.tailwindFlutter,
  });

  final String title;
  final String subtitle;
  final bool isDark;
  final Widget rawFlutter;
  final Widget tailwindFlutter;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? TwColors.zinc.shade800 : TwColors.slate.shade50;
    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;
    final labelBg = isDark ? TwColors.zinc.shade700 : TwColors.slate.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title)
            .bold()
            .fontSize(TwFontSizes.base)
            .textColor(fg),
        Text(subtitle)
            .fontSize(TwFontSizes.xs)
            .textColor(muted)
            .pb(TwSpacing.s3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('Raw Flutter')
                      .fontSize(TwFontSizes.xs)
                      .fontWeight(TwFontWeights.semibold)
                      .textColor(TwColors.red.shade500)
                      .p(TwSpacing.s1)
                      .bg(labelBg)
                      .rounded(TwRadii.sm),
                  SizedBox(height: TwSpacing.s2),
                  rawFlutter,
                ],
              ).p(TwSpacing.s3).bg(cardBg).rounded(TwRadii.lg),
            ),
            SizedBox(width: TwSpacing.s3),
            Expanded(
              child: Column(
                children: [
                  Text('tailwind_flutter')
                      .fontSize(TwFontSizes.xs)
                      .fontWeight(TwFontWeights.semibold)
                      .textColor(TwColors.emerald.shade500)
                      .p(TwSpacing.s1)
                      .bg(labelBg)
                      .rounded(TwRadii.sm),
                  SizedBox(height: TwSpacing.s2),
                  tailwindFlutter,
                ],
              ).p(TwSpacing.s3).bg(cardBg).rounded(TwRadii.lg),
            ),
          ],
        ),
      ],
    );
  }
}
