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
    /// Custom color from a hex string like "#FF8800", "F80" or "80FF8800" (ARGB).
    case custom(hex: String)

    /// The hex value this token stands for.
    var hex: String {
        switch self {
        case .blue:   return "#0000FF"
        case .gray:   return "#808080"
        case .green:  return "#00FF00"
        case .orange: return "#FFA500"
        case .pink:   return "#FFC0CB"
        case .purple: return "#800080"
        case .red:    return "#FF0000"
        case .black:  return "#000000"
        case .custom(let hex): return hex
        }
    }

    /// Resolved SwiftUI colors for this token.
    var appColor: AppColor {
        let background = Color(hex: hex)
        // White text on dark backgrounds, black on light ones.
        let foreground: Color = Self.luminance(ofHex: hex) < 0.5 ? .white : .black
        return AppColor(background: background, foreground: foreground)
    }

    /// Perceptual luminance in [0, 1] (Rec. 709 weights) of a hex color string.
    /// Returns 0 for unparsable input so invalid hex gets light text.
    private static func luminance(ofHex hex: String) -> Double {
        guard let c = rgba(fromHex: hex) else { return 0 }
        let r = Double(c.r) / 255.0
        let g = Double(c.g) / 255.0
        let b = Double(c.b) / 255.0
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    /// Parses 3-digit RGB, 6-digit RGB and 8-digit ARGB hex strings.
    static func rgba(fromHex hex: String) -> (r: UInt64, g: UInt64, b: UInt64, a: UInt64)? {
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        switch hex.count {
        case 3:
            let r = (int >> 8 & 0xF) * 17
            let g = (int >> 4 & 0xF) * 17
            let b = (int & 0xF) * 17
            return (r: r, g: g, b: b, a: 255)
        case 6:
            let r = int >> 16 & 0xFF
            let g = int >> 8 & 0xFF
            let b = int & 0xFF
            return (r: r, g: g, b: b, a: 255)
        case 8:
            let r = int >> 16 & 0xFF
            let g = int >> 8 & 0xFF
            let b = int & 0xFF
            let a = int >> 24
            return (r: r, g: g, b: b, a: a)
        default:
            return nil
        }
    }
}

struct AppColor {
    let background: Color
    let foreground: Color
}

extension Color {
    /// Creates a color from a hex string like "#FF8800", "F80" or "80FF8800" (ARGB).
    /// Unparsable input falls back to fully transparent — check with
    /// `CustomColor.rgba(fromHex:)` if you need strict validation.
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if let c = CustomColor.rgba(fromHex: cleaned) {
            self.init(
                .sRGB,
                red: Double(c.r) / 255,
                green: Double(c.g) / 255,
                blue: Double(c.b) / 255,
                opacity: Double(c.a) / 255
            )
        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 0)
        }
    }
}
