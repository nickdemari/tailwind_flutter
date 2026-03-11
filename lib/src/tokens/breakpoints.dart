/// Tailwind CSS v4 responsive breakpoints as `static const double` pixel
/// values.
///
/// Provides the 5 standard Tailwind breakpoints for responsive design:
/// `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), and
/// `xxl` (1536px).
///
/// These are plain doubles representing logical pixel thresholds, suitable for
/// use with `MediaQuery`, `LayoutBuilder`, or any custom responsive logic.
///
/// ```dart
/// if (MediaQuery.sizeOf(context).width >= TwBreakpoints.md) {
///   // tablet or larger layout
/// }
/// ```
abstract final class TwBreakpoints {
  /// Small breakpoint: 640px.
  static const double sm = 640;

  /// Medium breakpoint: 768px.
  static const double md = 768;

  /// Large breakpoint: 1024px.
  static const double lg = 1024;

  /// Extra-large breakpoint: 1280px.
  static const double xl = 1280;

  /// 2x extra-large breakpoint: 1536px.
  static const double xxl = 1536;
}
