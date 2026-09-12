//
//  RecipesTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

enum RecipeInputField: Hashable {
    case name
    case mineral(RecipeMineral)
    case volume
}

struct RecipesTab: View {
    @EnvironmentObject var brState: BRState
    @EnvironmentObject private var library: RecipeLibrary
    @AppStorage("defaultUnit") var defaultUnit: Units = .milliliter
    @AppStorage("useManualVolumeInput") var useManualVolumeInput: Bool = false
    @AppStorage("volumeInputStepper") var volumeInputStepper: Double = 25.0
    @FocusState private var focusedField: RecipeInputField?
    @State private var recipeToDelete: Recipe?
    @State private var errorMessage: String?
    @State private var errorTitle: LocalizedStringKey = "Could Not Delete Recipe"
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Recipes", selection: Binding(
                        get: { library.selectedID },
                        set: { library.select($0) }
                    )) {
                        RecipePickerOptions()
                    }
                    .accessibilityIdentifier("recipePicker")
                    if let saved = library.selectedSavedRecipe {
                        HStack {
                            Button("Edit Recipe") { library.editSelectedRecipe() }
                            Spacer()
                            Button("Delete Recipe", role: .destructive) { recipeToDelete = saved }
                        }
                        .buttonStyle(.borderless)
                    }
                }

                if let message = library.loadError {
                    Section { Text(message).foregroundStyle(.red) }
                }
                if library.selectedID == RecipeLibrary.customSelectionID {
                    CustomRecipeEditor(focusedField: $focusedField)
                }

                Section {
                    Picker("Unit", selection: $brState.unit) {
                        ForEach(Units.allCases) { unit in
                            Text(unit.selectedUnit.name)
                                .tag(unit)
                        }
                    }

                    if useManualVolumeInput {
                        HStack {
                            TextField(text: $brState.unitVolumeString) {
                                Text(brState.unitText)
                            }
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .volume)
                        }
                    } else {
                        HStack {
                            let max = brState.unit.selectedUnit.maxStep
                            let stepSize = brState.unit == .milliliter ? volumeInputStepper : brState.unit.selectedUnit.initialStep
                            let shouldOmitStep = brState.unit == .milliliter && [1.0, 5.0, 10.0].contains(volumeInputStepper)

                            let binding = Binding<Double>(
                                get: { brState.unitVolume },
                                set: { newValue in
                                    let rounded = (newValue / stepSize).rounded() * stepSize
                                    brState.unitVolume = rounded
                                }
                            )

                            if shouldOmitStep {
                                Slider(value: binding, in: 0...max)
                            } else {
                                Slider(value: binding, in: 0...max, step: stepSize)
                            }

                            // Display as Int if steps are whole numbers, else with decimal precision
                            if stepSize.truncatingRemainder(dividingBy: 1.0) == 0 {
                                Text("\(Int(brState.unitVolume))")
                            } else {
                                Text(String(format: "%.2f", brState.unitVolume))
                            }
                        }
                    }
                } header: {
                    Text("Volume")
                } footer: {}
                
                if let recipe = library.currentRecipe {
                Section {
                    // TODO: Refactor the calculations for all four minerals
                    // The only difference between each of these computed text values are the milliliter, liter, and gallon (primary, secondary) dividers
                    HStack {
                        Text("Calcium")
                        Spacer()
                        let calciumDropCount: Int = {
                            // Match Lotus's operation order at half-drop rounding boundaries.
                            let baseMultiplier = calciumComposition.baseMultiplier * recipe.calciumPartsPerMillion
                            let dropperMultiplier = calciumComposition.partsPerMillionMultiplier / brState.calciumDropperTypeMultiplier
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: calciumComposition.mlVolumeDivider,
                                lVolumeDivider: calciumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: calciumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: calciumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume * dropperMultiplier))
                        }()
                        Text("\(calciumDropCount)")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color(red: 232.0/255.0, green: 202.0/255.0, blue: 187.0/255.0))

                    HStack {
                        Text("Magnesium")
                        Spacer()
                        let magnesiumDropCount: Int = {
                            let baseMultiplier = magnesiumComposition.baseMultiplier * recipe.magnesiumPartsPerMillion
                            let dropperMultiplier = magnesiumComposition.partsPerMillionMultiplier / brState.magnesiumDropperTypeMultiplier
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: magnesiumComposition.mlVolumeDivider,
                                lVolumeDivider: magnesiumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: magnesiumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: magnesiumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume * dropperMultiplier))
                        }()
                        Text("\(magnesiumDropCount)")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color(red: 172.0/255.0, green: 85.0/255.0, blue: 95.0/255.0))

                    HStack {
                        Text("Potassium")
                        Spacer()
                        let potassiumDropCount: Int = {
                            let baseMultiplier = potassiumComposition.baseMultiplier * recipe.potassiumPartsPerMillion
                            let dropperMultiplier = potassiumComposition.partsPerMillionMultiplier / brState.potassiumDropperTypeMultiplier
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: potassiumComposition.mlVolumeDivider,
                                lVolumeDivider: potassiumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: potassiumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: potassiumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume * dropperMultiplier))
                        }()
                        Text("\(potassiumDropCount)")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color(red: 117.0/255.0, green: 166.0/255.0, blue: 167.0/255.0))

                    HStack {
                        Text("Sodium")
                        Spacer()
                        let sodiumDropCount: Int = {
                            let baseMultiplier = sodiumComposition.baseMultiplier * recipe.sodiumPartsPerMillion
                            let dropperMultiplier = sodiumComposition.partsPerMillionMultiplier / brState.sodiumDropperTypeMultiplier
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: sodiumComposition.mlVolumeDivider,
                                lVolumeDivider: sodiumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: sodiumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: sodiumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume * dropperMultiplier))
                        }()
                        Text("\(sodiumDropCount)")
                            .bold()
                    }
                    .foregroundColor(Color(red: 117.0/255.0, green: 166.0/255.0, blue: 167.0/255.0))
                    .listRowBackground(Color(red: 251.0/255.0, green: 240.0/255.0, blue: 242.0/255.0))
                } header: {
                    Text("Drops")
                        .padding(.top)
                } footer: {}

                RecipeAnalysisView(recipe: recipe)

                Section {
                    HStack {
                        if !recipe.description.isEmpty {
                            Text(LocalizedStringKey(recipe.description))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Recipe Information")
                } footer: {
                    Text("Purchase these drops at [Lotus Coffee Products](https://lotuscoffeeproducts.com/collections/all)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                }

                // Keep actions last, including when invalid input hides the recipe preview.
                if library.selectedID == RecipeLibrary.customSelectionID {
                    Section {
                        VStack(spacing: 12) {
                            Button(action: saveCustomRecipe) {
                                Text(library.editingRecipeID == nil ? "Save Recipe" : "Save Changes")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .keyboardShortcut(.defaultAction)
                            .disabled(!library.canSaveDraft)
                            .accessibilityIdentifier("saveCustomRecipe")

                            Button("Cancel", role: .cancel) {
                                focusedField = nil
                                library.cancelEditing()
                            }
                            .buttonStyle(.borderless)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .accessibilityIdentifier("cancelCustomRecipe")
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .onSubmit { saveCustomRecipe() }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label("Recipes", systemImage: "waterbottle")
                        .foregroundColor(.secondary)
                }
                // Own the keyboard toolbar here once; Section rows can duplicate it.
                if focusedField != nil {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { focusedField = nil }
                            .accessibilityIdentifier("dismissRecipeKeyboard")
                    }
                }
            }
        }
        .confirmationDialog("Delete \(recipeToDelete?.name ?? "recipe")?", isPresented: Binding(
            get: { recipeToDelete != nil },
            set: { if !$0 { recipeToDelete = nil } }
        ), titleVisibility: .visible) {
            Button("Delete Recipe", role: .destructive) {
                guard let recipe = recipeToDelete else { return }
                do { try library.deleteRecipe(recipe.id) }
                catch {
                    errorTitle = "Could Not Delete Recipe"
                    errorMessage = error.localizedDescription
                }
                recipeToDelete = nil
            }
        }
        .alert(errorTitle, isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        .scrollDismissesKeyboard(.immediately)
        .onTapGesture(count: focusedField == .volume ? 1 : .max, perform: {
            // Preserve tap-to-dismiss for manual volume input without intercepting editor controls.
            focusedField = nil
        })
        .onChange(of: brState.unitVolumeString) {
            brState.unitVolume = Double(brState.unitVolumeString) ?? 0.0
        }
        .onChange(of: brState.unit) {
            updateUnits(selectedUnit: brState.unit)
        }
    }

    private func saveCustomRecipe() {
        guard library.selectedID == RecipeLibrary.customSelectionID, library.canSaveDraft else { return }
        focusedField = nil
        do { try library.saveDraft() }
        catch {
            errorTitle = "Could Not Save Recipe"
            errorMessage = error.localizedDescription
        }
    }

    func unitVolumeCalculator(mlVolumeDivider: Double, lVolumeDivider: Double, gPrimaryVolumeDivider: Double, gSecondaryVolumeDivider: Double) -> Double {
        let unitVolume: Double
        switch brState.unit {
            case .milliliter:
                unitVolume = brState.unitVolume / sodiumComposition.mlVolumeDivider
            case .liter:
                unitVolume = brState.unitVolume / sodiumComposition.lVolumeDivider
            default:
                unitVolume = brState.unitVolume / (sodiumComposition.gPrimaryVolumeDivider / sodiumComposition.gSecondaryVolumeDivider)
        }
        return unitVolume
    }
}

//#Preview {
//    RecipesTab()
//        .environmentObject(mainBRState)
//}
