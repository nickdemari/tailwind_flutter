# Performance

## TL;DR

Chained extension methods (`.p().bg().rounded()`) produce the **exact same widget tree** as manually nesting `Padding`, `ColoredBox`, `ClipRRect`, etc. There is no hidden performance layer, no extra allocations, no additional elements. The extensions are syntactic sugar -- nothing more.

## Methodology

Benchmarks live in `benchmark/extension_benchmark_test.dart` and compare four approaches to styling a `Text` widget with padding, background color, border radius, box shadow, and margin:

| Approach | Description |
|----------|-------------|
| **Chained extensions** | `Text('Hello').p(s4).bg(blue100).rounded(lg).shadow(md).m(s3)` |
| **Manual nesting** | Hand-written `Padding(child: DecoratedBox(child: ClipRRect(child: ColoredBox(child: Padding(child: Text(...))))))` |
| **Single Container** | `Container(margin: ..., padding: ..., decoration: ...)` |
| **TwStyle.apply()** | Consolidates bg + borderRadius + shadows into one `DecoratedBox` |

Each approach is pumped 1000 times via `tester.pumpWidget()` inside a `Stopwatch` block. A separate test group verifies element tree depth and widget type sequence equality between chained extensions and manual nesting.

## Results

> Results will vary by machine, test ordering, and framework warm-up. These are representative values from a single run on macOS (Apple Silicon). The first test in a suite pays additional framework warm-up cost, so absolute times matter less than tree depth and widget type equality.

| Approach | 1000 pumps | Tree depth (from styled root) |
|----------|-----------|-------------------------------|
| Chained extensions | ~9000ms | 6 |
| Manual nesting | ~5200ms | 6 |
| Single Container | ~3000ms | 6 (Container decomposes internally) |
| TwStyle.apply() | ~2600ms | 5 (consolidates bg/radius/shadow into one DecoratedBox) |

The chained extensions and manual nesting columns produce **identical** tree depths and **identical** widget type sequences. This is verified by assertion, not just observation.

## Key Takeaway

Extension methods are compile-time syntactic sugar. Calling `.bg(color)` returns `ColoredBox(color: color, child: this)` -- the exact widget you would write by hand. The chained call site:

```dart
const Text('Hello')
    .p(TwSpacing.s4)
    .bg(TwColors.blue.shade100)
    .rounded(TwRadii.lg)
    .shadow(TwShadows.md)
    .m(TwSpacing.s3)
```

desugars to:

```dart
Padding(                                    // .m()
  padding: EdgeInsets.all(12),
  child: DecoratedBox(                      // .shadow()
    decoration: BoxDecoration(boxShadow: TwShadows.md),
    child: ClipRRect(                       // .rounded()
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(                    // .bg()
        color: TwColors.blue.shade100,
        child: Padding(                     // .p()
          padding: EdgeInsets.all(16),
          child: Text('Hello'),
        ),
      ),
    ),
  ),
)
```

No wrapper widgets. No intermediate builders. No performance layer. Same tree.

## Optimization: TwStyle.apply() for Hot Paths

When a widget is rebuilt frequently (e.g., inside an animation or a list item), you can consolidate `backgroundColor`, `borderRadius`, and `shadows` into a **single `DecoratedBox`** by using `TwStyle.apply()`:

```dart
final cardStyle = TwStyle(
  padding: TwSpacing.s4.all,
  margin: TwSpacing.s3.all,
  backgroundColor: TwColors.blue.shade100,
  borderRadius: TwRadii.lg.all,
  shadows: TwShadows.md,
);

// One DecoratedBox instead of separate ColoredBox + ClipRRect + DecoratedBox
cardStyle.apply(child: const Text('Hello'))
```

This reduces the element count by merging three visual properties into one `BoxDecoration`. For most UIs the difference is negligible, but in tight rebuild loops (long scrolling lists, animated transitions) fewer elements means fewer `Element.update()` calls per frame.

### When to use which

| Scenario | Recommendation |
|----------|---------------|
| One-off styling in `build()` | Chained extensions -- readable, zero cost |
| Reusable design tokens / theme styles | `TwStyle` + `.apply()` -- composable and slightly fewer elements |
| Performance-critical hot paths | `TwStyle` + `.apply()` -- consolidates decoration into one widget |
