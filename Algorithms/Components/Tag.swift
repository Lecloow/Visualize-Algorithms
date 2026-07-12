//
//  Tag.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/12/26.
//

import SwiftUI

struct Tag: View {
    let content: String
    let color: CustomColor
    
    init(_ content: String, color: CustomColor) {
        self.content = content
        self.color = color
    }
    
    private var backgroundColor: Color {
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


    private var foregroundColor: Color {
       switch color {
       case .blue, .gray, .green, .orange, .pink, .purple, .red:
           return .white
       case .black:
           return .black
       }
   }

    
    var body: some View {
        Text(content)
            .foregroundStyle(foregroundColor)
            .padding(10)
            .background(backgroundColor)
            .cornerRadius(100)
    }
}

#Preview {
    Tag("Bubble sort", color: .green)
}
