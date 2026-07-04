//
//  AlgorithmView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

struct AlgorithmView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    let algo: Algorithm

    var body: some View {
        VStack(spacing: 20) {
            Text(algo.title)
                .font(.largeTitle)

            Text(algo.description)
                .padding()
        }
    }
}

//#Preview {
//    AlgorithmView()
//}
