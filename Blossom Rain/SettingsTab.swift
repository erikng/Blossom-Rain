//
//  SettingsTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $appState.useManualVolumeInput) {
                    VStack(alignment: .leading) {
                        Text("Manual Volume Input")
                        Text("If you would prefer to input the volume manually, select this option.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .onChange(of: appState.useManualVolumeInput) {
                    defaults.set(appState.useManualVolumeInput, forKey: "useManualVolumeInput")
                    appState.mlVolume = 0.0
                    appState.lVolume = 0.0
                    appState.gVolume = 0.0
                }
                
                if !appState.useManualVolumeInput {
                    VStack(alignment: .leading) {
                        Text("Volume Input Steps (mL)")
                        Text("The amount of steps the **milliliter** slider will increase or decrease by.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Picker("Appearance", selection: $appState.volumeInputStepper) {
                            ForEach(appState.volumeInputSteppers, id: \.self) {
                                Text(String(Int($0)))
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: appState.volumeInputStepper) {
                            defaults.set(appState.volumeInputStepper, forKey: "volumeInputStepper")
                        }
                    }
                }
            } header: {
                Text("User Interface")
            } footer: {}
            Section {
                Toggle(isOn: $appState.roundTippedDropperCalcium) {
                    Text("Calcium")
                }
                .onChange(of: appState.roundTippedDropperCalcium) {
                    defaults.set(appState.roundTippedDropperCalcium, forKey: "roundTippedDropperCalcium")
                    calculateMultipliers()
                }
                Toggle(isOn: $appState.roundTippedDropperMagnesium) {
                    Text("Magnesium")
                }
                .onChange(of: appState.roundTippedDropperMagnesium) {
                    defaults.set(appState.roundTippedDropperMagnesium, forKey: "roundTippedDropperMagnesium")
                    calculateMultipliers()
                }
                Toggle(isOn: $appState.roundTippedDropperPotassium) {
                    Text("Potassium")
                }
                .onChange(of: appState.roundTippedDropperPotassium) {
                    defaults.set(appState.roundTippedDropperPotassium, forKey: "roundTippedDropperPotassium")
                    calculateMultipliers()
                }
                Toggle(isOn: $appState.roundTippedDropperSodium) {
                    Text("Sodium")
                }
                .onChange(of: appState.roundTippedDropperSodium) {
                    defaults.set(appState.roundTippedDropperSodium, forKey: "roundTippedDropperSodium")
                    calculateMultipliers()
                }
            } header: {
                Text("Round Tipped Droppers")
            } footer: {
                Text("Lotus Water ships with two types of droppers: \n•Round Tipped\n•Straight Tipped\n\nIf your bottle has a **rounded tip**, please select it above to ensure the recipe is accurate.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Section {
                Text("[Lotus Coffee Products](https://www.instagram.com/lotus.coffee.products) is:\n\n[Nick Chapman](https://www.instagram.com/nick.chapman.loves.coffee) (Founder)\n[Lance Hedrick](https://www.instagram.com/lancehedrick) (Co-Founder)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } header: {
                Text("Acknowledgements")
            } footer: {}
        }
        .tabItem {
            Label("Settings", systemImage: "slider.horizontal.3")
        }
    }
}

#Preview {
    SettingsTab()
        .environmentObject(primaryState)
}

