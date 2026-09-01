//
//  ExplanationSortAlgorithmsView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/6/26.
//

import SwiftUI

struct ExplanationSortAlgorithmView: View {
    @Environment(SortViewModel.self) var viewModel: SortViewModel
    let algorithm: Algorithm
    
    var body: some View {
        VStack {
            SortCanvasView()
            HStack(spacing: 20) {
                Button(action: { viewModel.startSorting(for: algorithm) }) {
                    Text("Start")
                }
                .buttonStyle(.glassProminent)
                .tint(viewModel.sortState.isSorting ? Color.gray : Color.blue)
                .disabled(viewModel.sortState.isSorting)
                
                Button(action: viewModel.sampleCase) {
                    Text("Reset")
                    
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
            }
        }
        .onDisappear {
            viewModel.resetArray()
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
