//
//  Non-LinearSlider.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/29/26.
//

import SwiftUI

struct NonLinearSlider: View {
    @Binding var value: Double

    private func realValueToSliderValue(_ realValue: Double) -> Double {
        if realValue <= 1 {
            return realValue * 0.5  // 0-1 → 0-50%
        } else {
            return 0.5 + (realValue - 1) / 24 * 0.5  // 1-25 → 50-100%
        }
    }

    private func sliderValueToRealValue(_ sliderValue: Double) -> Double {
        if sliderValue <= 0.5 {
            return sliderValue / 0.5  // 0-50% → 0-1
        } else {
            return 1 + (sliderValue - 0.5) / 0.5 * 24  // 50-100% → 1-25
        }
    }

    var body: some View {
        Slider(
            value: Binding(
                get: { realValueToSliderValue(value) },
                set: { sliderValue in
                    var newValue = sliderValueToRealValue(sliderValue)
                    let step: Double = newValue < 1 ? 0.01 : 1
                    newValue = (newValue / step).rounded() * step
                    value = max(0.01, min(25, newValue))
                }
            ),
            in: 0...1
        )
    }
}
