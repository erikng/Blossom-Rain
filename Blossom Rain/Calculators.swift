//
//  Calculators.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

// Recipe Calculations
struct MineralDropEquation: Codable, Hashable, Identifiable {
    var id: UUID
    var baseMultiplier: Double
    var partsPerMillionMultiplier: Double
    var mlVolumeDivider: Double
    var lVolumeDivider: Double
    var gPrimaryVolumeDivider: Double
    var gSecondaryVolumeDivider: Double
}

let calciumComposition = MineralDropEquation(
    id: UUID(),
    baseMultiplier: 1.0,
    partsPerMillionMultiplier: 0.55,
    mlVolumeDivider: 4500.0,
    lVolumeDivider: 4.5,
    gPrimaryVolumeDivider: 4500.0,
    gSecondaryVolumeDivider: 3785.0
)
let magnesiumComposition = MineralDropEquation(
    id: UUID(),
    baseMultiplier: 1.0,
    partsPerMillionMultiplier: 0.54,
    mlVolumeDivider: 4500.0,
    lVolumeDivider: 4.5,
    gPrimaryVolumeDivider: 4500.0,
    gSecondaryVolumeDivider: 3785.0
)
let potassiumComposition = MineralDropEquation(
    id: UUID(),
    baseMultiplier: 2.0,
    partsPerMillionMultiplier: 0.56,
    mlVolumeDivider: 4500.0,
    lVolumeDivider: 4.5,
    gPrimaryVolumeDivider: 4500.0,
    gSecondaryVolumeDivider: 3785.0
)
let sodiumComposition = MineralDropEquation(
    id: UUID(),
    baseMultiplier: 2.0,
    partsPerMillionMultiplier: 0.58,
    mlVolumeDivider: 4500.0,
    lVolumeDivider: 4.5,
    gPrimaryVolumeDivider: 4500.0,
    gSecondaryVolumeDivider: 3785.0
)

func calculateMultipliers() {
    mainBRState.calciumDropperTypeMultiplier = mainBRState.roundTippedDropperCalcium ? 1.0 : 0.56
    mainBRState.magnesiumDropperTypeMultiplier = mainBRState.roundTippedDropperMagnesium ? 1.0 : 0.56
    mainBRState.potassiumDropperTypeMultiplier = mainBRState.roundTippedDropperPotassium ? 1.0 : 0.56
    mainBRState.sodiumDropperTypeMultiplier = mainBRState.roundTippedDropperSodium ? 1.0 : 0.56
}

func updatePartsPerMillionValues() {
    mainBRState.calciumPartsPerMillion = mainBRState.recipe.selectedRecipe.calciumPartsPerMillion
    mainBRState.magnesiumPartsPerMillion = mainBRState.recipe.selectedRecipe.magnesiumPartsPerMillion
    mainBRState.potassiumPartsPerMillion = mainBRState.recipe.selectedRecipe.potassiumPartsPerMillion
    mainBRState.sodiumPartsPerMillion = mainBRState.recipe.selectedRecipe.sodiumPartsPerMillion
}
