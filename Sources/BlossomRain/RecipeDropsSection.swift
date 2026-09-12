import SwiftUI

struct RecipeDropsSection: View {
    let recipe: Recipe
    @Environment(BRState.self) private var brState
    @AppStorage("roundTippedDropperCalcium") private var calcium = true
    @AppStorage("roundTippedDropperMagnesium") private var magnesium = true
    @AppStorage("roundTippedDropperPotassium") private var potassium = true
    @AppStorage("roundTippedDropperSodium") private var sodium = true

    var body: some View {
        Section("Drops") {
            if let volume = brState.volume,
               let drops = RecipeCalculator.drops(for: recipe, volume: volume, unit: brState.unit,
                    droppers: DropperConfiguration(calcium: calcium, magnesium: magnesium,
                                                  potassium: potassium, sodium: sodium)) {
                ForEach(drops) { drop in
                    HStack {
                        Text(LocalizedStringKey(drop.mineral.name))
                        Spacer()
                        Text(drop.count, format: .number).bold().monospacedDigit()
                    }
                    .foregroundStyle(drop.mineral.dropTextColor)
                    #if os(macOS)
                    // macOS grouped forms do not render listRowBackground.
                    .padding(8)
                    .background(drop.mineral.dropBackgroundColor, in: RoundedRectangle(cornerRadius: 6))
                    #else
                    .listRowBackground(drop.mineral.dropBackgroundColor)
                    #endif
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("drops-\(drop.mineral.rawValue)")
                }
            } else {
                Text("Enter a valid volume to calculate drops.")
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("invalidVolumeMessage")
            }
        }
    }
}

private extension RecipeMineral {
    var dropTextColor: Color {
        // The lighter mineral colors need dark text in either system appearance.
        self == .magnesium ? .white : .black
    }

    var dropBackgroundColor: Color {
        switch self {
        case .calcium: return Color(red: 232.0/255.0, green: 202.0/255.0, blue: 187.0/255.0)
        case .magnesium: return Color(red: 172.0/255.0, green: 85.0/255.0, blue: 95.0/255.0)
        case .potassium: return Color(red: 117.0/255.0, green: 166.0/255.0, blue: 167.0/255.0)
        case .sodium: return Color(red: 251.0/255.0, green: 240.0/255.0, blue: 242.0/255.0)
        }
    }
}
