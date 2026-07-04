//
//  SortAlgorithmsView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/4/26.
//

import SwiftUI

struct BarView: View {
    let value: Int
    let maxValue: Int
    let width: CGFloat
    let maxHeight: CGFloat
    let color: Color

    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .frame(
                width: width,
                height: CGFloat(value) / CGFloat(maxValue) * maxHeight
            )
    }
}

struct SortAlgorithmsView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    let algorithm: Algorithm

    var currentMaxValue: Int {
        max(viewModel.sortState.array.max() ?? 1, 1)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let spacing: CGFloat = viewModel.sortState.array.count > 50 ? 0 : 2
                let chartHeight = geometry.size.height

                let barWidth =
                    (geometry.size.width
                     - CGFloat(viewModel.sortState.array.count - 1) * spacing)
                / CGFloat(viewModel.sortState.array.count)

                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(Array(viewModel.sortState.array.enumerated()), id: \.offset) { index, value in
                        BarView(
                            value: value,
                            maxValue: currentMaxValue,
                            width: max(barWidth, 1),
                            maxHeight: chartHeight,
                            color:
                                viewModel.sortState.sortedIndices.contains(index) ? .green :
                                viewModel.sortState.highlightedIndices.contains(index) ? .blue :
                                    .black
                        )
                    }
                }
            }

            Spacer()
            Text(algorithm.title)
                .font(.largeTitle)
            Text(algorithm.description)
                .padding()

            HStack(spacing: 20) {
                Button(action: { viewModel.startSorting(for: algorithm) }) {
                    Text("Start")
                        .padding()
                        .background(viewModel.sortState.isSorting ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.sortState.isSorting)

                Button(action: viewModel.resetArray) {
                    Text("Reset")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
//            Picker("Difficulty", selection: $viewModel.sortState.difficulty) {
//                Text("Best case").tag(DifficultyType.bestCase)
//                Text("Worst case").tag(DifficultyType.worstCase)
//                Text("Random case").tag(DifficultyType.randomCase)
//                Text("Sample case").tag(DifficultyType.sampleCase)
//            }
//            .onChange(of: viewModel.sortState.difficulty) { _, newValue in
//                viewModel.sortState.array =
//                    viewModel.getSortArray(difficulty: newValue)
//
//                viewModel.sortState.sortedIndices.removeAll()
//                viewModel.sortState.highlightedIndices.removeAll()
//            }
        }
        .onAppear {
            viewModel.sortState.array = viewModel.getSortArray(difficulty: .randomCase)
            viewModel.sortState.difficulty = .randomCase
        }
        .padding()
    }



}
