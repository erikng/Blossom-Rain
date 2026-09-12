//
//  SettingsTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct SettingsTab: View {
    @Environment(BRState.self) private var brState
    @Environment(RecipeLibrary.self) private var library
    @AppStorage("defaultUnit") var defaultUnit: Units = .milliliter
    @AppStorage("disableIdleTimer") var disableIdleTimer: Bool = true
    @AppStorage("roundTippedDropperCalcium") var roundTippedDropperCalcium: Bool = true
    @AppStorage("roundTippedDropperMagnesium") var roundTippedDropperMagnesium: Bool = true
    @AppStorage("roundTippedDropperPotassium") var roundTippedDropperPotassium: Bool = true
    @AppStorage("roundTippedDropperSodium") var roundTippedDropperSodium: Bool = true
    @AppStorage("useManualVolumeInput") var useManualVolumeInput: Bool = false
    @AppStorage("volumeInputStepper") var volumeInputStepper: Double = 25.0
    private let volumeInputSteppers = [1.0, 5.0, 10.0, 20.0, 25.0]
    
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
                            Picker("Volume Input Steps (mL)", selection: $volumeInputStepper) {
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
                    
                    #if os(iOS)
                    VStack(alignment: .leading) {
                        Toggle(isOn: $disableIdleTimer) {
                            VStack(alignment: .leading) {
                                Text("Disable Screen Sleep")
                                Text("Prevent the device from going to sleep while the app is active.")
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
                        Text("The unit selected when you start the app.")
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
                        Text("The recipe selected when you start the app.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Picker("Recipes", selection: Binding(
                            get: { library.defaultID },
                            set: { library.setDefault($0) }
                        )) {
                            RecipePickerOptions(includeCustomEditor: false)
                        }
                        .accessibilityIdentifier("defaultRecipePicker")
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
            .formStyle(.grouped)
            .navigationTitle("Settings")
            .inlineNavigationTitle()
        }
        // Keep preference effects with their editor, including when the Mac recipe window is closed.
        .onChange(of: defaultUnit) { brState.unit = defaultUnit }
        .onChange(of: useManualVolumeInput) { brState.setManualInput(useManualVolumeInput) }
    }
}
