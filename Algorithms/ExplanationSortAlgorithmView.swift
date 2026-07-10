//
//  ExplanationSortAlgorithmsView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/6/26.
//

import SwiftUI

struct ExplanationSortAlgorithmView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    let algorithm: Algorithm
    let speed: Double
    
    var body: some View {
        VStack {
            sortCanvasView()
            HStack(spacing: 20) {
                Button(action: { viewModel.startSorting(for: algorithm) }) {
                    Text("Start")
                }
                .buttonStyle(.glassProminent)
                .tint(viewModel.sortState.isSorting ? Color.gray : Color.blue)
                .disabled(viewModel.sortState.isSorting)
                
                Button(action: viewModel.resetArray) {
                    Text("Reset")
                    
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
            }
        }
        .onAppear {
            viewModel.sampleCase()
        }
        .padding()
    }
    
}
//
//#Preview {
//    ExplanationSortAlgorithmsView()
//}
