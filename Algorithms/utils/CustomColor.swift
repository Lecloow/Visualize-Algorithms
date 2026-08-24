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

    /// The hex value this token stands for.
    var background: String {
        switch self {
        case .blue:   return "#c1def5"
        case .gray:   return "#808080"
        case .green:  return "#cfe1d6"
        case .orange: return "#f0d6c2"
        case .pink:   return "#f1d1df"
        case .purple: return "#e4d4ef"
        case .red:    return "#f5d1cd"
        case .black:  return "#000000"
        }
    }
    
    var foreground: String {
        switch self {
        case .blue:   return "#264a72"
        case .gray:   return "#808080"
        case .green:  return "#2a533c"
        case .orange: return "#6a4222"
        case .pink:   return "#68354e"
        case .purple: return "#553b69"
        case .red:    return "#6d3531"
        case .black:  return "#000000"
        }
    }
    
    var neutral: String {
        switch self {
        case .blue:   return "#2783de"
        case .gray:   return "#808080"
        case .green:  return "#46a171"
        case .orange: return "#d5803b"
        case .pink:   return "#db6999"
        case .purple: return "#b577d6"
        case .red:    return "#e56458"
        case .black:  return "#000000"
        }
    }

    var appColor: AppColor {
        if case .black = self {
            return AppColor(background: .white, foreground: .black, neutral: .black)
        }
        return AppColor(background: Color(hex: background), foreground: Color(hex: foreground), neutral: Color(hex: neutral))
    }
}

struct AppColor {
    let background: Color
    let foreground: Color
    let neutral: Color
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
