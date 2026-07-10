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
            HStack {
                Button(action: { viewModel.startSorting(for: algorithm, speed: speed) }) {
                    Text("Start")
                        .padding()
                        .background(viewModel.sortState.isSorting ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.sortState.isSorting)
                Button(action: viewModel.sampleCase) {
                    Text("Reset")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
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
