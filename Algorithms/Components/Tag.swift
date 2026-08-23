//
//  Tag.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/12/26.
//

import SwiftUI

struct Tag: View {
    let content: String
    let color: AppColor
    
    init(_ content: String, color: AppColor) {
        self.content = content
        self.color = color
    }
    
    var body: some View {
        Text(content)
            .foregroundStyle(color.foreground)
            .padding(10)
            .background(color.background)
            .cornerRadius(100)
    }
}

#Preview {
    Tag("Bubble sort", color: AppColor(.green))
}
