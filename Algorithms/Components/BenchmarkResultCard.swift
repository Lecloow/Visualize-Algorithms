//
//  BenchmarkResultCard.swift
//  Algorithms
//
//  Created by Thomas Conchon on 8/26/26.
//
import SwiftUI

struct BenchmarkResultCard: View {
    let rank: Int
    let name: String
    let elapsedTime: TimeInterval
    let relativeTime: Double
    let cardColor: AppColor

    var body: some View {
        let color = cardColor.neutral
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
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
                        .glassEffect()
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
