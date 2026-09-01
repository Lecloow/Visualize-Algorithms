//
//  AlgorithmsApp.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

@main
struct AlgorithmsApp: App {
    @State private var algorithmsViewModel = AlgorithmsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(algorithmsViewModel)
                .environment(algorithmsViewModel.sortViewModel)
        }
    }
}
