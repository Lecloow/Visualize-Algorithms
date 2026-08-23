//
//  SortCanvasView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 8/23/26.
//

import SwiftUI

struct SortCanvasView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel
    let isPreview: Bool

    var array: [Int] {
        isPreview ? viewModel.sortState.benchmarkPreview : viewModel.sortState.array
    }

    var maxValue: Int {
        isPreview ? (array.max() ?? 1) : viewModel.sortState.currentMaxValue
    }

    init(isPreview: Bool? = false) {
        self.isPreview = isPreview ?? false
    }
    
    var body: some View {
        GeometryReader { geometry in
            let count = array.count
            if count == 0 {
                Color.clear
            } else {
                let barWidth = geometry.size.width / CGFloat(count)

                Canvas { context, size in
                    for index in 0..<count {
                        let value = array[index]
                        let xPos = floor(CGFloat(index) * barWidth)
                        let nextXPos = floor(CGFloat(index + 1) * barWidth)
                        let width = nextXPos - xPos
                        let barHeight = (CGFloat(value) / CGFloat(max(maxValue, 1))) * size.height

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
}
