import 'package:flutter/widgets.dart';

/// Tailwind CSS box shadow presets.
///
/// Each shadow preset is a `const List<BoxShadow>` matching Tailwind v4's
/// shadow utilities. Multi-shadow CSS values are expressed as multi-element
/// lists.
///
/// Usage with Flutter's [BoxDecoration]:
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: TwShadows.md,
///   ),
/// )
/// ```
///
/// **Note:** Flutter's [BoxShadow] does not support CSS `inset` shadows.
/// The [inner] preset is an approximation; see its documentation for details.
abstract final class TwShadows {
  /// Extra-extra-small shadow.
  ///
  /// CSS: `0 1px rgba(0,0,0,0.05)`
  static const xxs = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 1),
      color: Color.fromRGBO(0, 0, 0, 0.05),
    ),
  ];

  /// Extra-small shadow.
  ///
  /// CSS: `0 1px 2px 0 rgba(0,0,0,0.05)`
  static const xs = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(0, 0, 0, 0.05),
    ),
  ];

  /// Small shadow.
  ///
  /// CSS: `0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px -1px rgba(0,0,0,0.1)`
  static const sm = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
  ];

  /// Medium shadow.
  ///
  /// CSS: `0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1)`
  static const md = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
  ];

  /// Large shadow.
  ///
  /// CSS: `0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1)`
  static const lg = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
  ];

  /// Extra-large shadow.
  ///
  /// CSS: `0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1)`
  static const xl = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
      color: Color.fromRGBO(0, 0, 0, 0.1),
    ),
  ];

  /// Extra-extra-large shadow.
  ///
  /// CSS: `0 25px 50px -12px rgba(0,0,0,0.25)`
  static const xxl = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
      color: Color.fromRGBO(0, 0, 0, 0.25),
    ),
  ];

  /// Inner shadow approximation.
  ///
  /// CSS: `inset 0 2px 4px 0 rgba(0,0,0,0.05)`
  ///
  /// **Limitation:** Flutter's [BoxShadow] does not support the CSS `inset`
  /// property. This preset provides an outer shadow approximation with the
  /// same offset, blur, and color values. For true inner shadows, consider
  /// using a [ShaderMask] or custom painter.
  static const inner = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      color: Color.fromRGBO(0, 0, 0, 0.05),
    ),
  ];

  /// No shadow.
  static const none = <BoxShadow>[];
}
