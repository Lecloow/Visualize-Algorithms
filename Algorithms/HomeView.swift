//
//  HomeView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    @State private var selectedAlgo: Algorithm? = nil

    var body: some View {
//        List {
//            ForEach(AlgorithmType.allCases) { type in
//                Section(header: Text(type.rawValue)) {
//                    let filtered = viewModel.algorithms.filter { $0.type == type }
//                    if filtered.isEmpty {
//                        Text("No algorithms yet")
//                            .foregroundColor(.secondary)
//                    } else {
//                        ForEach(filtered.sorted { $0.title < $1.title }) { algo in
//                            Text(algo.title)
//                                .onTapGesture { selectedAlgo = algo }
//                        }
//                    }
//                }
//            }
        List {
            ForEach(viewModel.algorithms) { algo in
                Text(algo.title)
                   .onTapGesture { selectedAlgo = algo }
            }
        }
        .sheet(item: $selectedAlgo) { algo in
            AlgorithmView(algorithm: algo)
        }
    }
}

#Preview {
    HomeView()
        .environment(ViewModel())
}
