// Package entry point for tailwind_flutter.
//
// Tailwind CSS design tokens and utility-first styling API for Flutter.
// Exports are organized by tier and uncommented as each module is implemented.

export 'src/tailwind_flutter_version.dart';
export 'src/theme/tw_theme.dart';
export 'src/theme/tw_theme_data.dart';
export 'src/theme/tw_theme_extension.dart';
export 'src/tokens/breakpoints.dart';
export 'src/tokens/colors.dart';
export 'src/tokens/opacity.dart';
export 'src/tokens/radius.dart';
export 'src/tokens/shadows.dart';
export 'src/tokens/spacing.dart';
export 'src/tokens/typography.dart';

// ----- Widget Extensions (Tier 2) -----
export 'src/extensions/text_extensions.dart';
export 'src/extensions/widget_extensions.dart';

// ----- Style Composition (Tier 3) -----
// export 'src/styles/tw_style.dart';
// export 'src/styles/tw_variant.dart';
// export 'src/styles/tw_styled_widget.dart';
