import Foundation

struct DropperConfiguration: Equatable, Sendable {
    var calcium = true
    var magnesium = true
    var potassium = true
    var sodium = true

    func isRoundTipped(_ mineral: RecipeMineral) -> Bool {
        switch mineral {
        case .calcium: return calcium
        case .magnesium: return magnesium
        case .potassium: return potassium
        case .sodium: return sodium
        }
    }
}

struct MineralDropCount: Identifiable, Sendable {
    let mineral: RecipeMineral
    let count: Int
    var id: RecipeMineral { mineral }
}

enum RecipeCalculator {
    static func drops(for recipe: Recipe, volume: Double, unit: Units,
                      droppers: DropperConfiguration) -> [MineralDropCount]? {
        var result: [MineralDropCount] = []
        for mineral in RecipeMineral.allCases {
            guard let count = dropCount(partsPerMillion: recipe.partsPerMillion(for: mineral),
                                        mineral: mineral, volume: volume, unit: unit,
                                        roundTipped: droppers.isRoundTipped(mineral)) else { return nil }
            result.append(MineralDropCount(mineral: mineral, count: count))
        }
        return result
    }

    static func dropCount(partsPerMillion: Double, mineral: RecipeMineral,
                          volume: Double, unit: Units, roundTipped: Bool) -> Int? {
        guard partsPerMillion.isFinite, partsPerMillion >= 0,
              volume.isFinite, volume >= 0 else { return nil }

        let normalizedVolume: Double
        switch unit {
        case .milliliter: normalizedVolume = volume / 4500.0
        case .liter: normalizedVolume = volume / 4.5
        case .gallon: normalizedVolume = volume / (4500.0 / 3785.0)
        }
        let baseMultiplier = (mineral == .calcium || mineral == .magnesium ? 1.0 : 2.0) * partsPerMillion
        let dropperMultiplier = 0.56 / (roundTipped ? 1.0 : 0.56)
        // Preserve Lotus's operation order at half-drop rounding boundaries.
        let rounded = (baseMultiplier * normalizedVolume * dropperMultiplier).rounded()
        // A manual input may overflow Int even when the Double is finite.
        return Int(exactly: rounded)
    }
}
