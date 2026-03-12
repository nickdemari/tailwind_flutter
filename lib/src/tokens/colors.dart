import 'package:flutter/widgets.dart';

/// A Tailwind CSS v4 color family containing 11 shade variants.
///
/// Each color family (e.g., red, blue, slate) contains shades from 50
/// (lightest) through 950 (darkest). Access individual shades via getters:
///
/// ```dart
/// final color = TwColors.blue.shade500; // Color(0xFF2B7FFF)
/// ```
///
/// This is an extension type wrapping a named-field record of 11 [Color]
/// values, providing zero-cost abstraction at runtime.
extension type const TwColorFamily._(
    ({
      Color shade50,
      Color shade100,
      Color shade200,
      Color shade300,
      Color shade400,
      Color shade500,
      Color shade600,
      Color shade700,
      Color shade800,
      Color shade900,
      Color shade950,
    }) _) {
  /// Creates a [TwColorFamily] with all 11 shade values.
  const TwColorFamily({
    required Color shade50,
    required Color shade100,
    required Color shade200,
    required Color shade300,
    required Color shade400,
    required Color shade500,
    required Color shade600,
    required Color shade700,
    required Color shade800,
    required Color shade900,
    required Color shade950,
  }) : this._(
          (
            shade50: shade50,
            shade100: shade100,
            shade200: shade200,
            shade300: shade300,
            shade400: shade400,
            shade500: shade500,
            shade600: shade600,
            shade700: shade700,
            shade800: shade800,
            shade900: shade900,
            shade950: shade950,
          ),
        );

  /// The lightest shade (50).
  Color get shade50 => _.shade50;

  /// Shade 100.
  Color get shade100 => _.shade100;

  /// Shade 200.
  Color get shade200 => _.shade200;

  /// Shade 300.
  Color get shade300 => _.shade300;

  /// Shade 400.
  Color get shade400 => _.shade400;

  /// Shade 500 -- the "base" shade.
  Color get shade500 => _.shade500;

  /// Shade 600.
  Color get shade600 => _.shade600;

  /// Shade 700.
  Color get shade700 => _.shade700;

  /// Shade 800.
  Color get shade800 => _.shade800;

  /// Shade 900.
  Color get shade900 => _.shade900;

  /// The darkest shade (950).
  Color get shade950 => _.shade950;
}

/// The complete Tailwind CSS v4 color palette.
///
/// Contains 22 color families, each with 11 shades (shade50 through shade950),
/// plus three semantic colors ([black], [white], and [transparent]).
///
/// All color values are `static const` and use exact hex values from the
/// official Tailwind CSS v4 palette. Colors are fully opaque (`0xFF` alpha)
/// except [transparent].
///
/// ```dart
/// // Access a specific shade
/// final primary = TwColors.blue.shade500;
///
/// // Semantic colors
/// final bg = TwColors.white;
/// ```
abstract final class TwColors {
  // ---------------------------------------------------------------------------
  // Semantic colors
  // ---------------------------------------------------------------------------

  /// Pure black (`#000000`).
  static const black = Color(0xFF000000);

  /// Pure white (`#FFFFFF`).
  static const white = Color(0xFFFFFFFF);

  /// Fully transparent.
  static const transparent = Color(0x00000000);

  // ---------------------------------------------------------------------------
  // Gray scale families
  // ---------------------------------------------------------------------------

  /// Slate color family -- cool blue-gray tones.
  static const slate = TwColorFamily(
    shade50: Color(0xFFF8FAFC),
    shade100: Color(0xFFF1F5F9),
    shade200: Color(0xFFE2E8F0),
    shade300: Color(0xFFCBD5E1),
    shade400: Color(0xFF94A3B8),
    shade500: Color(0xFF62748E),
    shade600: Color(0xFF465568),
    shade700: Color(0xFF334155),
    shade800: Color(0xFF1E293B),
    shade900: Color(0xFF0F172A),
    shade950: Color(0xFF020618),
  );

  /// Gray color family -- neutral gray tones.
  static const gray = TwColorFamily(
    shade50: Color(0xFFF9FAFB),
    shade100: Color(0xFFF3F4F6),
    shade200: Color(0xFFE5E7EB),
    shade300: Color(0xFFD1D5DB),
    shade400: Color(0xFF9CA3AF),
    shade500: Color(0xFF6A7282),
    shade600: Color(0xFF4A5565),
    shade700: Color(0xFF374151),
    shade800: Color(0xFF1F2937),
    shade900: Color(0xFF111827),
    shade950: Color(0xFF030712),
  );

  /// Zinc color family -- cool neutral tones.
  static const zinc = TwColorFamily(
    shade50: Color(0xFFFAFAFA),
    shade100: Color(0xFFF4F4F5),
    shade200: Color(0xFFE4E4E7),
    shade300: Color(0xFFD4D4D8),
    shade400: Color(0xFFA1A1AA),
    shade500: Color(0xFF71717B),
    shade600: Color(0xFF52525B),
    shade700: Color(0xFF3F3F46),
    shade800: Color(0xFF27272A),
    shade900: Color(0xFF18181B),
    shade950: Color(0xFF09090B),
  );

  /// Neutral color family -- pure neutral tones.
  static const neutral = TwColorFamily(
    shade50: Color(0xFFFAFAFA),
    shade100: Color(0xFFF5F5F5),
    shade200: Color(0xFFE5E5E5),
    shade300: Color(0xFFD4D4D4),
    shade400: Color(0xFFA3A3A3),
    shade500: Color(0xFF737373),
    shade600: Color(0xFF525252),
    shade700: Color(0xFF404040),
    shade800: Color(0xFF262626),
    shade900: Color(0xFF171717),
    shade950: Color(0xFF0A0A0A),
  );

  /// Stone color family -- warm gray tones.
  static const stone = TwColorFamily(
    shade50: Color(0xFFFAFAF9),
    shade100: Color(0xFFF5F5F4),
    shade200: Color(0xFFE7E5E4),
    shade300: Color(0xFFD6D3D1),
    shade400: Color(0xFFA8A29E),
    shade500: Color(0xFF79716B),
    shade600: Color(0xFF57534E),
    shade700: Color(0xFF44403C),
    shade800: Color(0xFF292524),
    shade900: Color(0xFF1C1917),
    shade950: Color(0xFF0C0A09),
  );

  // ---------------------------------------------------------------------------
  // Warm color families
  // ---------------------------------------------------------------------------

  /// Red color family.
  static const red = TwColorFamily(
    shade50: Color(0xFFFEF2F2),
    shade100: Color(0xFFFEE2E2),
    shade200: Color(0xFFFECACA),
    shade300: Color(0xFFFCA5A5),
    shade400: Color(0xFFF87171),
    shade500: Color(0xFFFB2C36),
    shade600: Color(0xFFE7000B),
    shade700: Color(0xFFC10007),
    shade800: Color(0xFF9F0712),
    shade900: Color(0xFF7F1118),
    shade950: Color(0xFF460809),
  );

  /// Orange color family.
  static const orange = TwColorFamily(
    shade50: Color(0xFFFFF7ED),
    shade100: Color(0xFFFFEDD5),
    shade200: Color(0xFFFED7AA),
    shade300: Color(0xFFFDBA74),
    shade400: Color(0xFFFB923C),
    shade500: Color(0xFFFF6900),
    shade600: Color(0xFFEA580C),
    shade700: Color(0xFFC2410C),
    shade800: Color(0xFF9A3412),
    shade900: Color(0xFF7C2D12),
    shade950: Color(0xFF441306),
  );

  /// Amber color family.
  static const amber = TwColorFamily(
    shade50: Color(0xFFFFFBEB),
    shade100: Color(0xFFFEF3C7),
    shade200: Color(0xFFFDE68A),
    shade300: Color(0xFFFCD34D),
    shade400: Color(0xFFFBBF24),
    shade500: Color(0xFFFE9A00),
    shade600: Color(0xFFD97706),
    shade700: Color(0xFFB45309),
    shade800: Color(0xFF92400E),
    shade900: Color(0xFF78350F),
    shade950: Color(0xFF461901),
  );

  /// Yellow color family.
  static const yellow = TwColorFamily(
    shade50: Color(0xFFFEFCE8),
    shade100: Color(0xFFFEF9C3),
    shade200: Color(0xFFFEF08A),
    shade300: Color(0xFFFDE047),
    shade400: Color(0xFFFACC15),
    shade500: Color(0xFFF0B100),
    shade600: Color(0xFFCA8A04),
    shade700: Color(0xFFA16207),
    shade800: Color(0xFF854D0E),
    shade900: Color(0xFF713F12),
    shade950: Color(0xFF432004),
  );

  /// Lime color family.
  static const lime = TwColorFamily(
    shade50: Color(0xFFF7FEE7),
    shade100: Color(0xFFECFCCB),
    shade200: Color(0xFFD9F99D),
    shade300: Color(0xFFBEF264),
    shade400: Color(0xFFA3E635),
    shade500: Color(0xFF7CCF00),
    shade600: Color(0xFF65A30D),
    shade700: Color(0xFF4D7C0F),
    shade800: Color(0xFF3F6212),
    shade900: Color(0xFF365314),
    shade950: Color(0xFF192E03),
  );

  // ---------------------------------------------------------------------------
  // Cool color families
  // ---------------------------------------------------------------------------

  /// Green color family.
  static const green = TwColorFamily(
    shade50: Color(0xFFF0FDF4),
    shade100: Color(0xFFDCFCE7),
    shade200: Color(0xFFBBF7D0),
    shade300: Color(0xFF86EFAC),
    shade400: Color(0xFF4ADE80),
    shade500: Color(0xFF00C950),
    shade600: Color(0xFF16A34A),
    shade700: Color(0xFF15803D),
    shade800: Color(0xFF166534),
    shade900: Color(0xFF14532D),
    shade950: Color(0xFF032E15),
  );

  /// Emerald color family.
  static const emerald = TwColorFamily(
    shade50: Color(0xFFECFDF5),
    shade100: Color(0xFFD1FAE5),
    shade200: Color(0xFFA7F3D0),
    shade300: Color(0xFF6EE7B7),
    shade400: Color(0xFF34D399),
    shade500: Color(0xFF00BC7D),
    shade600: Color(0xFF059669),
    shade700: Color(0xFF047857),
    shade800: Color(0xFF065F46),
    shade900: Color(0xFF064E3B),
    shade950: Color(0xFF002C22),
  );

  /// Teal color family.
  static const teal = TwColorFamily(
    shade50: Color(0xFFF0FDFA),
    shade100: Color(0xFFCCFBF1),
    shade200: Color(0xFF99F6E4),
    shade300: Color(0xFF5EEAD4),
    shade400: Color(0xFF2DD4BF),
    shade500: Color(0xFF00BBA7),
    shade600: Color(0xFF0D9488),
    shade700: Color(0xFF0F766E),
    shade800: Color(0xFF115E59),
    shade900: Color(0xFF134E4A),
    shade950: Color(0xFF022F2E),
  );

  /// Cyan color family.
  static const cyan = TwColorFamily(
    shade50: Color(0xFFECFEFF),
    shade100: Color(0xFFCFFAFE),
    shade200: Color(0xFFA5F3FC),
    shade300: Color(0xFF67E8F9),
    shade400: Color(0xFF22D3EE),
    shade500: Color(0xFF00B8DB),
    shade600: Color(0xFF0891B2),
    shade700: Color(0xFF0E7490),
    shade800: Color(0xFF155E75),
    shade900: Color(0xFF164E63),
    shade950: Color(0xFF053345),
  );

  /// Sky color family.
  static const sky = TwColorFamily(
    shade50: Color(0xFFF0F9FF),
    shade100: Color(0xFFE0F2FE),
    shade200: Color(0xFFBAE6FD),
    shade300: Color(0xFF7DD3FC),
    shade400: Color(0xFF38BDF8),
    shade500: Color(0xFF00A6F4),
    shade600: Color(0xFF0284C7),
    shade700: Color(0xFF0369A1),
    shade800: Color(0xFF075985),
    shade900: Color(0xFF0C4A6E),
    shade950: Color(0xFF052F4A),
  );

  /// Blue color family.
  static const blue = TwColorFamily(
    shade50: Color(0xFFEFF6FF),
    shade100: Color(0xFFDBEAFE),
    shade200: Color(0xFFBFDBFE),
    shade300: Color(0xFF93C5FD),
    shade400: Color(0xFF60A5FA),
    shade500: Color(0xFF2B7FFF),
    shade600: Color(0xFF2563EB),
    shade700: Color(0xFF1D4ED8),
    shade800: Color(0xFF1E40AF),
    shade900: Color(0xFF1E3A8A),
    shade950: Color(0xFF162556),
  );

  /// Indigo color family.
  static const indigo = TwColorFamily(
    shade50: Color(0xFFEEF2FF),
    shade100: Color(0xFFE0E7FF),
    shade200: Color(0xFFC7D2FE),
    shade300: Color(0xFFA5B4FC),
    shade400: Color(0xFF818CF8),
    shade500: Color(0xFF615FFF),
    shade600: Color(0xFF4F46E5),
    shade700: Color(0xFF4338CA),
    shade800: Color(0xFF3730A3),
    shade900: Color(0xFF312E81),
    shade950: Color(0xFF1E1A4D),
  );

  // ---------------------------------------------------------------------------
  // Purple/pink color families
  // ---------------------------------------------------------------------------

  /// Violet color family.
  static const violet = TwColorFamily(
    shade50: Color(0xFFF5F3FF),
    shade100: Color(0xFFEDE9FE),
    shade200: Color(0xFFDDD6FE),
    shade300: Color(0xFFC4B5FD),
    shade400: Color(0xFFA78BFA),
    shade500: Color(0xFF8E51FF),
    shade600: Color(0xFF7C3AED),
    shade700: Color(0xFF6D28D9),
    shade800: Color(0xFF5B21B6),
    shade900: Color(0xFF4C1D95),
    shade950: Color(0xFF2F0D68),
  );

  /// Purple color family.
  static const purple = TwColorFamily(
    shade50: Color(0xFFFAF5FF),
    shade100: Color(0xFFF3E8FF),
    shade200: Color(0xFFE9D5FF),
    shade300: Color(0xFFD8B4FE),
    shade400: Color(0xFFC084FC),
    shade500: Color(0xFFAD46FF),
    shade600: Color(0xFF9333EA),
    shade700: Color(0xFF7E22CE),
    shade800: Color(0xFF6B21A8),
    shade900: Color(0xFF581C87),
    shade950: Color(0xFF3C0366),
  );

  /// Fuchsia color family.
  static const fuchsia = TwColorFamily(
    shade50: Color(0xFFFDF4FF),
    shade100: Color(0xFFFAE8FF),
    shade200: Color(0xFFF5D0FE),
    shade300: Color(0xFFF0ABFC),
    shade400: Color(0xFFE879F9),
    shade500: Color(0xFFE12AFB),
    shade600: Color(0xFFC026D3),
    shade700: Color(0xFFA21CAF),
    shade800: Color(0xFF86198F),
    shade900: Color(0xFF701A75),
    shade950: Color(0xFF4B004F),
  );

  /// Pink color family.
  static const pink = TwColorFamily(
    shade50: Color(0xFFFDF2F8),
    shade100: Color(0xFFFCE7F3),
    shade200: Color(0xFFFBCFE8),
    shade300: Color(0xFFF9A8D4),
    shade400: Color(0xFFF472B6),
    shade500: Color(0xFFF6339A),
    shade600: Color(0xFFDB2777),
    shade700: Color(0xFFBE185D),
    shade800: Color(0xFF9D174D),
    shade900: Color(0xFF831843),
    shade950: Color(0xFF510424),
  );

  /// Rose color family.
  static const rose = TwColorFamily(
    shade50: Color(0xFFFFF1F2),
    shade100: Color(0xFFFFE4E6),
    shade200: Color(0xFFFECDD3),
    shade300: Color(0xFFFDA4AF),
    shade400: Color(0xFFFB7185),
    shade500: Color(0xFFFF2056),
    shade600: Color(0xFFE11D48),
    shade700: Color(0xFFBE123C),
    shade800: Color(0xFF9F1239),
    shade900: Color(0xFF881337),
    shade950: Color(0xFF4D0218),
  );
}
