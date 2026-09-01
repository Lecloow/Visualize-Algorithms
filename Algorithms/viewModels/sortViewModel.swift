//
//  SortViewModel.swift
//  Algorithms
//
//  Created by Thomas Conchon on 9/1/26.
//

import Foundation
import Observation

@Observable
final class SortViewModel {
    private let model: Model

    var sortState = SortVisualizerState()

    init(model: Model = Model()) {
        self.model = model
        regenerateBenchmarkPreview()
    }

    private func getSortArray(difficulty: DifficultyType, size: Double = 100) -> [Int] {
        sortState.sortedIndices.removeAll()
        sortState.highlightedIndices.removeAll()
        let count = max(Int(size), 1)

        switch difficulty {
        case .bestCase:
            return Array(1...count)
        case .worstCase:
            return Array((1...count).reversed())
        case .randomCase:
            return Array(1...count).shuffled()
        case .sampleCase:
            return [5, 3, 8, 1, 9, 2, 7, 4, 6, 10]
        }
    }

    func startSorting(for algorithm: Algorithm) {
        guard case .sorting(let type) = algorithm.type else { return }
        guard !sortState.isSorting, let engine = model.sortAlgorithms[type] else { return }

        prepareRun()
        runSteps(with: engine.generateSteps(from: sortState.array))
    }

    /// Regenerates the small array shown in the benchmark preview canvas.
    /// Downsamples to at most 500 bars so drawing stays cheap even at length 10 000.
    func regenerateBenchmarkPreview() {
        let size = Int(sortState.length)
        let source = Array(1...max(size, 1)).shuffled()

        if size <= 500 {
            sortState.benchmarkPreview = source
        } else {
            let stride = size / 500
            sortState.benchmarkPreview = source.enumerated()
                .filter { $0.offset % stride == 0 }
                .map { $0.element }
        }
    }

    func startBenchmark(
        selection: Set<Algorithm.ID>
    ) async {
        guard !sortState.isSorting else { return }
        sortState.isSorting = true
        sortState.benchmarkResults.removeAll()

        let array = getSortArray(difficulty: .randomCase, size: sortState.length)
        let algorithmsByID = Dictionary(uniqueKeysWithValues: model.algorithms.map { ($0.id, $0) })
        let engines: [(id: UUID, engine: any SortingAlgorithm)] = selection.compactMap { id in
            guard let algorithm = algorithmsByID[id],
                  case .sorting(let type) = algorithm.type,
                  let engine = model.sortAlgorithms[type] else { return nil }
            return (algorithm.id, engine)
        }

        // Keep the measurements serial: the selected sorts are CPU-bound and several
        // are quadratic, so concurrent runs contend for the same cores and make both
        // the total benchmark and the individual timings worse on device/simulator.
        let results = await Task.detached(priority: .userInitiated) {
            engines.map { BenchmarkResult(id: $0.id, elapsedTime: $0.engine.sort(array)) }
        }.value

        sortState.benchmarkResults = results
        sortState.isSorting = false
    }

    func resetArray() {
        sortState.array = getSortArray(difficulty: sortState.difficulty)
        sortState.sample = false
        sortState.currentMaxValue = sortState.array.max() ?? 1
        sortState.currentStep = 0
        sortState.isSorting = false
        sortState.highlightedIndices.removeAll()
        sortState.sortedIndices.removeAll()
        sortState.steps.removeAll()
        sortState.benchmarkResults.removeAll()
    }

    func sampleCase() {
        sortState.isSorting = false
        sortState.sample = true
        sortState.array = getSortArray(difficulty: .sampleCase, size: 10)
        sortState.currentMaxValue = sortState.array.max() ?? 1
        sortState.currentStep = 0
        sortState.highlightedIndices.removeAll()
        sortState.sortedIndices.removeAll()
        sortState.steps.removeAll()
        sortState.benchmarkResults.removeAll()
    }

    private func prepareRun() {
        sortState.isSorting = true
        sortState.currentStep = 0
        sortState.highlightedIndices.removeAll()
        sortState.sortedIndices.removeAll()
    }

    private func runSteps(with stream: AsyncStream<SortStep>) {
        Task { @MainActor in
            var stepsProcessedInFrame = 0
            let sample = sortState.sample
            var speed = sample ? sortState.sampleSpeed : sortState.speed
            var batchSize = max(1, Int((5.0 * speed).rounded()))

            for await step in stream {
                if speed != (sample ? sortState.sampleSpeed : sortState.speed) {
                    speed = sample ? sortState.sampleSpeed : sortState.speed
                    batchSize = max(1, Int((5.0 * speed).rounded()))
                }

                if !sortState.isSorting { break }

                switch step {
                case let .compare(i, j):
                    sortState.highlightedIndices = [i, j]
                case let .swap(i, j):
                    sortState.array.swapAt(i, j)
                case let .overwrite(index, value):
                    sortState.array[index] = value
                case let .markSorted(index):
                    sortState.sortedIndices.insert(index)
                }

                stepsProcessedInFrame += 1
                if stepsProcessedInFrame >= batchSize {
                    stepsProcessedInFrame = 0
                    let sleepTime = UInt64(16_000_000 / speed)
                    try? await Task.sleep(nanoseconds: sleepTime)
                }
            }

            sortState.isSorting = false
            sortState.highlightedIndices.removeAll()
        }
    }
}

struct BenchmarkResult: Identifiable, Equatable {
    let id: UUID
    let elapsedTime: TimeInterval
}

struct SortVisualizerState {
    var algorithmType: SortAlgorithmType = .bubble
    var speed = 1.0
    var length = 100.0
    var sampleSpeed = 0.1
    var sample = false

    var difficulty: DifficultyType = .randomCase
    var array: [Int] = []

    var currentMaxValue: Int = 1
    var isSorting = false
    var currentStep = 0

    var steps: [SortStep] = []
    var elapsedTime: [TimeInterval] = []
    var benchmarkResults: [BenchmarkResult] = []
    var benchmarkPreview: [Int] = []

    var highlightedIndices: Set<Int> = []
    var sortedIndices: Set<Int> = []
}
