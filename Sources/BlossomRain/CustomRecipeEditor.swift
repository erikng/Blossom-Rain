import SwiftUI

struct CustomRecipeEditor: View {
    @EnvironmentObject private var library: RecipeLibrary
    @FocusState.Binding var focusedField: RecipeInputField?

    var body: some View {
        Section {
            ForEach(RecipeMineral.allCases) { mineral in
                VStack(alignment: .leading) {
                    HStack {
                        Text(LocalizedStringKey(mineral.name))
                        Spacer()
                        TextField("ppm", text: Binding(
                            get: { library.draft[mineral] },
                            set: { library.draft[mineral] = $0 }
                        ))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(minWidth: 60, maxWidth: 110)
                        .focused($focusedField, equals: .mineral(mineral))
                        .accessibilityLabel("\(mineral.name) target in ppm")
                        .accessibilityIdentifier("custom-\(mineral.rawValue)")
                        Text("ppm").foregroundStyle(.secondary)
                    }

                    Slider(value: Binding(
                        get: { library.draft.value(for: mineral) ?? 0 },
                        set: { library.draft.setSliderValue($0, for: mineral) }
                    ), in: 0...150, step: 1)
                    .accessibilityLabel("\(mineral.name) target")

                    if library.draft.value(for: mineral) == nil {
                        Text("Enter a number from 0 to 150.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
        } header: {
            Text(library.editingRecipeID == nil ? "Custom Recipe" : "Edit Custom Recipe")
        } footer: {
            Text("Mineral targets are in ppm as CaCO₃.")
        }
    }
}

struct RecipePickerOptions: View {
    @EnvironmentObject private var library: RecipeLibrary
    var includeCustomEditor = true

    var body: some View {
        Section("Lotus Recipes") {
            ForEach(Recipes.allCases) { recipe in
                Text(recipe.selectedRecipe.name).tag(recipe.rawValue)
            }
        }
        if !library.savedRecipes.isEmpty {
            Section("Saved Recipes") {
                ForEach(library.savedRecipes) { recipe in
                    Text(recipe.name).tag(RecipeLibrary.selectionID(for: recipe))
                }
            }
        }
        if includeCustomEditor {
            Text("Custom Recipe").tag(RecipeLibrary.customSelectionID)
        }
    }
}
