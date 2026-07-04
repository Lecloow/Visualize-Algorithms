//
//  model.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import Foundation

enum DifficultyType: CaseIterable, Identifiable {
    case bestCase
    case worstCase
    case randomCase
    case sampleCase

    var id: Self { self }
}

struct Algorithm: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: AlgorithmType
}

enum AlgorithmType {
    case sorting(SortAlgorithmType)
    case searching(SearchAlgorithmType)
    case graph(GraphAlgorithmType)
}

enum SortAlgorithmType: String, CaseIterable, Identifiable {
    case bubble
    case selection
    case insertion
    case merge
    case quick

    var id: Self { self }
}

enum SearchAlgorithmType: String, CaseIterable, Identifiable {
    case binarySearch

    var id: Self { self }
}

enum GraphAlgorithmType: String, CaseIterable, Identifiable {
    case dijkstra

    var id: Self { self }
}


struct Model {
    private(set) var algorithms: [Algorithm]
    
    init() {
        algorithms = [
            Algorithm(title: "Binary Search", description: "Divide and conquer...", type: .searching(.binarySearch),),
            Algorithm(title: "Quick Sort", description: "Efficient sorting algorithm...", type: .sorting(.bubble)),
            Algorithm(title: "Dijkstra", description: "Shortest path algorithm...", type: .graph(.dijkstra))
        ]
    }
    
}

enum SortAction {
    case compare(Int, Int)
    case swap(Int, Int)
    case overwrite(Int, Int)
    case markSorted(Int)
}

struct SortStep {
    let action: SortAction
}

protocol SortingAlgorithm {
    var name: String { get }

    func generateSteps(from array: [Int]) -> [SortStep]
}

struct BubbleSort: SortingAlgorithm {

    let name = "Bubble Sort"

    func generateSteps(from array: [Int]) -> [SortStep] {

        var tempArray = array
        var steps: [SortStep] = []

        for i in 0..<tempArray.count {

            for j in 0..<(tempArray.count - i - 1) {

                steps.append(
                    SortStep(action: .compare(j, j + 1))
                )

                if tempArray[j] > tempArray[j + 1] {

                    tempArray.swapAt(j, j + 1)

                    steps.append(
                        SortStep(action: .swap(j, j + 1))
                    )
                }
            }

            steps.append(
                SortStep(action: .markSorted(tempArray.count - i - 1))
            )
        }

        return steps
    }
}
