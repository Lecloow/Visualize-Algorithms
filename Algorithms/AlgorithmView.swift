//
//  AlgorithmView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

struct AlgorithmView: View {
    let algorithm: Algorithm

    var body: some View {
        switch algorithm.type {
        case .sorting:
            SortAlgorithmsView(algorithm: algorithm)
        case .searching:
            Text("Algorithm unsupported for the moment")
        case .graph:
            Text("Algorithm unsupported for the moment")
        }
    }
}
