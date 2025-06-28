//
//  SettingsTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject var brState: BRState
    @AppStorage("defaultRecipe") var defaultRecipe: Recipes = .light_and_bright
    @AppStorage("defaultUnit") var defaultUnit: Units = .milliliter
    @AppStorage("disableIdleTimer") var disableIdleTimer: Bool = true
    @AppStorage("roundTippedDropperCalcium") var roundTippedDropperCalcium: Bool = true
    @AppStorage("roundTippedDropperMagnesium") var roundTippedDropperMagnesium: Bool = true
    @AppStorage("roundTippedDropperPotassium") var roundTippedDropperPotassium: Bool = true
    @AppStorage("roundTippedDropperSodium") var roundTippedDropperSodium: Bool = true
    @AppStorage("useManualVolumeInput") var useManualVolumeInput: Bool = false
    @AppStorage("volumeInputStepper") var volumeInputStepper: Double = 25.0
    var volumeInputSteppers = [1.0, 5.0, 10.0, 20.0, 25.0]
    
    var body: some View {
        NavigationStack {
            Form {
                // Volume Input
                Section {
                    if !useManualVolumeInput {
                        VStack(alignment: .leading) {
                            Text("Volume Input Steps (mL)")
                            Text("The amount of steps the **milliliter** slider will increase or decrease by.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Picker("Appearance", selection: $volumeInputStepper) {
                                ForEach(volumeInputSteppers, id: \.self) {
                                    Text(String(Int($0)))
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    VStack(alignment: .leading) {
                        Toggle(isOn: $useManualVolumeInput) {
                            VStack(alignment: .leading) {
                                Text("Manual Volume Input")
                                Text("If you would prefer to input the volume manually, select this option.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    #if !targetEnvironment(macCatalyst)
                    VStack(alignment: .leading) {
                        Toggle(isOn: $disableIdleTimer) {
                            VStack(alignment: .leading) {
                                Text("Disable Screen Sleep")
                                Text("Prevent the device from going to sleep while the application running.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    #endif
                } header: {
                    Text("User Interface")
                } footer: {}
                
                // Round or Straight Tipped Droppers
                Section {
                    Toggle(isOn: $roundTippedDropperCalcium) {
                        Text("Calcium")
                    }
                    Toggle(isOn: $roundTippedDropperMagnesium) {
                        Text("Magnesium")
                    }
                    Toggle(isOn: $roundTippedDropperPotassium) {
                        Text("Potassium")
                    }
                    Toggle(isOn: $roundTippedDropperSodium) {
                        Text("Sodium")
                    }
                } header: {
                    Text("Round Tipped Droppers")
                } footer: {
                    Text("Lotus Water ships with two types of droppers: \n•Round Tipped\n•Straight Tipped\n\nIf your bottle has a **rounded tip**, please select it above to ensure the recipe is accurate.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                // Defaults
                Section {
                    VStack(alignment: .leading) {
                        Text("Default Unit")
                        Text("The unit when you start the app from deep sleep.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Picker("Unit", selection: $defaultUnit) {
                            ForEach(Units.allCases) { unit in
                                Text(unit.selectedUnit.name)
                                    .tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading) {
                        Text("Default Recipe")
                        Text("The recipe when you start the app from deep sleep.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Picker("Recipes", selection: $defaultRecipe) {
                            ForEach(Recipes.allCases) { recipe in
                                Text(recipe.selectedRecipe.name)
                                    .tag(recipe)
                            }
                        }
                    }
                } header: {
                    Text("Defaults")
                } footer: {}
                
                // The LCP Team
                Section {
                    Text("[Lotus Coffee Products](https://www.instagram.com/lotus.coffee.products) is:\n\n[Nick Chapman](https://www.instagram.com/nick.chapman.loves.coffee) (Founder)\n[Lance Hedrick](https://www.instagram.com/lancehedrick) (Co-Founder)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } header: {
                    Text("Acknowledgements")
                } footer: {}
            }
            .navigationTitle("Settings")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label(title: { Text("Settings") }, icon: { Image("slider.horizontal.3-skip", bundle: .module) })
                        .foregroundColor(.secondary)
                }
            }
        }
        // TODO: Move the .onChange back when step-ui supports modifiers in line
        .onChange(of: disableIdleTimer) {
            updateScreenIdleTimer(disableIdleTimer: disableIdleTimer)
        }
        .onChange(of: useManualVolumeInput) {
            updateUnits(selectedUnit: defaultUnit)
        }
        .onChange(of: defaultUnit) {
            brState.unit = defaultUnit
            updateUnits(selectedUnit: defaultUnit)
        }
        .onChange(of: defaultRecipe) {
            brState.recipe = defaultRecipe
            updatePartsPerMillionValues(selectedRecipe: defaultRecipe)
            updateDescription(selectedRecipe: defaultRecipe)
        }
        .onChange(of: roundTippedDropperCalcium) {
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
        .onChange(of: roundTippedDropperMagnesium) {
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
        .onChange(of: roundTippedDropperPotassium) {
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
        .onChange(of: roundTippedDropperSodium) {
            calculateMultipliers(roundTippedDropperCalcium: roundTippedDropperCalcium, roundTippedDropperMagnesium: roundTippedDropperMagnesium, roundTippedDropperPotassium: roundTippedDropperPotassium, roundTippedDropperSodium: roundTippedDropperSodium)
        }
    }
}

//#Preview {
//    SettingsTab()
//        .environmentObject(mainBRState)
//}
