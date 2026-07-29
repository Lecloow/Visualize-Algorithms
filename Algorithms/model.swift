//
//  model.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import Foundation

enum DifficultyType: String, CaseIterable, Identifiable {
    case bestCase = "best case"
    case worstCase = "worst case"
    case randomCase = "random case"
    case sampleCase = "sample case"

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

    var family: AlgorithmCategory {
        switch self {
        case .sorting:
            return .sorting
        case .searching:
            return .searching
        case .graph:
            return .graph
        }
    }
}

enum AlgorithmCategory: String, CaseIterable, Identifiable {
    case sorting = "Sorting"
    case searching = "Searching"
    case graph = "Graph"

    var id: Self { self }
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
            Algorithm(title: "Bubble Sort", description: "Efficient sorting algorithm...", type: .sorting(.bubble)),
            Algorithm(title: "Insertion Sort", description: "Efficient sorting algorithm...", type: .sorting(.insertion)),
            Algorithm(title: "Binary Search", description: "Divide and conquer...", type: .searching(.binarySearch),),
            Algorithm(title: "Dijkstra", description: "Shortest path algorithm...", type: .graph(.dijkstra))
        ]
    }
    
}

enum SortStep {
    case compare(Int, Int)
    case swap(Int, Int)
    case overwrite(Int, Int)
    case markSorted(Int)
}

protocol SortingAlgorithm {
    var name: String { get }
    
    // For vizualization
    func generateSteps(from array: [Int]) -> AsyncStream<SortStep>
    
    // For benchmarking
    func sort(_ array: [Int]) -> TimeInterval
}
