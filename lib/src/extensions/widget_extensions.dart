/// Tailwind-style widget extension methods for Flutter.
///
/// Provides chaining methods on any [Widget] to apply styling without manual
/// nesting of Padding, ColoredBox, ClipRRect, and other wrapper widgets.
///
/// **Recommended chaining order** (inner to outer):
/// ```dart
/// widget
///   .p(TwSpacing.s4)          // inner padding
///   .bg(TwColors.blue.shade500) // background color
///   .rounded(TwRadii.lg)       // clip with rounded corners
///   .shadow(TwShadows.md)      // box shadow
///   .opacity(TwOpacity.o75)    // opacity layer
///   .m(TwSpacing.s2);          // outer margin
/// ```
///
/// Each method wraps `this` in a single Flutter widget, so the **last call
/// becomes the outermost widget** in the tree. Order matters:
///
/// - `.bg(color).rounded(8)` -- rounds the background (correct)
/// - `.rounded(8).bg(color)` -- background paints outside the clip (wrong)
///
/// Similarly, `.shadow().rounded()` clips the shadow because ClipRRect is
/// the parent. Use `.rounded().shadow()` to paint the shadow outside.
library;

import 'package:flutter/widgets.dart';

/// Tailwind-style chaining extensions on [Widget].
///
/// Every method wraps `this` in exactly one Flutter widget and returns
/// [Widget], enabling fluent chaining.
extension TwWidgetExtensions on Widget {
  // ---------------------------------------------------------------------------
  // Padding (EXT-01)
  // ---------------------------------------------------------------------------

  /// Adds padding on all sides.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.all].
  ///
  /// ```dart
  /// Text('Hello').p(TwSpacing.s4)
  /// ```
  Widget p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Adds horizontal padding (left and right).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.symmetric].
  ///
  /// ```dart
  /// Text('Hello').px(TwSpacing.s4)
  /// ```
  Widget px(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  /// Adds vertical padding (top and bottom).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.symmetric].
  ///
  /// ```dart
  /// Text('Hello').py(TwSpacing.s4)
  /// ```
  Widget py(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  /// Adds padding on the top only.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// ```dart
  /// Text('Hello').pt(TwSpacing.s4)
  /// ```
  Widget pt(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  /// Adds padding on the bottom only.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// ```dart
  /// Text('Hello').pb(TwSpacing.s4)
  /// ```
  Widget pb(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);

  /// Adds padding on the left only.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// ```dart
  /// Text('Hello').pl(TwSpacing.s4)
  /// ```
  Widget pl(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  /// Adds padding on the right only.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// ```dart
  /// Text('Hello').pr(TwSpacing.s4)
  /// ```
  Widget pr(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);

  // ---------------------------------------------------------------------------
  // Margin (EXT-02)
  // ---------------------------------------------------------------------------

  /// Adds outer spacing (margin) on all sides.
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.all].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  /// Call `.m()` after visual extensions (`.bg()`, `.rounded()`) to ensure
  /// spacing is applied outside the visual boundary.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).m(TwSpacing.s4)
  /// ```
  Widget m(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Adds horizontal outer spacing (margin).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.symmetric].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).mx(TwSpacing.s4)
  /// ```
  Widget mx(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  /// Adds vertical outer spacing (margin).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.symmetric].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).my(TwSpacing.s4)
  /// ```
  Widget my(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  /// Adds top outer spacing (margin).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).mt(TwSpacing.s4)
  /// ```
  Widget mt(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  /// Adds bottom outer spacing (margin).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).mb(TwSpacing.s4)
  /// ```
  Widget mb(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);

  /// Adds left outer spacing (margin).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).ml(TwSpacing.s4)
  /// ```
  Widget ml(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  /// Adds right outer spacing (margin).
  ///
  /// Wraps this widget in a [Padding] with [EdgeInsets.only].
  ///
  /// **Note:** Flutter has no margin widget; margin is outer padding.
  ///
  /// ```dart
  /// Text('Hello').bg(Colors.blue).mr(TwSpacing.s4)
  /// ```
  Widget mr(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);

  // ---------------------------------------------------------------------------
  // Background (EXT-03)
  // ---------------------------------------------------------------------------

  /// Applies a solid background color.
  ///
  /// Wraps this widget in a [ColoredBox].
  ///
  /// **Ordering tip:** Call `.bg()` before `.rounded()` to ensure the
  /// background is clipped by the rounded corners:
  /// ```dart
  /// widget.bg(TwColors.blue.shade500).rounded(TwRadii.lg) // correct
  /// widget.rounded(TwRadii.lg).bg(TwColors.blue.shade500) // wrong: bg outside clip
  /// ```
  Widget bg(Color color) => ColoredBox(color: color, child: this);

  // ---------------------------------------------------------------------------
  // Border Radius (EXT-04)
  // ---------------------------------------------------------------------------

  /// Clips child content with rounded corners.
  ///
  /// Wraps this widget in a [ClipRRect] with [BorderRadius.circular].
  ///
  /// ```dart
  /// widget.bg(Colors.blue).rounded(TwRadii.lg)
  /// ```
  Widget rounded(double radius) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);

  /// Clips child content into a pill or circle shape.
  ///
  /// Wraps this widget in a [ClipRRect] with `BorderRadius.circular(9999)`.
  ///
  /// ```dart
  /// Image.network(url).roundedFull()
  /// ```
  Widget roundedFull() =>
      ClipRRect(borderRadius: BorderRadius.circular(9999), child: this);

  // ---------------------------------------------------------------------------
  // Opacity (EXT-05)
  // ---------------------------------------------------------------------------

  /// Applies an opacity layer.
  ///
  /// Wraps this widget in an [Opacity] widget with the specified [value].
  ///
  /// For fully invisible widgets, consider using [Visibility] instead to
  /// avoid unnecessary compositing.
  ///
  /// ```dart
  /// widget.opacity(TwOpacity.o50)
  /// ```
  Widget opacity(double value) => Opacity(opacity: value, child: this);

  // ---------------------------------------------------------------------------
  // Shadow (EXT-06)
  // ---------------------------------------------------------------------------

  /// Applies box shadows.
  ///
  /// Wraps this widget in a [DecoratedBox] with a [BoxDecoration] containing
  /// the provided [shadows].
  ///
  /// **Ordering tip:** Call `.shadow()` after `.rounded()` so the shadow
  /// is painted outside the clipped area:
  /// ```dart
  /// widget.rounded(TwRadii.lg).shadow(TwShadows.md) // correct
  /// widget.shadow(TwShadows.md).rounded(TwRadii.lg) // wrong: shadow clipped
  /// ```
  Widget shadow(List<BoxShadow> shadows) => DecoratedBox(
        decoration: BoxDecoration(boxShadow: shadows),
        child: this,
      );

  // ---------------------------------------------------------------------------
  // Sizing (EXT-07)
  // ---------------------------------------------------------------------------

  /// Constrains this widget to a specific width.
  ///
  /// Wraps this widget in a [SizedBox] with the specified [value] as width.
  ///
  /// ```dart
  /// widget.width(200)
  /// ```
  Widget width(double value) => SizedBox(width: value, child: this);

  /// Constrains this widget to a specific height.
  ///
  /// Wraps this widget in a [SizedBox] with the specified [value] as height.
  ///
  /// ```dart
  /// widget.height(48)
  /// ```
  Widget height(double value) => SizedBox(height: value, child: this);

  /// Constrains this widget to specific dimensions.
  ///
  /// Wraps this widget in a [SizedBox] with the specified [width] and
  /// [height].
  ///
  /// ```dart
  /// widget.size(100, 200)
  /// ```
  Widget size(double width, double height) =>
      SizedBox(width: width, height: height, child: this);

  // ---------------------------------------------------------------------------
  // Alignment (EXT-08)
  // ---------------------------------------------------------------------------

  /// Centers this widget within its parent.
  ///
  /// Wraps this widget in a [Center].
  ///
  /// ```dart
  /// widget.center()
  /// ```
  Widget center() => Center(child: this);

  /// Aligns this widget within its parent.
  ///
  /// Wraps this widget in an [Align] with the specified [alignment].
  ///
  /// ```dart
  /// widget.align(Alignment.topLeft)
  /// ```
  Widget align(Alignment alignment) =>
      Align(alignment: alignment, child: this);

  // ---------------------------------------------------------------------------
  // Clip (EXT-09)
  // ---------------------------------------------------------------------------

  /// Clips this widget to a rectangle.
  ///
  /// Wraps this widget in a [ClipRect].
  ///
  /// ```dart
  /// widget.clipRect()
  /// ```
  Widget clipRect() => ClipRect(child: this);

  /// Clips this widget to an oval/circle.
  ///
  /// Wraps this widget in a [ClipOval].
  ///
  /// ```dart
  /// Image.network(url).clipOval()
  /// ```
  Widget clipOval() => ClipOval(child: this);
}
