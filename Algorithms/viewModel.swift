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
}
