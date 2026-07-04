//
//  ContentView.swift
//  Algorithms
//
//  Created by Thomas Conchon on 6/30/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") var isFirstTime: Bool = true

    var body: some View {
        if isFirstTime {
            IntroductionView()
        }
        else {
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeView()
                }
                
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
                
                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    SearchView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
