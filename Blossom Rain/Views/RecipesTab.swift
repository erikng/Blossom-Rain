//
//  RecipesTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct RecipesTab: View {
    @EnvironmentObject var brState: BRState
    
    var body: some View {
        Form {
            Section {
                Picker("Recipes", selection: $brState.recipe) {
                    ForEach(Recipes.allCases) { recipe in
                        Text(recipe.selectedRecipe.name)
                            .tag(recipe.selectedRecipe)
                    }
                }
                    #if os(macOS)
                    .pickerStyle(.inline)
                    #endif
                    .onChange(of: brState.recipe) {
                        updatePartsPerMillionValues()
                    }
            }
            Section {
                Picker("Unit", selection: $brState.unit) {
                    ForEach(Units.allCases) { unit in
                        Text(unit.selectedUnit.name)
                            .tag(unit.selectedUnit)
                    }
                }
                    #if os(macOS)
                    .pickerStyle(.inline)
                    #endif
                    .onChange(of: brState.unit) {
                        updateUnits()
                    }
                if brState.useManualVolumeInput {
                    HStack {
                        TextField(
                            brState.unitText,
                            value: $brState.unitVolume,
                            formatter: brState.numberZeroStringFormatter
                        )
                            #if !os(macOS)
                            .keyboardType(.numbersAndPunctuation)
                            #else
                            .frame(width: 450.0)
                            .fixedSize()
                            #endif
                    }
                } else {
                    HStack {
                        if brState.unit == .milliliter && brState.volumeInputStepper > 0.0 {
                            Slider(
                                value: $brState.unitVolume,
                                in: 0...brState.unit.selectedUnit.maxStep,
                                step: brState.volumeInputStepper
                            )
                        } else {
                            Slider(
                                value: $brState.unitVolume,
                                in: 0...brState.unit.selectedUnit.maxStep,
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
                    if brState.unit == .milliliter {
                        Text(String(Int(round((calciumComposition.baseMultiplier*calciumComposition.partsPerMillionMultiplier*brState.calciumPartsPerMillion)*(brState.unitVolume/calciumComposition.mlVolumeDivider)/brState.calciumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .liter {
                        Text(String(Int(round((calciumComposition.baseMultiplier*calciumComposition.partsPerMillionMultiplier*brState.calciumPartsPerMillion)*(brState.unitVolume/calciumComposition.lVolumeDivider)/brState.calciumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .gallon {
                        Text(String(Int(round((calciumComposition.baseMultiplier*calciumComposition.partsPerMillionMultiplier*brState.calciumPartsPerMillion)*(brState.unitVolume/(calciumComposition.gPrimaryVolumeDivider/calciumComposition.gSecondaryVolumeDivider))/brState.calciumDropperTypeMultiplier))))
                            .bold()
                    }

                }
                #if !os(macOS)
                .foregroundColor(.white)
                .listRowBackground(Color("Calcium"))
                #endif
                HStack {
                    Text("Magnesium")
                    Spacer()
                    if brState.unit == .milliliter {
                        Text(String(Int(round((magnesiumComposition.baseMultiplier*magnesiumComposition.partsPerMillionMultiplier*brState.magnesiumPartsPerMillion)*(brState.unitVolume/magnesiumComposition.mlVolumeDivider)/brState.magnesiumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .liter {
                        Text(String(Int(round((magnesiumComposition.baseMultiplier*magnesiumComposition.partsPerMillionMultiplier*brState.magnesiumPartsPerMillion)*(brState.unitVolume/magnesiumComposition.lVolumeDivider)/brState.magnesiumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .gallon {
                        Text(String(Int(round((magnesiumComposition.baseMultiplier*magnesiumComposition.partsPerMillionMultiplier*brState.magnesiumPartsPerMillion)*(brState.unitVolume/(magnesiumComposition.gPrimaryVolumeDivider/magnesiumComposition.gSecondaryVolumeDivider))/brState.magnesiumDropperTypeMultiplier))))
                            .bold()
                    }
                }
                #if !os(macOS)
                .foregroundColor(.white)
                .listRowBackground(Color("Magnesium"))
                #endif
                HStack {
                    Text("Potassium")
                    Spacer()
                    if brState.unit == .milliliter {
                        Text(String(Int(round((potassiumComposition.baseMultiplier*potassiumComposition.partsPerMillionMultiplier*brState.potassiumPartsPerMillion)*(brState.unitVolume/potassiumComposition.mlVolumeDivider)/brState.potassiumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .liter {
                        Text(String(Int(round((potassiumComposition.baseMultiplier*potassiumComposition.partsPerMillionMultiplier*brState.potassiumPartsPerMillion)*(brState.unitVolume/potassiumComposition.lVolumeDivider)/brState.potassiumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .gallon {
                        Text(String(Int(round((potassiumComposition.baseMultiplier*potassiumComposition.partsPerMillionMultiplier*brState.potassiumPartsPerMillion)*(brState.unitVolume/(potassiumComposition.gPrimaryVolumeDivider/potassiumComposition.gSecondaryVolumeDivider))/brState.potassiumDropperTypeMultiplier))))
                            .bold()
                    }
                }
                #if !os(macOS)
                .foregroundColor(.white)
                .listRowBackground(Color("Potassium"))
                #endif
                HStack {
                    Text("Sodium")
                    Spacer()
                    if brState.unit == .milliliter {
                        Text(String(Int(round((sodiumComposition.baseMultiplier*sodiumComposition.partsPerMillionMultiplier*brState.sodiumPartsPerMillion)*(brState.unitVolume/sodiumComposition.mlVolumeDivider)/brState.sodiumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .liter {
                        Text(String(Int(round((sodiumComposition.baseMultiplier*sodiumComposition.partsPerMillionMultiplier*brState.sodiumPartsPerMillion)*(brState.unitVolume/sodiumComposition.lVolumeDivider)/brState.sodiumDropperTypeMultiplier))))
                            .bold()
                    } else if brState.unit == .gallon {
                        Text(String(Int(round((sodiumComposition.baseMultiplier*sodiumComposition.partsPerMillionMultiplier*brState.sodiumPartsPerMillion)*(brState.unitVolume/(sodiumComposition.gPrimaryVolumeDivider/sodiumComposition.gSecondaryVolumeDivider))/brState.sodiumDropperTypeMultiplier))))
                            .bold()
                    }
                }
                #if !os(macOS)
                .foregroundColor(Color("SodiumText"))
                .listRowBackground(Color("Sodium"))
                #endif
            } header: {
                Text("Drops")
                    .padding(.top)
            } footer: {}
            Text("Purchase these drops at [Lotus Coffee Products](https://lotuscoffeeproducts.com/collections/all)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
            .tabItem {
                Label("Recipes", systemImage: "waterbottle")
            }
    }
}

#Preview {
    RecipesTab()
        .environmentObject(mainBRState)
}

