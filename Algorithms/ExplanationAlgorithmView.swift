//
//  ExplanationAlgorithmView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/6/26.
//

import SwiftUI

struct ExplanationAlgorithmView: View {
    let algorithm: Algorithm
    let speed = 0.05
    
    var body: some View {
        switch algorithm.type {
        case .sorting:
            ExplanationSortAlgorithmView(algorithm: algorithm, speed: speed)
        case .searching:
            Text("Algorithm unsupported for the moment")
        case .graph:
            Text("Algorithm unsupported for the moment")
        }
    }
}
