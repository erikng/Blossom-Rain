//
//  RecipesTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct RecipesTab: View {
    @EnvironmentObject var brState: BRState
    @AppStorage("useManualVolumeInput") var useManualVolumeInput: Bool = false
    @AppStorage("volumeInputStepper") var volumeInputStepper: Double = 25.0
    #if !SKIP
    @FocusState private var keyboardIsFocused: Bool
    #endif
    
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
                            .keyboardType(.numberPad)
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
                            if brState.unit == .milliliter {
                                Slider(
                                    value: $brState.unitVolume,
                                    in: 0.0...brState.unit.selectedUnit.maxStep,
                                    step: volumeInputStepper
                                )
                            } else {
                                Slider(
                                    value: $brState.unitVolume,
                                    in: 0.0...brState.unit.selectedUnit.maxStep,
                                    step: brState.unit.selectedUnit.initialStep
                                )
                            }
                            Text(String(Int(brState.unitVolume)))
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
                            Text(try! AttributedString(markdown: brState.recipeDescription))
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
            .navigationBarTitleDisplayMode(.inline)
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
            updatePartsPerMillionValues()
            updateDescription()
        }
        .onChange(of: brState.unit) {
            updateUnits()
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

#Preview {
    RecipesTab()
        .environmentObject(mainBRState)
}

