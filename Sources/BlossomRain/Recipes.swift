//
//  Recipes.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import Foundation

// Define the Recipe struct
struct Recipe: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var calciumPartsPerMillion: Double
    var magnesiumPartsPerMillion: Double
    var potassiumPartsPerMillion: Double
    var sodiumPartsPerMillion: Double
}

// Enum for Recipes that conforms to Identifiable using String as the ID
enum Recipes: String, CaseIterable, Identifiable {
    case bright_and_juicy, light_and_bright, light_and_bright_espresso, rao_perger, simple_and_sweet, simple_and_sweet_espresso
    
    // Use the rawValue of the enum as the id
    var id: String { self.rawValue }
    
    // Return the associated Recipe for each case
    var selectedRecipe: Recipe {
        switch self {
        case .bright_and_juicy: return brightAndJuicy
        case .light_and_bright: return lightAndBright
        case .light_and_bright_espresso: return lightAndBrightEspresso
        case .rao_perger: return raoPerger
        case .simple_and_sweet: return simpleAndSweet
        case .simple_and_sweet_espresso: return simpleAndSweetEspresso
        }
    }
}


// Configure the recipes
let brightAndJuicy = Recipe(
    id: UUID(),
    name: "Bright & Juicy",
    description: "Developed by [Mike Bawden](https://www.instagram.com/micsmox), Bright and Juicy gives a bright and balanced cup with a juicy mouthfeel. This is an approachable recipe and works well on a variety of coffees and brewers, but particularly shines with light to medium-light roasted washed coffees.",
    calciumPartsPerMillion: 36.0,
    magnesiumPartsPerMillion: 36.0,
    potassiumPartsPerMillion: 9.0,
    sodiumPartsPerMillion: 9.0
)

let lightAndBright = Recipe(
    id: UUID(),
    name: "Light & Bright",
    description: "Developed by the incredibly talented [Lance Hedrick](https://www.instagram.com/lancehedrick), Light and Bright was created with one goal in mind: To find a water recipe that highlights the acidity in coffee while also maintaining a high degree of flavor clarity. After hours of cupping different recipes, a clear winner stood out amongst the rest. This recipe is best used with lightly roasted coffee when a bright and flavorful cup is desired.",
    calciumPartsPerMillion: 60.0,
    magnesiumPartsPerMillion: 0.0,
    potassiumPartsPerMillion: 25.0,
    sodiumPartsPerMillion: 0.0
)

let lightAndBrightEspresso = Recipe(
    id: UUID(),
    name: "Light & Bright (Espresso)",
    description: "Developed by the incredibly talented [Lance Hedrick](https://www.instagram.com/lancehedrick), Light and Bright was created with one goal in mind: To find a water recipe that highlights the acidity in coffee while also maintaining a high degree of flavor clarity. After hours of cupping different recipes, a clear winner stood out amongst the rest. This recipe is best used with lightly roasted coffee when a bright and flavorful cup is desired.",
    calciumPartsPerMillion: 0.0,
    magnesiumPartsPerMillion: 20.0,
    potassiumPartsPerMillion: 45.0,
    sodiumPartsPerMillion: 0.0
)

let raoPerger = Recipe(
    id: UUID(),
    name: "Rao/Perger",
    description: "A very well balanced recipe and usable for pretty much anything. While very similar to our Simple and Sweet with regards to its total GH and KH, the increased magnesium helps create a more bodied and complex cup while the usage of equal parts sodium and potassium give a moderate acidity that is bright but not sharp and smooth but not boring.",
    calciumPartsPerMillion: 27.2,
    magnesiumPartsPerMillion: 60.0,
    potassiumPartsPerMillion: 20.0,
    sodiumPartsPerMillion: 20.0
)

let simpleAndSweet = Recipe(
    id: UUID(),
    name: "Simple & Sweet",
    description: "Crafted by the wonderfully talented [Lance Hedrick](https://www.instagram.com/lancehedrick), Simple and Sweet was designed to help your brew a smooth and balanced cup suitable for any style of coffee. All four ingredients are used for this recipe with the goal being to bring out the best each mineral has to offer. If this is your first time using Lotus Water or if you simply don’t know what water to use for a new coffee this is a great place to start.",
    calciumPartsPerMillion: 60.0,
    magnesiumPartsPerMillion: 30.0,
    potassiumPartsPerMillion: 15.0,
    sodiumPartsPerMillion: 25.0
)

let simpleAndSweetEspresso = Recipe(
    id: UUID(),
    name: "Simple & Sweet (Espresso)",
    description: "",
    calciumPartsPerMillion: 0.0,
    magnesiumPartsPerMillion: 20.0,
    potassiumPartsPerMillion: 0.0,
    sodiumPartsPerMillion: 55.0
)
