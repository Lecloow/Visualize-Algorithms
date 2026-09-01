//
//  HomeView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AlgorithmsViewModel.self) var viewModel: AlgorithmsViewModel

    var body: some View {
        List {
            ForEach(AlgorithmCategory.allCases) { family in
                Section(header: Text(family.rawValue)) {
                    let filtered = viewModel.algorithms.filter { $0.type.family == family }
                    if filtered.isEmpty {
                        Text("No algorithms yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(filtered.sorted { $0.title < $1.title }) { algo in
                            NavigationLink(algo.title) {
                                AlgorithmView(algorithm: algo)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AlgorithmsViewModel())
}
