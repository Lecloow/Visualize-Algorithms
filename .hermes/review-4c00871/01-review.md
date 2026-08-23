# Code Review — commit 4c00871 "feat: add benchmarkView"

**Verdict: ✅ Approve with comments** — build succeeds (iOS Simulator destination), the feature works, and the ID-stability fix to `BenchmarkResult` is a real improvement. A few should-fix items below.

## Scope

| File | Change |
|---|------|
| `Algorithms/BenchmarkView.swift` | Canvas bar-chart preview, ranked result cards, per-algorithm colors |
| `Algorithms/model.swift` | `Algorithm` gains a `color` property |
| `Algorithms/viewModel.swift` | Stable result IDs, preview regeneration, dead code |
| `Algorithms/SortAlgorithmsView.swift` | Preview updated for new initializer |

## Findings

### 🟡 Should-fix

1. **Stale results survive a slider change** (`BenchmarkView.swift:102`)
   Changing `length` regenerates the preview array but keeps `benchmarkResults`
   from the previous run's array size. The cards then show timings that don't
   correspond to the visible length. Fix: also call
   `sortState.benchmarkResults.removeAll()` inside
   `regenerateBenchmarkPreview()`, or clear results in the `onChange`.

2. **Slider drag regenerates a 10 000-element shuffled array per frame**
   (`viewModel.swift:65-76`) `Array(1...size).shuffled()` runs on *every* tick
   of the slider gesture. At length 10 000 that's an O(n) alloc + shuffle per
   frame on the main actor while dragging. Options: debounce the `onChange`,
   or only downsample lazily (e.g. `source.enumerated().filter { $0.offset % stride == 0 }`
   over a non-shuffled range, since the display only needs shape, not order).

3. **Commented-out dead code kept in the diff** (`viewModel.swift:78-100`)
   The old `startBenchmark()` copy is checked in. Delete it — git history
   preserves it. (Also the stray trailing-whitespace lines at
   `viewModel.swift:225-226`.)

4. **No tests** — the project has no test target at all. At minimum,
   `regenerateBenchmarkPreview`'s downsampling invariant (≤500 elements,
   correct count for various sizes) and the ranking order are pure logic that
   would be cheap to unit-test. Not blocking this commit, but worth adding.

### 💡 Suggestions

5. **`Dictionary(uniqueKeysWithValues:)` traps on duplicates** (`BenchmarkView.swift:43`)
   Safe today because IDs come from a static literal list, but
   `Dictionary(_:uniquingKeysWith: { a, _ in a })` costs nothing and can't
   crash if the model ever gains dynamic entries.

6. **Unused tuple field**: `engines` still carries `name` which nothing reads
   anymore (`viewModel.swift:109`). Drop it.

7. **Duplicated color mapping**: `BenchmarkResultCard.cardColor` hand-maps
   `CustomColor` → SwiftUI `Color`. If `Tag` does the same thing internally,
   hoist the switch into an extension `CustomColor.swiftUIColor` (or add a
   computed `Color` directly on `CustomColor`) so future colors are added once.

8. **Preview ≠ benchmarked data**: the canvas shows one random array, but
   `startBenchmark()` generates its own fresh array. That's fine if intended
   (decorative), but consider labeling it "sample input" so users don't assume
   the chart depicts what was actually sorted.

## What's good

- **Stable `BenchmarkResult.id`** — switching from `id = UUID()` (new identity
  every mutation) to carrying the algorithm's own UUID fixes animation identity
  and enables the `ForEach` ranking. Correct root-cause fix.
- Per-algorithm colors replacing the arbitrary rotating tag palette makes the
  tags, canvas intent, and cards coherent.
- Snapshotting everything before `Task.detached` keeps main-actor state out of
  the background closure; publishing results once avoids intermediate renders.
- Downsampled canvas drawing caps work regardless of slider max.
