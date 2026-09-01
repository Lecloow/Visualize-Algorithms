//
//  BenchmarkView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/10/26.
//

import SwiftUI
import WrappingHStack

struct BenchView: View {
    @Environment(AlgorithmsViewModel.self) var algorithmsViewModel
    @State private var showingSelection = false

    var body: some View {
        VStack {
            if algorithmsViewModel.selection.isEmpty {
                ContentUnavailableView {
                    Label("No algorithm selected", systemImage: "chart.bar")
                } description: {
                    Text("You need to choose at least one algorithm")
                    Button("Choose algorithms") { showingSelection = true }
                }
                
            } else {
                BenchmarkView()
            }
        }
        .sheet(isPresented: $showingSelection) {
            BenchmarkSelectionSheet()
        }
    }
}

struct BenchmarkView: View {
    @Environment(AlgorithmsViewModel.self) var viewModel
    @State private var showingSelection = false

    private var sortViewModel: SortViewModel {
        viewModel.sortViewModel
    }

    var body: some View {
        @Bindable var sortVM = sortViewModel
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    WrappingHStack(alignment: .leading) {
                        ForEach(viewModel.selection.sorted(), id: \.self) { algorithmID in
                            if let algo = viewModel.algorithmMap[algorithmID] {
                                Tag(algo.title, color: algo.color)
                            }
                        }
                        Button(action: { showingSelection = true }) {
                            Text("add more")
                        }
                    }
                    
                    SortCanvasView(isPreview: true)
                        .frame(height: 300)
                    
                    // Result cards: one per benchmarked algorithm, laid out in a grid.
                    resultCards
                    
                    HStack {
                        Slider(
                            value: $sortVM.sortState.length,
                            in: 100...10000,
                        )
                        Text("length: \(Int(sortViewModel.sortState.length))")
                    }
                    .onChange(of: sortViewModel.sortState.length) {
                        sortViewModel.regenerateBenchmarkPreview()
                    }
                    if sortViewModel.sortState.isSorting {
                        ProgressView("Benchmarking…")
                            .padding(4)
                    }
                    Button(action: { Task { await viewModel.startBenchmark() } }) {
                        Text(sortViewModel.sortState.isSorting ? "Sorting ..." : "Start")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(sortViewModel.sortState.isSorting ? Color.gray : Color.blue)
                    .disabled(sortViewModel.sortState.isSorting)
                }
                .padding()
                .padding(.top, geometry.safeAreaInsets.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .ignoresSafeArea(.all)
        }
        .sheet(isPresented: $showingSelection) {
            BenchmarkSelectionSheet()
        }
    }
    
    @ViewBuilder
    var resultCards: some View {
        let rankedResults = sortViewModel.sortState.benchmarkResults.sorted { $0.elapsedTime < $1.elapsedTime }
        if !rankedResults.isEmpty {
            let columns = rankedResults.count == 1
                ? [GridItem(.flexible())]
                : [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(Array(rankedResults.enumerated()), id: \.element.id) { index, result in
                    if let algo = viewModel.algorithmMap[result.id] {
                        BenchmarkResultCard(
                            rank: index + 1,
                            name: algo.title,
                            elapsedTime: result.elapsedTime,
                            relativeTime: result.elapsedTime / (rankedResults.map(\.elapsedTime).max() ?? 1),
                            cardColor: algo.color
                        )
                    }
                }
            }
        }
    }
}

struct BenchmarkSelectionSheet: View {
    @Environment(AlgorithmsViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss

    var lockedFamily: AlgorithmCategory? {
        guard let first = viewModel.selection.first else { return nil }
        return viewModel.algorithms.first { $0.id == first }?.type.family
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(AlgorithmCategory.allCases) { family in
                    let disabled = lockedFamily != nil && lockedFamily != family
                    Section(header: Text(family.rawValue)) {
                        ForEach(viewModel.algorithms.filter { $0.type.family == family }) { algo in
                            Button(action: {
                                if viewModel.selection.contains(algo.id) { viewModel.selection.remove(algo.id) }
                                else { viewModel.selection.insert(algo.id) }
                            }) {
                                HStack {
                                    ZStack {
                                        Image(systemName: viewModel.selection.contains(algo.id) ? "checkmark.circle.fill" : "circle")
                                            .symbolRenderingMode(.multicolor)
                                            .foregroundStyle(.secondary)
                                            .contentTransition(.symbolEffect(.replace))
                                    }
                                    Text(algo.title)
                                        .tint(.primary)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(disabled)
                        }
                    }
                }
            }
            .navigationTitle("Choose at least one algorithm")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("", systemImage: "checkmark") { dismiss() } }
                ToolbarItem(placement: .cancellationAction) { Button("", systemImage: "xmark") { dismiss() } }
            }
        }
    }
}

#Preview {
    BenchView()
        .environment(AlgorithmsViewModel())
}

#Preview {
    @Previewable @State var vm = AlgorithmsViewModel()
    
    BenchmarkView()
        .onAppear{
            vm.selection = Set([
                vm.algorithms[0].id,
                vm.algorithms[1].id
            ])
        }
        .environment(vm)
}
