//
//  Blossom_RainApp.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI

@main
struct Blossom_RainApp: App {
    @StateObject var appState = primaryState
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

let defaults = UserDefaults.standard
var primaryState = AppState()

class AppState: ObservableObject {
    @Published var calciumMultiplier = 1.0
    @Published var magnesiumMultiplier = 1.0
    @Published var potassiumMultiplier = 1.0
    @Published var sodiumMultiplier = 1.0
    @Published var mlVolume = 450.0
    @Published var lVolume = 1.0
    @Published var gVolume = 1.0
    @Published var unit: Units = .milliliter
    @Published var recipe: Recipes = .none
    @Published var calciumDropCount = 0.0
    @Published var magnesiumDropCount = 0.0
    @Published var potassiumDropCount = 0.0
    @Published var sodiumDropCount = 0.0
    @Published var roundTippedDropperCalcium = defaults.bool(forKey: "roundTippedDropperCalcium")
    @Published var roundTippedDropperMagnesium = defaults.bool(forKey: "roundTippedDropperMagnesium")
    @Published var roundTippedDropperPotassium = defaults.bool(forKey: "roundTippedDropperPotassium")
    @Published var roundTippedDropperSodium = defaults.bool(forKey: "roundTippedDropperSodium")
    @Published var useManualVolumeInput = defaults.bool(forKey: "useManualVolumeInput")
    @Published var volumeInputStepper = defaults.double(forKey: "volumeInputStepper")
    @Published var volumeInputSteppers = [1.0, 5.0, 10.0, 20.0, 25.0]
    @Published var numberZeroStringFormatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .none
        formatter.zeroSymbol = ""
          return formatter
      }()
}


enum Recipes: String, CaseIterable, Identifiable {
    case none, light_and_bright, light_and_bright_espresso, simple_and_sweet, simple_and_sweet_espresso, rao_perger
    var id: Self { self }
}

enum Units: String, CaseIterable, Identifiable {
    case milliliter, liter, gallon
    var id: Self { self }
}

func calculateMultipliers() {
    if primaryState.roundTippedDropperCalcium == true {
        primaryState.calciumMultiplier = 1.0
    } else {
        primaryState.calciumMultiplier = 0.56
    }
    if primaryState.roundTippedDropperMagnesium == true {
        primaryState.magnesiumMultiplier = 1.0
    } else {
        primaryState.magnesiumMultiplier = 0.56
    }
    if primaryState.roundTippedDropperPotassium == true {
        primaryState.potassiumMultiplier = 1.0
    } else {
        primaryState.potassiumMultiplier = 0.56
    }
    if primaryState.roundTippedDropperSodium == true {
        primaryState.sodiumMultiplier = 1.0
    } else {
        primaryState.sodiumMultiplier = 0.56
    }
}
