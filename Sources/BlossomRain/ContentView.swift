//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var brState: BRState
    @AppStorage("disableIdleTimer") var disableIdleTimer: Bool = false
    @AppStorage("roundTippedDropperCalcium") var roundTippedDropperCalcium: Bool = false
    @AppStorage("roundTippedDropperMagnesium") var roundTippedDropperMagnesium: Bool = false
    @AppStorage("roundTippedDropperPotassium") var roundTippedDropperPotassium: Bool = false
    @AppStorage("roundTippedDropperSodium") var roundTippedDropperSodium: Bool = false
    
    public init() {
    }
    
    public var body: some View {
        TabView {
            RecipesTab()
                .tabItem {
                    Label(title: { Text("Recipes") }, icon: { Image("waterbottle-skip", bundle: .module) })
                }
            SettingsTab()
                .tabItem {
                    Label(title: { Text("Settings") }, icon: { Image("slider.horizontal.3-skip", bundle: .module) })
                }
        }
        .onAppear {
            updatePartsPerMillionValues()
            updateDescription()
            updateScreenIdleTimer(disableIdleTimer: disableIdleTimer)
            updateUnits()
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(mainBRState)
}

func updateScreenIdleTimer(disableIdleTimer: Bool) {
    if disableIdleTimer {
        UIApplication.shared.isIdleTimerDisabled = true
    } else {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
