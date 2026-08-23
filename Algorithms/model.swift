//
//  model.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import Foundation
import SwiftUI

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
    let customColor: CustomColor
    var color: AppColor { customColor.appColor }
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
    case insertionImproved
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
            Algorithm(title: "Bubble Sort", description: "Efficient sorting algorithm...", type: .sorting(.bubble), customColor: .blue),
            Algorithm(title: "Insertion Sort", description: "Efficient sorting algorithm...", type: .sorting(.insertion), customColor: .orange),
            Algorithm(title: "Improved Insertion Sort", description: "Efficient sorting algorithm...", type: .sorting(.insertionImproved), customColor: .pink),
            Algorithm(title: "Binary Search", description: "Divide and conquer...", type: .searching(.binarySearch), customColor: .green),
            Algorithm(title: "Dijkstra", description: "Shortest path algorithm...", type: .graph(.dijkstra), customColor: .pink)
        ]
    }
    
    let sortAlgorithms: [SortAlgorithmType: any SortingAlgorithm] = [
        .bubble: BubbleSort(),
        .selection: BubbleSort(),
        .insertion: InsertionSort(),
        .insertionImproved: ImprovedInsertionSort(),
        .merge: BubbleSort(),
        .quick: BubbleSort()
    ]
    
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
    nonisolated func sort(_ array: [Int]) -> TimeInterval
}

