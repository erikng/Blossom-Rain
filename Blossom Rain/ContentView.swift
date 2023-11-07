//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            RecipesTab()
            SettingsTab()
        }
        .onAppear {
            if 0.0 >= appState.volumeInputStepper {
                appState.volumeInputStepper = 5.0
            }
            calculateMultipliers()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(primaryState)
}
