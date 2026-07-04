//
//  AlgorithmsApp.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

@main
struct AlgorithmsApp: App {
    @State var AlgorithmViewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AlgorithmViewModel)
        }
    }
}
