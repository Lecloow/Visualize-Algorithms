//
//  SortAlgorithmsView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/4/26.
//

import SwiftUI


struct SortAlgorithmsView: View {
    @Environment(SortViewModel.self) var viewModel: SortViewModel
    let algorithm: Algorithm
    @State var showLearnMoreSheet = false
    
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack(spacing: 20) {
            SortCanvasView()
            
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
                
                Picker("Difficulty", selection: $vm.sortState.difficulty) {
                    ForEach(DifficultyType.allCases) { difficulty in
                        Text(difficulty.rawValue)
                            .tag(difficulty)
                            .foregroundStyle(.primary)
                    }
                }
                .lineLimit(1)
                .fixedSize()
                .pickerStyle(.menu)
                .tint(.primary)
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.secondary.opacity(0.2)))
                .onChange(of: viewModel.sortState.difficulty) {
                    viewModel.resetArray()
                }
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
    SortAlgorithmsView(algorithm: Algorithm(title: "Bubble Sort", description: "Efficient sorting algorithm...", type: .sorting(.bubble), customColor: .blue), showLearnMoreSheet: false)
        .environment(SortViewModel())
}
