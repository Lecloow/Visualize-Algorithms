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

    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .frame(
                width: width,
                height: CGFloat(value) / CGFloat(maxValue) * maxHeight
            )
    }
}

struct SortAlgorithmsView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    let algorithm: Algorithm

    @State private var difficulty: DifficultyType = .sampleCase
    @State private var array: [Int] = []
    @State private var isSorting = false
    @State private var currentStep = 0
    @State private var steps: [[Int]] = []

    @State var currentMaxValue = 0
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let spacing: CGFloat = array.count > 50 ? 0 : 2
                let chartHeight = geometry.size.height

                let barWidth =
                    (geometry.size.width
                     - CGFloat(array.count - 1) * spacing)
                    / CGFloat(array.count)

                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(Array(array.enumerated()), id: \.offset) { _, value in
                        BarView(
                            value: value,
                            maxValue: currentMaxValue,
                            width: max(barWidth, 1),
                            maxHeight: chartHeight
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
                Button(action: startSorting) {
                    Text("Start")
                        .padding()
                        .background(isSorting ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isSorting)

                Button(action: resetArray) {
                    Text("Reset")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            Picker("Difficulty", selection: $difficulty) {
                Text("Best case").tag(DifficultyType.bestCase)
                Text("Worst case").tag(DifficultyType.worstCase)
                Text("Random case").tag(DifficultyType.randomCase)
                Text("Sample case").tag(DifficultyType.sampleCase)
            }
            .onChange(of: difficulty) { _, newValue in
                array = viewModel.getSortArray(difficulty: newValue)
                currentMaxValue = array.max() ?? 1
            }
        }
        .onAppear {
            array = viewModel.getSortArray(difficulty: .sampleCase)
            currentMaxValue = array.max() ?? 1
        }
        .padding()
    }

    private func generateBubbleSortSteps() {
        var tempArray = array

        steps = [tempArray]

        for i in 0..<tempArray.count {
            for j in 0..<(tempArray.count - i - 1) {
                if tempArray[j] > tempArray[j + 1] {
                    tempArray.swapAt(j, j + 1)
                    steps.append(tempArray)
                }
            }
        }
    }

    private func startSorting() {
        isSorting = true
        currentStep = 0
        steps = []
        generateBubbleSortSteps()

        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true) { [self] timer in
            guard currentStep < steps.count else {
                timer.invalidate()
                isSorting = false
                return
            }
            withAnimation(.easeInOut(duration: 0.1)) {
                array = steps[currentStep]
            }
            currentStep += 1
        }
    }

    private func resetArray() {
        array = viewModel.getSortArray(difficulty: difficulty)
        isSorting = false
        currentStep = 0
    }
}

struct SortStep {
    let array: [Int]
    let comparedIndices: (Int, Int)?
    let swapped: Bool
}
