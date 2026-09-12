import Foundation

@main
struct RecipeCalculationChecks {
    struct Sample: Decodable {
        var rawValue: String
        var ppm: [Double]
        var unit: String
        var volume: Double
        var roundStyles: [Bool]
        var drops: [Int]
        var ions: [Int]
        var x: Double
        var y: Double
        var xMax: Double
        var yMax: Double
    }

    static func main() throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))
        let samples = try JSONDecoder().decode([Sample].self, from: data)
        var failures = 0
        let probe = RecipeCalculatorProbe()
        for sample in samples {
            let recipe: Recipe
            if sample.rawValue.hasPrefix("custom-") {
                recipe = Recipe(id: UUID(), name: "Custom Recipe", description: "",
                    calciumPartsPerMillion: sample.ppm[0], magnesiumPartsPerMillion: sample.ppm[1],
                    potassiumPartsPerMillion: sample.ppm[2], sodiumPartsPerMillion: sample.ppm[3])
            } else {
                guard let preset = Recipes(rawValue: sample.rawValue) else {
                    fatalError("Missing published preset: \(sample.rawValue)")
                }
                recipe = preset.selectedRecipe
            }
            mainBRState.unit = Units(rawValue: sample.unit)!
            mainBRState.unitVolume = sample.volume
            calculateMultipliers(roundTippedDropperCalcium: sample.roundStyles[0],
                roundTippedDropperMagnesium: sample.roundStyles[1],
                roundTippedDropperPotassium: sample.roundStyles[2],
                roundTippedDropperSodium: sample.roundStyles[3])
            let actualDrops = probe.drops(for: recipe)
            let actualIons = recipe.ions.map(\.partsPerMillion)
            if actualDrops != sample.drops || actualIons != sample.ions ||
                recipe.alkalinity != sample.x || recipe.hardness != sample.y ||
                recipe.alkalinityAxisMaximum != sample.xMax || recipe.hardnessAxisMaximum != sample.yMax {
                failures += 1
                if failures < 10 {
                    print("FAIL: \(sample.rawValue), \(sample.volume) \(sample.unit), droppers \(sample.roundStyles)")
                    print("Drops \(actualDrops) expected \(sample.drops); ions \(actualIons) expected \(sample.ions)")
                }
            }
        }
        print("Lotus parity: \(samples.count * 4) drop values, \(samples.count * 6) ion values, \(samples.count) chart positions/scales; \(failures) failures")
        exit(failures == 0 ? 0 : 1)
    }
}
