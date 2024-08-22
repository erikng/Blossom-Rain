//
//  SettingsTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject var brState: BRState
    
    var body: some View {
        Form {
            // Volume Input
            Section {
                Toggle(isOn: $brState.useManualVolumeInput) {
                    VStack(alignment: .leading) {
                        Text("Manual Volume Input")
                        Text("If you would prefer to input the volume manually, select this option.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .onChange(of: brState.useManualVolumeInput) {
                    userDefaults.set(brState.useManualVolumeInput, forKey: "useManualVolumeInput")
                    updateUnits()
                }
                
                if !brState.useManualVolumeInput {
                    VStack(alignment: .leading) {
                        Text("Volume Input Steps (mL)")
                        Text("The amount of steps the **milliliter** slider will increase or decrease by.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Picker("Appearance", selection: $brState.volumeInputStepper) {
                            ForEach(brState.volumeInputSteppers, id: \.self) {
                                Text(String(Int($0)))
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: brState.volumeInputStepper) {
                            userDefaults.set(brState.volumeInputStepper, forKey: "volumeInputStepper")
                        }
                    }
                }
                Toggle(isOn: $brState.disableIdleTimer) {
                    VStack(alignment: .leading) {
                        Text("Disable Screen Sleep")
                        Text("Prevent the iOS device from going to sleep while the application running.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                }
            } header: {
                Text("User Interface")
            } footer: {}
                .onChange(of: brState.disableIdleTimer) {
                    userDefaults.set(brState.disableIdleTimer, forKey: "disableIdleTimer")
                    updateScreenIdleTimer()
                }

            // Round or Straight Tipped Droppers
            Section {
                Toggle(isOn: $brState.roundTippedDropperCalcium) {
                    Text("Calcium")
                }
                Toggle(isOn: $brState.roundTippedDropperMagnesium) {
                    Text("Magnesium")
                }
                Toggle(isOn: $brState.roundTippedDropperPotassium) {
                    Text("Potassium")
                }
                Toggle(isOn: $brState.roundTippedDropperSodium) {
                    Text("Sodium")
                }
            } header: {
                Text("Round Tipped Droppers")
            } footer: {
                Text("Lotus Water ships with two types of droppers: \n•Round Tipped\n•Straight Tipped\n\nIf your bottle has a **rounded tip**, please select it above to ensure the recipe is accurate.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .onChange(of: brState.roundTippedDropperCalcium) {
                userDefaults.set(brState.roundTippedDropperCalcium, forKey: "roundTippedDropperCalcium")
                calculateMultipliers()
            }
            .onChange(of: brState.roundTippedDropperMagnesium) {
                userDefaults.set(brState.roundTippedDropperMagnesium, forKey: "roundTippedDropperMagnesium")
                calculateMultipliers()
            }
            .onChange(of: brState.roundTippedDropperPotassium) {
                userDefaults.set(brState.roundTippedDropperPotassium, forKey: "roundTippedDropperPotassium")
                calculateMultipliers()
            }
            .onChange(of: brState.roundTippedDropperSodium) {
                userDefaults.set(brState.roundTippedDropperSodium, forKey: "roundTippedDropperSodium")
                calculateMultipliers()
            }
            
            // The LCP Team
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
        .environmentObject(mainBRState)
}

