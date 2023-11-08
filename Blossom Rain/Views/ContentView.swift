//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var brState: BRState

    var body: some View {
        TabView {
            RecipesTab()
            SettingsTab()
        }
        .onAppear {
            updatePartsPerMillionValues()
            updateScreenIdleTimer()
            updateUnits()
            calculateMultipliers()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(mainBRState)
}

func updateScreenIdleTimer() {
    if mainBRState.disableIdleTimer {
        UIApplication.shared.isIdleTimerDisabled = true
    } else {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
