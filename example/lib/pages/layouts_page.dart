import 'package:flutter/material.dart';
import 'package:tailwind_flutter/tailwind_flutter.dart';

/// Demonstrates real-world layouts built entirely with tailwind_flutter.
///
/// Three examples that would make any Reddit skeptic think twice:
/// a profile card, a pricing table, and a settings list.
class LayoutsPage extends StatelessWidget {
  const LayoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Real-World Layouts')
              .bold()
              .headline(.sm)
              .textColor(fg)
              .pb(TwSpacing.s1),
          Text('Complex UI patterns built with tailwind_flutter — no raw '
                  'Container nesting required.')
              .body(.md)
              .textColor(muted)
              .pb(TwSpacing.s6),

          // -- Example 1: Profile Card --
          _sectionHeader('1. Profile Card', isDark: isDark),
          _ProfileCard(isDark: isDark),

          SizedBox(height: TwSpacing.s8),

          // -- Example 2: Pricing Table --
          _sectionHeader('2. Pricing Table', isDark: isDark),
          _PricingTable(isDark: isDark),

          SizedBox(height: TwSpacing.s8),

          // -- Example 3: Settings List --
          _sectionHeader('3. Settings List', isDark: isDark),
          _SettingsList(isDark: isDark),

          SizedBox(height: TwSpacing.s8),
        ],
      ).p(TwSpacing.s4),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header helper
// ---------------------------------------------------------------------------

Widget _sectionHeader(String text, {required bool isDark}) {
  final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
  return Text(text)
      .bold()
      .title(.lg)
      .textColor(fg)
      .pb(TwSpacing.s3);
}

// ===========================================================================
// Example 1: Profile Card
// ===========================================================================

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? TwColors.zinc.shade800 : TwColors.white;
    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Avatar: colored circle with initials
            Text('JD')
                .bold()
                .title(.lg)
                .textColor(TwColors.white)
                .center()
                .bg(TwColors.violet.shade500)
                .roundedFull()
                .size(64, 64),
            SizedBox(width: TwSpacing.s4),
            // Name & bio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jane Developer')
                      .bold()
                      .title(.lg)
                      .textColor(fg),
                  SizedBox(height: TwSpacing.s1),
                  Text('Flutter engineer crafting pixel-perfect UIs. '
                          'Tailwind enthusiast. Coffee addict.')
                      .body(.md)
                      .textColor(muted),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: TwSpacing.s4),
        // Action buttons
        Row(
          children: [
            Text('Follow')
                .bold()
                .label(.lg)
                .textColor(TwColors.white)
                .px(TwSpacing.s5)
                .py(TwSpacing.s2)
                .bg(TwColors.blue.shade500)
                .rounded(TwRadii.lg),
            SizedBox(width: TwSpacing.s3),
            Text('Message')
                .bold()
                .label(.lg)
                .textColor(
                  isDark ? TwColors.zinc.shade200 : TwColors.slate.shade700,
                )
                .px(TwSpacing.s5)
                .py(TwSpacing.s2)
                .bg(
                  isDark ? TwColors.zinc.shade700 : TwColors.slate.shade100,
                )
                .rounded(TwRadii.lg),
          ],
        ),
      ],
    )
        .p(TwSpacing.s5)
        .bg(cardBg)
        .rounded(TwRadii.xl)
        .shadow(TwShadows.md);
  }
}

// ===========================================================================
// Example 2: Pricing Table
// ===========================================================================

class _PricingTable extends StatelessWidget {
  const _PricingTable({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // Base style for all tier cards
    final baseCard = TwStyle(
      padding: TwSpacing.s5.all,
      backgroundColor: isDark ? TwColors.zinc.shade800 : TwColors.white,
      borderRadius: TwRadii.xl.all,
      shadows: TwShadows.sm,
    );

    // Highlighted card merges a more prominent background + bigger shadow
    final highlightOverride = TwStyle(
      backgroundColor:
          isDark ? TwColors.blue.shade900 : TwColors.blue.shade50,
      shadows: TwShadows.lg,
    );
    final highlightedCard = baseCard.merge(highlightOverride);

    // A themed card using TwVariant for automatic dark-mode resolution
    final themedCard = TwStyle(
      padding: TwSpacing.s5.all,
      backgroundColor: TwColors.white,
      borderRadius: TwRadii.xl.all,
      shadows: TwShadows.sm,
      variants: {
        TwVariant.dark: TwStyle(
          backgroundColor: TwColors.zinc.shade800,
          shadows: TwShadows.md,
        ),
      },
    );
    final resolvedThemed = themedCard.resolve(context);

    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;
    final accent = TwColors.blue.shade500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -- Starter tier (uses resolve/apply pattern) --
        resolvedThemed
            .apply(
              child: _tierContent(
                tierName: 'Starter',
                price: r'$9',
                period: '/mo',
                features: ['5 projects', '10 GB storage', 'Email support'],
                ctaBg: isDark
                    ? TwColors.zinc.shade700
                    : TwColors.slate.shade200,
                ctaFg:
                    isDark ? TwColors.zinc.shade200 : TwColors.slate.shade700,
                fg: fg,
                muted: muted,
              ),
            )
            .expanded(),

        SizedBox(width: TwSpacing.s3),

        // -- Pro tier (highlighted with merge) --
        highlightedCard
            .apply(
              child: _tierContent(
                tierName: 'Pro',
                price: r'$29',
                period: '/mo',
                features: [
                  'Unlimited projects',
                  '100 GB storage',
                  'Priority support',
                  'API access',
                ],
                ctaBg: accent,
                ctaFg: TwColors.white,
                fg: fg,
                muted: isDark
                    ? TwColors.blue.shade200
                    : TwColors.blue.shade700,
                badge: 'POPULAR',
              ),
            )
            .expanded(),

        SizedBox(width: TwSpacing.s3),

        // -- Enterprise tier (base card) --
        baseCard
            .apply(
              child: _tierContent(
                tierName: 'Enterprise',
                price: r'$99',
                period: '/mo',
                features: [
                  'Everything in Pro',
                  '1 TB storage',
                  'Dedicated support',
                  'SSO & audit logs',
                ],
                ctaBg: isDark
                    ? TwColors.zinc.shade700
                    : TwColors.slate.shade200,
                ctaFg:
                    isDark ? TwColors.zinc.shade200 : TwColors.slate.shade700,
                fg: fg,
                muted: muted,
              ),
            )
            .expanded(),
      ],
    );
  }

  Widget _tierContent({
    required String tierName,
    required String price,
    required String period,
    required List<String> features,
    required Color ctaBg,
    required Color ctaFg,
    required Color fg,
    required Color muted,
    String? badge,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badge != null)
          Text(badge)
              .bold()
              .label(.md)
              .textColor(TwColors.white)
              .px(TwSpacing.s2)
              .py(TwSpacing.s0_5)
              .bg(TwColors.blue.shade500)
              .rounded(TwRadii.full)
              .pb(TwSpacing.s2),
        Text(tierName)
            .bold()
            .title(.md)
            .textColor(fg),
        SizedBox(height: TwSpacing.s1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(price)
                  .bold()
                  .headline(.md)
                  .textColor(fg),
            ),
            Text(period)
                .body(.md)
                .textColor(muted)
                .pb(TwSpacing.s1),
          ],
        ),
        SizedBox(height: TwSpacing.s4),
        ...features.map(
          (f) => Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 16,
                color: TwColors.emerald.shade500,
              ),
              SizedBox(width: TwSpacing.s2),
              Expanded(
                child: Text(f).body(.md).textColor(muted),
              ),
            ],
          ).pb(TwSpacing.s2),
        ),
        SizedBox(height: TwSpacing.s4),
        // CTA button
        Text('Get Started')
            .align(TextAlign.center)
            .bold()
            .label(.lg)
            .textColor(ctaFg)
            .py(TwSpacing.s2)
            .bg(ctaBg)
            .rounded(TwRadii.lg),
      ],
    );
  }
}

// ===========================================================================
// Example 3: Settings List
// ===========================================================================

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? TwColors.zinc.shade800 : TwColors.white;
    final fg = isDark ? TwColors.zinc.shade100 : TwColors.slate.shade800;
    final muted = isDark ? TwColors.zinc.shade400 : TwColors.slate.shade500;
    final divider =
        isDark ? TwColors.zinc.shade700 : TwColors.slate.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text('ACCOUNT')
            .uppercase()
            .bold()
            .label(.md)
            .letterSpacing(1.2)
            .textColor(muted)
            .pb(TwSpacing.s3),

        // Settings rows inside a card
        Column(
          children: [
            _settingsRow(
              icon: Icons.person_outline,
              title: 'Profile',
              subtitle: 'Name, email, avatar',
              trailing: Icon(Icons.chevron_right, color: muted, size: 20),
              fg: fg,
              muted: muted,
              dividerColor: divider,
              showDivider: true,
            ),
            _settingsRow(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Push, email, in-app',
              trailing: _togglePlaceholder(isOn: true),
              fg: fg,
              muted: muted,
              dividerColor: divider,
              showDivider: true,
            ),
            _settingsRow(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: 'Theme, colors, layout',
              trailing: Icon(Icons.chevron_right, color: muted, size: 20),
              fg: fg,
              muted: muted,
              dividerColor: divider,
              showDivider: true,
            ),
            _settingsRow(
              icon: Icons.lock_outline,
              title: 'Privacy',
              subtitle: 'Permissions, data sharing',
              trailing: Icon(Icons.chevron_right, color: muted, size: 20),
              fg: fg,
              muted: muted,
              dividerColor: divider,
              showDivider: true,
            ),
            _settingsRow(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'System, light, dark',
              trailing: _togglePlaceholder(isOn: isDark),
              fg: fg,
              muted: muted,
              dividerColor: divider,
              showDivider: true,
            ),
            _settingsRow(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Version, licenses, credits',
              trailing: Icon(Icons.chevron_right, color: muted, size: 20),
              fg: fg,
              muted: muted,
              dividerColor: divider,
              showDivider: false, // last row, no divider
            ),
          ],
        )
            .bg(cardBg)
            .rounded(TwRadii.xl)
            .shadow(TwShadows.sm),
      ],
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required Color fg,
    required Color muted,
    required Color dividerColor,
    required bool showDivider,
  }) {
    final content = Row(
      children: [
        Icon(icon, size: 22, color: muted).pr(TwSpacing.s4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title)
                  .fontWeight(TwFontWeights.medium)
                  .title(.md)
                  .textColor(fg),
              SizedBox(height: TwSpacing.s0_5),
              Text(subtitle)
                  .body(.md)
                  .textColor(muted),
            ],
          ),
        ),
        trailing,
      ],
    ).px(TwSpacing.s4).py(TwSpacing.s3);

    if (showDivider) {
      return content.borderBottom(color: dividerColor);
    }
    return content;
  }

  /// A simple visual toggle placeholder built from tokens.
  Widget _togglePlaceholder({required bool isOn}) {
    final trackColor =
        isOn ? TwColors.blue.shade500 : TwColors.slate.shade300;
    final knobAlign = isOn ? Alignment.centerRight : Alignment.centerLeft;

    return SizedBox(
      width: 44,
      height: 24,
      child: Stack(
        children: [
          // Track
          Container()
              .bg(trackColor)
              .rounded(TwRadii.full)
              .size(44, 24),
          // Knob
          Align(
            alignment: knobAlign,
            child: Container()
                .bg(TwColors.white)
                .roundedFull()
                .size(20, 20)
                .m(TwSpacing.s0_5),
          ),
        ],
      ),
    );
  }
}
