//
//  model.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import Foundation

enum AlgorithmType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case sorting = "Sorting"
    case searching = "Searching"
    case graph = "Graph"
}

struct Algorithm: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: AlgorithmType
}

struct Model {
    private(set) var algorithms: [Algorithm]
    
    init() {
        algorithms = [
            Algorithm(title: "Binary Search", description: "Divide and conquer...", type: .searching),
            Algorithm(title: "Quick Sort", description: "Efficient sorting algorithm...", type: .sorting),
            Algorithm(title: "Dijkstra", description: "Shortest path algorithm...", type: .graph)
        ]
    }
}
