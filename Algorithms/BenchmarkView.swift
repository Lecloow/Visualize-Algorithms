//
//  BenchmarkView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/10/26.
//

import SwiftUI

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
        VStack {
            LazyHStack {
                ForEach(viewModel.selection.sorted(), id: \.self) { id in
                    Text(viewModel.algorithms.first { $0.id == id }?.title ?? "Unknown")
                }
                Button(action: { showingSelection = true }) {
                    Text("add more")
                }
            }
            
        }
        .sheet(isPresented: $showingSelection) {
            BenchmarkSelectionSheet()
        }
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
                                }
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
