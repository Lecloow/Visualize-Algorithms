//
//  AlgorithmsViewModel.swift
//  Algorithms
//
//  Created by Thomas Conchon on 9/1/26.
//

import Observation

@Observable
final class AlgorithmsViewModel {
    private let model: Model

    let algorithmMap: [Algorithm.ID: Algorithm]
    let sortViewModel: SortViewModel
    var selection: Set<Algorithm.ID> = []

    init(model: Model = Model()) {
        self.model = model
        self.algorithmMap = Dictionary(
            uniqueKeysWithValues: model.algorithms.map { ($0.id, $0) }
        )
        self.sortViewModel = SortViewModel(model: model)
    }

    var algorithms: [Algorithm] {
        model.algorithms
    }

    func startBenchmark() async {
        guard let firstID = selection.first, let algorithm = algorithmMap[firstID] else { return }
        switch algorithm.type {
        case .sorting:
            await sortViewModel.startBenchmark(
                algorithms: algorithms,
                selection: selection
            )
        case .graph:
            break
        case .searching:
            break
        }
    }
}

