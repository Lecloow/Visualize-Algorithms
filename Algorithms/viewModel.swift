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
    
    var algorithms: [Algorithm]{
        model.algorithms
    }
    
    func getSortArray(difficulty: DifficultyType, size: Int = 100) -> [Int] {
        switch difficulty {
        case .bestCase:
            return Array(1...size)
        case .worstCase:
            return Array((1...size).reversed())
        case .randomCase:
            return Array(1...size).shuffled()
        case .sampleCase:
            return [5, 3, 8, 1, 9, 2, 7, 4, 6, 10]
        }
    }
}
