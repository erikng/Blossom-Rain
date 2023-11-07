//
//  RecipesTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct RecipesTab: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section {
                Picker("Recipes", selection: $appState.recipe) {
                    #if !os(macOS)
                    Text("").tag(Recipes.none)
                    #endif
                    Text("Light & Bright").tag(Recipes.light_and_bright)
                    Text("Light & Bright (Espresso)").tag(Recipes.light_and_bright_espresso)
                    Text("Rao/Perger").tag(Recipes.rao_perger)
                    Text("Simple & Sweet").tag(Recipes.simple_and_sweet)
                    Text("Simple & Sweet (Espresso)").tag(Recipes.simple_and_sweet_espresso)
                }
                    #if os(macOS)
                    .pickerStyle(.inline)
                    #endif
                    .onChange(of: appState.recipe) {
                    if appState.recipe == .light_and_bright {
                        appState.calciumDropCount = 60.0
                        appState.magnesiumDropCount = 0.0
                        appState.potassiumDropCount = 25.0
                        appState.sodiumDropCount = 0.0
                    } else if appState.recipe == .light_and_bright_espresso {
                        appState.calciumDropCount = 0.0
                        appState.magnesiumDropCount = 20.0
                        appState.potassiumDropCount = 45.0
                        appState.sodiumDropCount = 0.0
                    } else if appState.recipe == .rao_perger {
                        appState.calciumDropCount = 27.2
                        appState.magnesiumDropCount = 60.0
                        appState.potassiumDropCount = 20.0
                        appState.sodiumDropCount = 20.0
                    } else if appState.recipe == .simple_and_sweet {
                        appState.calciumDropCount = 60.0
                        appState.magnesiumDropCount = 30.0
                        appState.potassiumDropCount = 15.0
                        appState.sodiumDropCount = 25.0
                    } else if appState.recipe == .simple_and_sweet_espresso {
                        appState.calciumDropCount = 0.0
                        appState.magnesiumDropCount = 20.0
                        appState.potassiumDropCount = 0.0
                        appState.sodiumDropCount = 55.0
                    } else {
                        appState.calciumDropCount = 0.0
                        appState.magnesiumDropCount = 0.0
                        appState.potassiumDropCount = 0.0
                        appState.sodiumDropCount = 0.0
                    }
                }
            }
            Section {
                Picker("Unit", selection: $appState.unit) {
                    Text("Milliliter").tag(Units.milliliter)
                    Text("Liter").tag(Units.liter)
                    Text("Gallon").tag(Units.gallon)
                }
                    #if os(macOS)
                    .pickerStyle(.inline)
                    #endif
                if appState.useManualVolumeInput {
                    if appState.unit == .milliliter {
                        HStack {
                            #if os(macOS)
                            let mlText = "Volume (ml)"
                            #else
                            let mlText = "Enter your desired volume in milliliters"
                            #endif
                            TextField(mlText, value: $appState.mlVolume, formatter: appState.numberZeroStringFormatter)
                                #if !os(macOS)
                                .keyboardType(.numbersAndPunctuation)
                                #else
                                .frame(width: 450.0)
                                .fixedSize()
                                #endif
                        }
                    }
                    if appState.unit == .liter {
                        HStack {
                            #if os(macOS)
                            let lText = "Volume (l)"
                            #else
                            let lText = "Enter your desired volume in liters"
                            #endif
                            TextField(lText, value: $appState.lVolume, formatter: appState.numberZeroStringFormatter)
                                #if !os(macOS)
                                .keyboardType(.numbersAndPunctuation)
                                #else
                                .frame(width: 450.0)
                                .fixedSize()
                                #endif
                        }
                    }
                    if appState.unit == .gallon {
                        HStack {
                            #if os(macOS)
                            let gText = "Volume (g)"
                            #else
                            let gText = "Enter your desired volume in gallons"
                            #endif
                            TextField(gText, value: $appState.gVolume, formatter: appState.numberZeroStringFormatter)
                                #if !os(macOS)
                                .keyboardType(.numbersAndPunctuation)
                                #else
                                .frame(width: 450.0)
                                .fixedSize()
                                #endif
                        }
                    }
                } else {
                    if appState.unit == .milliliter {
                        HStack {
                            if appState.volumeInputStepper > 0.0 {
                                Slider(value: $appState.mlVolume, in: 0...1000, step: appState.volumeInputStepper)
                            } else {
                                Slider(value: $appState.mlVolume, in: 0...1000, step: 5)
                            }
                            Text(String(Int(appState.mlVolume)))
                        }
                    }
                    if appState.unit == .liter {
                        HStack {
                            Slider(value: $appState.lVolume, in: 0...20, step: 1)
                            Text(String(Int(appState.lVolume)))
                        }
                    }
                    if appState.unit == .gallon {
                        HStack {
                            Slider(value: $appState.gVolume, in: 0...5, step: 1)
                            Text(String(Int(appState.gVolume)))
                        }
                    }
                }
            } header: {
                Text("Volume")
            } footer: {}
            
            Section {
                HStack {
                    Text("Calcium")
                    Spacer()
                    if appState.unit == .milliliter {
                        let calciumMlCalculation = (0.55*appState.calciumDropCount)*(appState.mlVolume/4500)/appState.calciumMultiplier
                        Text(String(Int(round(calciumMlCalculation))))
                            .bold()
                    } else if appState.unit == .liter {
                        let calciumLCalculation = (0.55*appState.calciumDropCount)*(appState.lVolume/4.5)/appState.calciumMultiplier
                        Text(String(Int(round(calciumLCalculation))))
                            .bold()
                    } else if appState.unit == .gallon {
                        let calciumGCalculation = (0.55*appState.calciumDropCount)*(appState.gVolume/4500/3785)/appState.calciumMultiplier
                        Text(String(Int(round(calciumGCalculation))))
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
                    if appState.unit == .milliliter {
                        let magnesiumMlCalculcation = (0.54*appState.magnesiumDropCount)*(appState.mlVolume/4500)/appState.magnesiumMultiplier
                        Text(String(Int(round(magnesiumMlCalculcation))))
                            .bold()
                    } else if appState.unit == .liter {
                        let magnesiumLCalculcation = (0.54*appState.magnesiumDropCount)*(appState.lVolume/4.5)/appState.magnesiumMultiplier
                        Text(String(Int(round(magnesiumLCalculcation))))
                            .bold()
                    } else if appState.unit == .gallon {
                        let magnesiumGCalculcation = (0.54*appState.magnesiumDropCount)*(appState.gVolume/4500/3785)/appState.magnesiumMultiplier
                        Text(String(Int(round(magnesiumGCalculcation))))
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
                    // Compiler couldn't handle this many computations at once so splitting it into variables
                    if appState.unit == .milliliter {
                        let potassiumMlCalculcation = (2*0.56*appState.potassiumDropCount)*(appState.mlVolume/4500)/appState.potassiumMultiplier
                        Text(String(Int(round(potassiumMlCalculcation))))
                            .bold()
                    } else if appState.unit == .liter {
                        let potassiumLCalculcation = (2*0.56*appState.potassiumDropCount)*(appState.lVolume/4.5)/appState.potassiumMultiplier
                        Text(String(Int(round(potassiumLCalculcation))))
                            .bold()
                    } else if appState.unit == .gallon {
                        let potassiumGCalculcation = (2*0.56*appState.potassiumDropCount)*(appState.gVolume/(4500/3785))/appState.potassiumMultiplier
                        Text(String(Int(round(potassiumGCalculcation))))
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
                    // Compiler couldn't handle this many computations at once so splitting it into variables
                    if appState.unit == .milliliter {
                        let sodiumMlCalculcation = (2*0.58*appState.sodiumDropCount)*(appState.mlVolume/4500)/appState.sodiumMultiplier
                        Text(String(Int(round(sodiumMlCalculcation))))
                            .bold()
                    } else if appState.unit == .liter {
                        let sodiumLCalculcation = (2*0.58*appState.sodiumDropCount)*(appState.lVolume/4.5)/appState.sodiumMultiplier
                        Text(String(Int(round(sodiumLCalculcation))))
                            .bold()
                    } else if appState.unit == .gallon {
                        let sodiumGCalculcation = (2*0.58*appState.sodiumDropCount)*(appState.gVolume/(4500/3785))/appState.sodiumMultiplier
                        Text(String(Int(round(sodiumGCalculcation))))
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
        .environmentObject(primaryState)
}

