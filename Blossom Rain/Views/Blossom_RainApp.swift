//
//  Blossom_RainApp.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

class BRState: ObservableObject {
    @Published var calciumDropperTypeMultiplier = 1.0
    @Published var calciumPartsPerMillion = 1.0
    @Published var magnesiumDropperTypeMultiplier = 1.0
    @Published var magnesiumPartsPerMillion = 1.0
    @Published var numberZeroStringFormatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .none
        formatter.zeroSymbol = ""
          return formatter
      }()
    @Published var potassiumDropperTypeMultiplier = 1.0
    @Published var potassiumPartsPerMillion = 1.0
    @Published var recipe: Recipes = .light_and_bright
    @Published var roundTippedDropperCalcium = userDefaults.bool(forKey: "roundTippedDropperCalcium")
    @Published var roundTippedDropperMagnesium = userDefaults.bool(forKey: "roundTippedDropperMagnesium")
    @Published var roundTippedDropperPotassium = userDefaults.bool(forKey: "roundTippedDropperPotassium")
    @Published var roundTippedDropperSodium = userDefaults.bool(forKey: "roundTippedDropperSodium")
    @Published var sodiumDropperTypeMultiplier = 1.0
    @Published var sodiumPartsPerMillion = 1.0
    @Published var unit: Units = .milliliter
    @Published var unitText = ""
    @Published var unitVolume = 1.0
    @Published var useManualVolumeInput = userDefaults.bool(forKey: "useManualVolumeInput")
    @Published var volumeInputStepper = userDefaults.double(forKey: "volumeInputStepper")
    @Published var volumeInputSteppers = [1.0, 5.0, 10.0, 20.0, 25.0]
}
var mainBRState = BRState()
let userDefaults = UserDefaults.standard

@main
struct Blossom_RainApp: App {
    @StateObject var brState = mainBRState
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(brState)
        }
    }
}
