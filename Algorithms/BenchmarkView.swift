//
//  BenchmarkView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/10/26.
//

import SwiftUI
import WrappingHStack

struct BenchView: View {
    @Environment(ViewModel.self) var viewModel
    @State private var showingSelection = false

    var body: some View {
        @Bindable var vm = viewModel

        VStack {
            if viewModel.selection.isEmpty {
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
    @Environment(ViewModel.self) var viewModel
    @State private var showingSelection = false

    var body: some View {
        @Bindable var vm = viewModel
        let algorithmMap = Dictionary(uniqueKeysWithValues: viewModel.algorithms.map { ($0.id, $0) })
        VStack {
            WrappingHStack(alignment: .leading) {
                ForEach(viewModel.selection.sorted(), id: \.self) { algorithmID in
                    if let algo = algorithmMap[algorithmID] {
                        Tag(algo.title, color: algo.color)
                    }
                }
                Button(action: { showingSelection = true }) {
                    Text("add more")
                }
            }
            
            SortCanvasView(isPreview: true)
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Result cards: one per benchmarked algorithm, laid out in a grid.
            let rankedResults = viewModel.sortState.benchmarkResults
                .sorted { $0.elapsedTime < $1.elapsedTime }
            if !rankedResults.isEmpty {
                let columns = rankedResults.count == 1
                    ? [GridItem(.flexible())]
                    : [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(rankedResults.enumerated()), id: \.element.id) { index, result in
                        if let algo = algorithmMap[result.id] {
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
            HStack {
                Slider(
                    value: $vm.sortState.length,
                    in: 100...10000,
                )
                Text("length: \(Int(viewModel.sortState.length))")
            }
            .onChange(of: viewModel.sortState.length) {
                viewModel.regenerateBenchmarkPreview()
            }
            if viewModel.sortState.isSorting {
                ProgressView("Benchmarking…")
                    .padding(4)
            }
            Button(action: { Task { await viewModel.startBenchmark() } }) {
                Text(viewModel.sortState.isSorting ? "Sorting ..." : "Start")
            }
            .buttonStyle(.glassProminent)
            .tint(viewModel.sortState.isSorting ? Color.gray : Color.blue)
            .disabled(viewModel.sortState.isSorting)
        }
        .padding()
        .sheet(isPresented: $showingSelection) {
            BenchmarkSelectionSheet()
        }
    }
}

struct BenchmarkResultCard: View {
    let rank: Int
    let name: String
    let elapsedTime: TimeInterval
    let relativeTime: Double
    let cardColor: AppColor

    var body: some View {
        let color = cardColor.background
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.title3)
                .fontWeight(.semibold)
            HStack {
                Text("#\(rank)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(color.opacity(0.2), in: Capsule())
                    .foregroundStyle(color)
                
                Text(String(format: "%.4f", elapsedTime) + "s")
                    .monospacedDigit()
            }
            // Bar length is proportional to the slowest algorithm in this run.
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.15))
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * relativeTime)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BenchmarkSelectionSheet: View {
    @Environment(ViewModel.self) var viewModel
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
        .environment(ViewModel())
}

#Preview {
    @Previewable @State var vm = ViewModel()
    
    BenchmarkView()
        .onAppear{
            vm.selection = Set([
                vm.algorithms[0].id,
                vm.algorithms[1].id
            ])
        }
        .environment(vm)
}

