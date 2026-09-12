import Foundation

enum RecipeMineral: String, CaseIterable, Identifiable {
    case calcium, magnesium, potassium, sodium

    var id: String { rawValue }
    var name: String { rawValue.capitalized }
}

struct RecipeIon: Identifiable {
    let name: String
    let symbol: String
    let partsPerMillion: Int

    var id: String { symbol }
}

extension Recipe {
    // Match the target-water calculations in Reference/Lotus/calculate_values.js.
    // These are concentrations, independent of batch volume and rounded drop counts.
    var hardness: Double { magnesiumPartsPerMillion + calciumPartsPerMillion }
    var alkalinity: Double { potassiumPartsPerMillion + sodiumPartsPerMillion }
    var hardnessAxisMaximum: Double { hardness > 160 ? hardness * 1.2 : 160 }
    var alkalinityAxisMaximum: Double { alkalinity > 100 ? alkalinity * 1.2 : 100 }

    var ions: [RecipeIon] {
        let calcium = calciumPartsPerMillion * (40.078 / 100.0)
        let magnesium = magnesiumPartsPerMillion * (24.305 / 100.0)
        let potassium = 2 * potassiumPartsPerMillion * (39.0983 / 100.0)
        let sodium = 2 * sodiumPartsPerMillion * (22.989 / 100.0)
        let chlorideFromMagnesium = 2 * magnesiumPartsPerMillion * (35.453 / 100.0)
        let chlorideFromCalcium = 2 * calciumPartsPerMillion * (35.453 / 100.0)
        let bicarbonateFromSodium = 2 * sodiumPartsPerMillion * (61.016 / 100.0)
        let bicarbonateFromPotassium = 2 * potassiumPartsPerMillion * (61.016 / 100.0)
        return [
            RecipeIon(name: "Calcium", symbol: "Ca²⁺", partsPerMillion: Int(calcium.rounded())),
            RecipeIon(name: "Magnesium", symbol: "Mg²⁺", partsPerMillion: Int(magnesium.rounded())),
            RecipeIon(name: "Potassium", symbol: "K⁺", partsPerMillion: Int(potassium.rounded())),
            RecipeIon(name: "Sodium", symbol: "Na⁺", partsPerMillion: Int(sodium.rounded())),
            RecipeIon(name: "Chloride", symbol: "Cl⁻", partsPerMillion:
                Int((chlorideFromMagnesium + chlorideFromCalcium).rounded())),
            RecipeIon(name: "Bicarbonate", symbol: "HCO₃⁻", partsPerMillion:
                Int((bicarbonateFromSodium + bicarbonateFromPotassium).rounded()))
        ]
    }
}

struct CustomRecipeDraft {
    var id: UUID
    var name: String
    private var values: [RecipeMineral: String]

    init(recipe: Recipe? = nil) {
        id = recipe?.id ?? UUID()
        name = recipe?.name ?? ""
        // These are the website's custom editor defaults, not its zero-valued option.
        let targets: [RecipeMineral: Double] = [
            .calcium: recipe?.calciumPartsPerMillion ?? 60,
            .magnesium: recipe?.magnesiumPartsPerMillion ?? 30,
            .potassium: recipe?.potassiumPartsPerMillion ?? 25,
            .sodium: recipe?.sodiumPartsPerMillion ?? 15
        ]
        values = targets.mapValues(Self.format)
    }

    subscript(mineral: RecipeMineral) -> String {
        get { values[mineral] ?? "" }
        set { values[mineral] = newValue }
    }

    static func format(_ value: Double) -> String {
        value.formatted(.number.grouping(.never).precision(.fractionLength(0...10)))
    }

    func value(for mineral: RecipeMineral, locale: Locale = .current) -> Double? {
        let text = self[mineral].trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: locale.decimalSeparator ?? ".", with: ".")
        guard let value = Double(text), value.isFinite, (0...150).contains(value) else {
            return nil
        }
        return value
    }

    var recipe: Recipe? {
        guard let calcium = value(for: .calcium), let magnesium = value(for: .magnesium),
              let potassium = value(for: .potassium), let sodium = value(for: .sodium) else {
            return nil
        }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return Recipe(id: id, name: trimmedName.isEmpty ? "Custom Recipe" : trimmedName,
                      description: "Your custom Lotus Water recipe.",
                      calciumPartsPerMillion: calcium, magnesiumPartsPerMillion: magnesium,
                      potassiumPartsPerMillion: potassium, sodiumPartsPerMillion: sodium)
    }
}
