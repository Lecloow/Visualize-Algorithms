//
//  Introductions.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

struct IntroductionView: View {
    @AppStorage("isFirstTime") var isFirstTime: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to the world of Algorithms").font(.title)
            Spacer()
            Text("This is a demo of the SwiftUI framework for Algorithms")
            Spacer()
            Button("Finish"){ isFirstTime = false }.buttonStyle(.glassProminent)
        }.padding()
    }
}

#Preview {
    IntroductionView()
}
