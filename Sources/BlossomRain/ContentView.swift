//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var brState: BRState
    @AppStorage("defaultRecipe") var defaultRecipe: Recipes = .light_and_bright
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
                    Label(title: { Text("Recipes") }, icon: { Image("waterbottle-skip", bundle: .module) })
                }
            SettingsTab()
                .tabItem {
                    Label(title: { Text("Settings") }, icon: { Image("slider.horizontal.3-skip", bundle: .module) })
                }
        }
        .onAppear {
            brState.recipe = defaultRecipe
            brState.unit = defaultUnit
            updatePartsPerMillionValues(selectedRecipe: defaultRecipe)
            updateDescription(selectedRecipe: defaultRecipe)
            updateScreenIdleTimer(disableIdleTimer: disableIdleTimer)
            updateUnits(selectedUnit: brState.unit)
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
    }
}

func updateScreenIdleTimer(disableIdleTimer: Bool) {
    #if !os(macOS)
    if disableIdleTimer {
        UIApplication.shared.isIdleTimerDisabled = true
    } else {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    #endif
}

//#Preview {
//    ContentView()
//        .environmentObject(mainBRState)
//}
