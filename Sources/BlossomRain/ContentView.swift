//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI
import UIKit

public struct ContentView: View {
    @EnvironmentObject var brState: BRState
    @AppStorage("defaultUnit") var defaultUnit: Units = .milliliter
    @AppStorage("disableIdleTimer") var disableIdleTimer: Bool = true
    @AppStorage("roundTippedDropperCalcium") var roundTippedDropperCalcium: Bool = true
    @AppStorage("roundTippedDropperMagnesium") var roundTippedDropperMagnesium: Bool = true
    @AppStorage("roundTippedDropperPotassium") var roundTippedDropperPotassium: Bool = true
    @AppStorage("roundTippedDropperSodium") var roundTippedDropperSodium: Bool = true
    
    public init() {
    }
    
    public var body: some View {
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
        .onAppear {
            brState.unit = defaultUnit
            updateScreenIdleTimer(disableIdleTimer: disableIdleTimer)
            updateUnits(selectedUnit: brState.unit)
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
    }
}

func updateScreenIdleTimer(disableIdleTimer: Bool) {
    if disableIdleTimer {
        UIApplication.shared.isIdleTimerDisabled = true
    } else {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(mainBRState)
//}
