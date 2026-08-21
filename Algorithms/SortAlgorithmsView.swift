//
//  SortAlgorithmsView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/4/26.
//

import SwiftUI

struct sortCanvasView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let count = viewModel.sortState.array.count
            let barWidth = totalWidth / CGFloat(count)
            
            Canvas { context, size in
                for index in 0..<count {
                    let value = viewModel.sortState.array[index]
                    let xPos = floor(CGFloat(index) * barWidth)
                    let nextXPos = floor(CGFloat(index + 1) * barWidth)
                    let width = nextXPos - xPos // To avoid little space between bar (bc the pos is rounded so sometimes there is a 1 px gap)
                    let barHeight = (CGFloat(value) / CGFloat(viewModel.sortState.currentMaxValue)) * size.height
                    
                    let rect = CGRect(
                        x: xPos,
                        y: size.height - barHeight,
                        width: width,
                        height: barHeight
                    )
                    
                    let color: Color = viewModel.sortState.sortedIndices.contains(index) ? .green :
                    viewModel.sortState.highlightedIndices.contains(index) ? .blue : .primary
                    
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
    }
}

struct SortAlgorithmsView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    let algorithm: Algorithm
    @State var showLearnMoreSheet = false
    
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack(spacing: 20) {
            sortCanvasView()
            
            Spacer()
            
            Text(algorithm.title)
                .font(.largeTitle)
            Text(algorithm.description)
                .padding()
            
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
            
            Picker("Difficulty", selection: $vm.sortState.difficulty) {
                ForEach(DifficultyType.allCases) { difficulty in
                    Text(difficulty.rawValue)
                        .tag(difficulty)
                        .foregroundStyle(.primary)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.secondary.opacity(0.2)))
            .onChange(of: viewModel.sortState.difficulty) {
                viewModel.resetArray()
            }
            
            HStack {
                NonLinearSlider(value: $vm.sortState.speed)
                
                Text("Speed : \(viewModel.sortState.speed, specifier: "%.2f")")
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
            ExplanationAlgorithmView(algorithm: algorithm)
        }
        .onAppear {
            viewModel.resetArray()
        }
        .padding()
    }
}

#Preview {
    SortAlgorithmsView(algorithm: Algorithm(title: "Bubble Sort", description: "Efficient sorting algorithm...", type: .sorting(.bubble), color: .blue), showLearnMoreSheet: false)
        .environment(ViewModel())
}
