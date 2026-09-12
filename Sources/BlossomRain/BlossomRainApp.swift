//
//  Blossom_RainApp.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import Foundation
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
    @Published var recipeDescription: String = lightAndBright.description
    @Published var sodiumDropperTypeMultiplier = 1.0
    @Published var sodiumPartsPerMillion = 1.0
    @Published var unit: Units = .milliliter
    @Published var unitText = ""
    @Published var unitVolume = 1.0
    @Published var unitVolumeString = "1.0"
}
var mainBRState = BRState()

@main
struct BlossomRainApp: App {
    @StateObject private var brState: BRState = mainBRState

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(brState)
        }
    }
}
