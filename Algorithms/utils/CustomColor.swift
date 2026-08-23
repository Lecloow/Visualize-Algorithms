//
//  CustomColor.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/12/26.
//

import Foundation
import SwiftUI

enum CustomColor {
    case blue, gray, green, orange, pink, purple, red, black
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

func getForegroundColor(_ color: CustomColor) -> Color {
   switch color {
   case .blue, .gray, .green, .orange, .pink, .purple, .red:
       return .white
   case .black:
       return .black
   }
}

func getBackgroundColor(_ color: CustomColor) -> Color {
    switch color {
    case .blue: return .blue
    case .gray: return .gray
    case .green: return .green
    case .orange: return .orange
    case .pink: return .pink
    case .purple: return .purple
    case .red: return .red
    case .black: return .white
    }
}

struct AppColor {
    let background: Color
    let foreground: Color

    init(_ customColor: CustomColor) {
        self.background = getBackgroundColor(customColor)
        self.foreground = getForegroundColor(customColor)
    }
}
