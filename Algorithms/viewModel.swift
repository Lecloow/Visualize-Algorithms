//
//  viewModel.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import Foundation
import SwiftUI

@Observable class ViewModel {
    private var model = createModel()
    
    private static func createModel() -> Model {
        Model()
    }
    
    var algorithms: [Algorithm] {
        model.algorithms
    }
    
    func getSortArray(difficulty: DifficultyType, size: Int = 100) {
        sortState.sortedIndices.removeAll()
        sortState.highlightedIndices.removeAll()
        switch difficulty {
        case .bestCase:
            sortState.array = Array(1...size)
        case .worstCase:
            sortState.array = Array((1...size).reversed())
        case .randomCase:
            sortState.array = Array(1...size).shuffled()
        case .sampleCase:
            sortState.array = [5, 3, 8, 1, 9, 2, 7, 4, 6, 10]
        }
    }
    
    var sortState = SortVisualizerState()
    
    let sortAlgorithms: [SortAlgorithmType: any SortingAlgorithm] = [
        .bubble: BubbleSort(),
        .selection: BubbleSort(),
        .insertion: BubbleSort(),
        .merge: BubbleSort(),
        .quick: BubbleSort()
    ]
    
    func startSorting(for algorithm: Algorithm, speed: Double = 1) {
        guard case .sorting(let type) = algorithm.type else { return }
        guard !sortState.isSorting else { return }
        guard let engine = sortAlgorithms[type] else { return }
        
        prepareRun()
        
        sortState.steps = engine.generateSteps(from: sortState.array)

        runSteps(speed)
    }
    
    func resetArray() {
        getSortArray(difficulty: sortState.difficulty)
        sortState.currentMaxValue = sortState.array.max() ?? 1
        sortState.currentStep = 0
        sortState.isSorting = false
        sortState.highlightedIndices.removeAll()
        sortState.sortedIndices.removeAll()
        sortState.steps.removeAll()
    }
    
    func sampleCase() {
        getSortArray(difficulty: .sampleCase)
        sortState.currentMaxValue = sortState.array.max() ?? 1
        sortState.currentStep = 0
        sortState.isSorting = false
        sortState.highlightedIndices.removeAll()
        sortState.sortedIndices.removeAll()
        sortState.steps.removeAll()
    }
    
    private func prepareRun() {
        sortState.isSorting = true
        sortState.currentStep = 0
        sortState.highlightedIndices.removeAll()
        sortState.sortedIndices.removeAll()
    }
    
    private func runSteps(_ speed: Double) {

        Task { @MainActor in
            
            while sortState.isSorting && sortState.currentStep < sortState.steps.count {
                for _ in 0..<Int((25 * speed).rounded()) {
                    guard sortState.currentStep < sortState.steps.count else { break }
                    
                    let step = sortState.steps[sortState.currentStep]
                    switch step.action {
                    case let .compare(i, j):
                        sortState.highlightedIndices = [i, j]
                    case let .swap(i, j):
                        sortState.array.swapAt(i, j)
                    case let .overwrite(index, value):
                        sortState.array[index] = value
                    case let .markSorted(index):
                        sortState.sortedIndices.insert(index)
                    }
                    sortState.currentStep += 1
                
                }
                try? await Task.sleep(nanoseconds: UInt64(16000000*(1/speed)))

            }
            sortState.isSorting = false
            sortState.highlightedIndices.removeAll()
        }
    }
}

struct SortVisualizerState {

    var algorithmType: SortAlgorithmType = .bubble

    var difficulty: DifficultyType = .randomCase
    var array: [Int] = []

    var currentMaxValue: Int = 1
    var isSorting = false
    var currentStep = 0

    var steps: [SortStep] = []

    var highlightedIndices: Set<Int> = []
    var sortedIndices: Set<Int> = []
}
