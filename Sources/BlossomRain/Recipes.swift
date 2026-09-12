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
    // Keep rao_perger as the stored value so existing default-recipe selections survive.
    case bright_and_juicy, light_and_bright, light_and_bright_espresso, rao_perger, simple_and_sweet, simple_and_sweet_espresso, ultra_light
    
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
        case .ultra_light: return ultraLight
        }
    }
}


// Published presets: https://lotuscoffeeproducts.com/pages/product-instructions
// Synced 2026-09-12; upstream data is saved in Reference/Lotus/recipes.json.
// Mineral targets use Lotus's ppm-as-CaCO3 basis, not individual ion concentrations.
let brightAndJuicy = Recipe(
    id: UUID(),
    name: "Bright & Juicy",
    description: "Developed by Mike Bawden founder of [Curious Coffee](https://www.curious-coffee.com/), Bright and Juicy gives a bright and balanced cup with a juicy mouthfeel. This is an approachable recipe and works well on a variety of coffees and brewers, but particularly shines with light to medium-light roasted washed coffees.",
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
    // The espresso variant shares its creator and description with the filter recipe.
    description: lightAndBright.description,
    calciumPartsPerMillion: 0.0,
    magnesiumPartsPerMillion: 20.0,
    potassiumPartsPerMillion: 45.0,
    sodiumPartsPerMillion: 0.0
)

let raoPerger = Recipe(
    id: UUID(),
    name: "Rao's Recipe",
    description: "An updated recipe from Scott Rao. This is a very well balanced recipe that is usable for pretty much anything. Including all four minerals helps to maximize flavor while keeping the overall TDS low enhances clarity and acidity.",
    calciumPartsPerMillion: 40.2,
    magnesiumPartsPerMillion: 32.1,
    potassiumPartsPerMillion: 8.0,
    sodiumPartsPerMillion: 12.1
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
    description: simpleAndSweet.description,
    calciumPartsPerMillion: 0.0,
    magnesiumPartsPerMillion: 20.0,
    potassiumPartsPerMillion: 0.0,
    sodiumPartsPerMillion: 55.0
)

let ultraLight = Recipe(
    id: UUID(),
    name: "Ultra Light",
    description: "This recipe is designed to get out of the way of the coffee, giving it just enough structure to complement what is inherently there without overwhelming your senses. This water is intentionally very soft to allow for maximum terroir-driven complexity.",
    calciumPartsPerMillion: 20.0,
    magnesiumPartsPerMillion: 15.0,
    potassiumPartsPerMillion: 10.0,
    sodiumPartsPerMillion: 0.0
)
