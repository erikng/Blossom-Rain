//
//  Recipes.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

// Configure the recipes
let lightAndBright = Recipe(
    id: UUID(),
    name: "Light & Bright",
    calciumPartsPerMillion: 60.0,
    magnesiumPartsPerMillion: 0.0,
    potassiumPartsPerMillion: 25.0,
    sodiumPartsPerMillion: 0.0
)

let lightAndBrightEspresso = Recipe(
    id: UUID(),
    name: "Light & Bright (Espresso)",
    calciumPartsPerMillion: 0.0,
    magnesiumPartsPerMillion: 20.0,
    potassiumPartsPerMillion: 45.0,
    sodiumPartsPerMillion: 0.0
)

let raoPerger = Recipe(
    id: UUID(),
    name: "Rao/Perger",
    calciumPartsPerMillion: 27.2,
    magnesiumPartsPerMillion: 60.0,
    potassiumPartsPerMillion: 20.0,
    sodiumPartsPerMillion: 20.0
)

let simpleAndSweet = Recipe(
    id: UUID(),
    name: "Simple & Sweet",
    calciumPartsPerMillion: 60.0,
    magnesiumPartsPerMillion: 30.0,
    potassiumPartsPerMillion: 15.0,
    sodiumPartsPerMillion: 25.0
)

let simpleAndSweetEspresso = Recipe(
    id: UUID(),
    name: "Simple & Sweet (Espresso)",
    calciumPartsPerMillion: 0.0,
    magnesiumPartsPerMillion: 20.0,
    potassiumPartsPerMillion: 0.0,
    sodiumPartsPerMillion: 55.0
)

// Recipes
enum Recipes: String, CaseIterable, Identifiable {
    case light_and_bright, light_and_bright_espresso, rao_perger, simple_and_sweet, simple_and_sweet_espresso
    var id: Self { self }
}

extension Recipes {
    var selectedRecipe: Recipe {
        switch self {
        case .light_and_bright: return lightAndBright
        case .light_and_bright_espresso: return lightAndBrightEspresso
        case .rao_perger: return raoPerger
        case .simple_and_sweet: return simpleAndSweet
        case .simple_and_sweet_espresso: return simpleAndSweetEspresso
        }
    }
}

struct Recipe: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var calciumPartsPerMillion: Double
    var magnesiumPartsPerMillion: Double
    var potassiumPartsPerMillion: Double
    var sodiumPartsPerMillion: Double
}
