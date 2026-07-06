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
    @State var showLearnMoreSheet = false
    
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let spacing: CGFloat = 0//viewModel.sortState.array.count > 50 ? 0 : 2
                let totalWidth = geometry.size.width
                let count = viewModel.sortState.array.count
                let barWidth = (totalWidth - CGFloat(max(0, count - 1)) * spacing) / CGFloat(max(1, count))
                
                Canvas { context, size in
                    for index in 0..<count {
                        let value = viewModel.sortState.array[index]
                        let xPos = CGFloat(index) * (barWidth)
                        let barHeight = CGFloat(value) / CGFloat(viewModel.sortState.currentMaxValue) * size.height
                        
                        let rect = CGRect(x: xPos, y: size.height - barHeight, width: barWidth, height: barHeight)
                        
                        let color: Color = viewModel.sortState.sortedIndices.contains(index) ? .green :
                        viewModel.sortState.highlightedIndices.contains(index) ? .blue :
                            .black
                        
                        context.fill(Path(rect), with: .color(color))
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
            
            Picker("Difficulty", selection: $vm.sortState.difficulty) {
                ForEach(DifficultyType.allCases) { difficulty in
                    Text(difficulty.rawValue)
                        .tag(difficulty)
                }
            }
            .onChange(of: viewModel.sortState.difficulty) {
                viewModel.resetArray()
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Learn more", systemImage: "questionmark") {
                    showLearnMoreSheet = true
                }
            }
        }
        .sheet(isPresented: $showLearnMoreSheet) {
            Text(algorithm.description)
        }
        .onAppear {
            viewModel.resetArray()
        }
        .padding()
    }
}
