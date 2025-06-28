//
//  RecipesTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct RecipesTab: View {
    @EnvironmentObject var brState: BRState
    @AppStorage("defaultRecipe") var defaultRecipe: Recipes = .light_and_bright
    @AppStorage("defaultUnit") var defaultUnit: Units = .milliliter
    @AppStorage("useManualVolumeInput") var useManualVolumeInput: Bool = false
    @AppStorage("volumeInputStepper") var volumeInputStepper: Double = 25.0
    @FocusState private var keyboardIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Recipes", selection: $brState.recipe) {
                        ForEach(Recipes.allCases) { recipe in
                            Text(recipe.selectedRecipe.name)
                                .tag(recipe)
                        }
                    }
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
                            #if !os(macOS)
                            .keyboardType(.numberPad)
                            #endif
                            
                            #if !SKIP
                            .focused($keyboardIsFocused)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer()
                                        Button("Close", systemImage: "checkmark.circle.fill", action: {
                                            keyboardIsFocused = false
                                        })
                                        .buttonStyle(.borderedProminent)
                                        .tint(.green)
                                    }
                                }
                            }
                            #endif
                        }
                    } else {
                        HStack {
                            let max = brState.unit.selectedUnit.maxStep
                            let stepSize = brState.unit == .milliliter ? volumeInputStepper : brState.unit.selectedUnit.initialStep
                            if [1.0, 5.0, 10.0].contains(volumeInputStepper) && brState.unit == .milliliter {
                                Slider(
                                    value: Binding<Double>(
                                        get: { brState.unitVolume },
                                        set: { newValue in
                                            let rounded = (newValue / stepSize).rounded() * stepSize
                                            brState.unitVolume = rounded
                                        }
                                    ),
                                    in: 0...max
                                )
                            } else {
                                Slider(
                                    value: Binding<Double>(
                                        get: { brState.unitVolume },
                                        set: { newValue in
                                            let rounded = (newValue / stepSize).rounded() * stepSize
                                            brState.unitVolume = rounded
                                        }
                                    ),
                                    in: 0...max,
                                    step: stepSize
                                )
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
                
                Section {
                    // TODO: Refactor the calculations for all four minerals
                    // The only difference between each of these computed text values are the milliliter, liter, and gallon (primary, secondary) dividers
                    HStack {
                        Text("Calcium")
                        Spacer()
                        let calciumDropCount: Int = {
                            let baseMultiplier = calciumComposition.baseMultiplier * calciumComposition.partsPerMillionMultiplier * brState.calciumPartsPerMillion
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: calciumComposition.mlVolumeDivider,
                                lVolumeDivider: calciumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: calciumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: calciumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume / brState.calciumDropperTypeMultiplier))
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
                            let baseMultiplier = magnesiumComposition.baseMultiplier * magnesiumComposition.partsPerMillionMultiplier * brState.magnesiumPartsPerMillion
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: magnesiumComposition.mlVolumeDivider,
                                lVolumeDivider: magnesiumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: magnesiumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: magnesiumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume / brState.magnesiumDropperTypeMultiplier))
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
                            let baseMultiplier = potassiumComposition.baseMultiplier * potassiumComposition.partsPerMillionMultiplier * brState.potassiumPartsPerMillion
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: potassiumComposition.mlVolumeDivider,
                                lVolumeDivider: potassiumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: potassiumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: potassiumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume / brState.potassiumDropperTypeMultiplier))
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
                            let baseMultiplier = sodiumComposition.baseMultiplier * sodiumComposition.partsPerMillionMultiplier * brState.sodiumPartsPerMillion
                            let unitVolume = unitVolumeCalculator(
                                mlVolumeDivider: sodiumComposition.mlVolumeDivider,
                                lVolumeDivider: sodiumComposition.lVolumeDivider,
                                gPrimaryVolumeDivider: sodiumComposition.gPrimaryVolumeDivider,
                                gSecondaryVolumeDivider: sodiumComposition.gSecondaryVolumeDivider
                            )
                            return Int(round(baseMultiplier * unitVolume / brState.sodiumDropperTypeMultiplier))
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
                
                Section {
                    HStack {
                        if !brState.recipeDescription.isEmpty {
                            Text(LocalizedStringKey(brState.recipeDescription))
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
            .navigationTitle("Recipes")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label(title: { Text("Recipes") }, icon: { Image("waterbottle-skip", bundle: .module) })
                        .foregroundColor(.secondary)
                }
            }
        }
        #if !SKIP
        .scrollDismissesKeyboard(.immediately)
        .onTapGesture(count: keyboardIsFocused ? 1 : .max, perform: {
            // if keyboard shown use single tap to close it, otherwise set .max to not interfere with other swiftui elements
            keyboardIsFocused = false
        })
        #endif
        // TODO: Move the .onChange back when step-ui supports modifiers in line
        .onChange(of: brState.unitVolumeString) {
            brState.unitVolume = Double(brState.unitVolumeString) ?? 0.0
        }
        .onChange(of: brState.recipe) {
            updatePartsPerMillionValues(selectedRecipe: brState.recipe)
            updateDescription(selectedRecipe: brState.recipe)
        }
        .onChange(of: brState.unit) {
            updateUnits(selectedUnit: brState.unit)
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
