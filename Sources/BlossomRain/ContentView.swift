//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Group {
            #if os(macOS)
            RecipesTab()
            #else
            TabView {
                RecipesTab()
                    .tabItem {
                        Label("Recipes", systemImage: "waterbottle")
                    }
                SettingsTab()
                    .tabItem {
                        Label("Settings", systemImage: "slider.horizontal.3")
                    }
            }
            #endif
        }
    }
}
