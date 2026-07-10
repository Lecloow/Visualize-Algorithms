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
                    NavigationStack {
                        HomeView()
                    }
                }
                
                Tab("Bench", systemImage: "dumbbell.fill") {
                    NavigationStack {
                        BenchView()
                    }
                }
                
                Tab("Settings", systemImage: "gear") {
                    NavigationStack {
                        SettingsView()
                    }
                }
                
                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    NavigationStack {
                        SearchView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
