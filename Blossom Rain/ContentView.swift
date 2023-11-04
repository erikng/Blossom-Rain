//
//  ContentView.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI
let defaults = UserDefaults.standard

struct ContentView: View {
    @State private var roundTippedDropperCalcium = defaults.bool(forKey: "roundTippedDropperCalcium")
    @State private var roundTippedDropperMagnesium = defaults.bool(forKey: "roundTippedDropperMagnesium")
    @State private var roundTippedDropperPotassium = defaults.bool(forKey: "roundTippedDropperPotassium")
    @State private var roundTippedDropperSodium = defaults.bool(forKey: "roundTippedDropperSodium")
    @State private var calciumMultiplier = 1.0
    @State private var magnesiumMultiplier = 1.0
    @State private var potassiumMultiplier = 1.0
    @State private var sodiumMultiplier = 1.0
    @State private var mlVolume = 450.0
    @State private var lVolume = 1.0
    @State private var gVolume = 1.0
    @State private var unit: Units = .milliliter
    @State private var recipe: Recipes = .none
    @State private var calciumDropCount = 0.0
    @State private var magnesiumDropCount = 0.0
    @State private var potassiumDropCount = 0.0
    @State private var sodiumDropCount = 0.0

    var body: some View {
        TabView {
            Form {
                Section() {
                    Picker("Recipes", selection: $recipe) {
                        Text("").tag(Recipes.none)
                        Text("Light & Bright").tag(Recipes.light_and_bright)
                        Text("Light & Bright (Espresso)").tag(Recipes.light_and_bright_espresso)
                        Text("Rao/Perger").tag(Recipes.rao_perger)
                        Text("Simple & Sweet").tag(Recipes.simple_and_sweet)
                        Text("Simple & Sweet (Espresso)").tag(Recipes.simple_and_sweet_espresso)
                    }
                    .onChange(of: recipe) {
                        if recipe == .light_and_bright {
                            calciumDropCount = 60.0
                            magnesiumDropCount = 0.0
                            potassiumDropCount = 25.0
                            sodiumDropCount = 0.0
                        } else if recipe == .light_and_bright_espresso {
                            calciumDropCount = 0.0
                            magnesiumDropCount = 20.0
                            potassiumDropCount = 45.0
                            sodiumDropCount = 0.0
                        } else if recipe == .rao_perger {
                            calciumDropCount = 27.2
                            magnesiumDropCount = 60.0
                            potassiumDropCount = 20.0
                            sodiumDropCount = 20.0
                        } else if recipe == .simple_and_sweet {
                            calciumDropCount = 60.0
                            magnesiumDropCount = 30.0
                            potassiumDropCount = 15.0
                            sodiumDropCount = 25.0
                        } else if recipe == .simple_and_sweet_espresso {
                            calciumDropCount = 0.0
                            magnesiumDropCount = 20.0
                            potassiumDropCount = 0.0
                            sodiumDropCount = 55.0
                        } else {
                            calciumDropCount = 0.0
                            magnesiumDropCount = 0.0
                            potassiumDropCount = 0.0
                            sodiumDropCount = 0.0
                        }
                    }
                }
                Section(header: Text("Volume")) {
                    Picker("Unit", selection: $unit) {
                        Text("Milliliter").tag(Units.milliliter)
                        Text("Liter").tag(Units.liter)
                        Text("Gallon").tag(Units.gallon)
                    }
                    if unit == .milliliter {
                        HStack {
                            Slider(value: $mlVolume, in: 250...1000, step: 1)
                            Text(String(Int(mlVolume)))
                        }
                    }
                    if unit == .liter {
                        HStack {
                            Slider(value: $lVolume, in: 1...15, step: 1)
                            Text(String(Int(lVolume)))
                        }
                    }
                    if unit == .gallon {
                        HStack {
                            Slider(value: $gVolume, in: 1...5, step: 1)
                            Text(String(Int(gVolume)))
                        }
                    }
                }
                Section(header: Text("Drops")) {
                    HStack {
                        Text("Calcium")
                        Spacer()
                        if unit == .milliliter {
                            Text(String(Int(round((calciumMultiplier*(0.55*calciumDropCount)*(mlVolume/4500))))))
                                .bold()
                        } else if unit == .liter {
                            Text(String(Int(round((calciumMultiplier*(0.55*calciumDropCount)*(lVolume/4.5))))))
                                .bold()
                        } else if unit == .gallon {
                            Text(String(Int(round((calciumMultiplier*(0.55*calciumDropCount)*(gVolume/(4500/3785)))))))
                                .bold()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color("Calcium"))
                    HStack {
                        Text("Magnesium")
                        Spacer()
                        if unit == .milliliter {
                            Text(String(Int(round((magnesiumMultiplier*(0.54*magnesiumDropCount)*(mlVolume/4500))))))
                                .bold()
                        } else if unit == .liter {
                            Text(String(Int(round((magnesiumMultiplier*(0.54*magnesiumDropCount)*(lVolume/4.5))))))
                                .bold()
                        } else if unit == .gallon {
                            Text(String(Int(round((magnesiumMultiplier*(0.54*magnesiumDropCount)*(gVolume/(4500/3785)))))))
                                .bold()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color("Magnesium"))
                    HStack {
                        Text("Potassium")
                        Spacer()
                        // Compiler couldn't handle this many computations at once so splitting it into variables
                        if unit == .milliliter {
                            let potassiumMlCalculcation = potassiumMultiplier*(2*0.56*potassiumDropCount)*(mlVolume/4500)
                            Text(String(Int(round(potassiumMlCalculcation))))
                                .bold()
                        } else if unit == .liter {
                            let potassiumLCalculcation = potassiumMultiplier*(2*0.56*potassiumDropCount)*(lVolume/4.5)
                            Text(String(Int(round(potassiumLCalculcation))))
                                .bold()
                        } else if unit == .gallon {
                            let potassiumGCalculcation = potassiumMultiplier*(2*0.56*potassiumDropCount)*(gVolume/(4500/3785))
                            Text(String(Int(round(potassiumGCalculcation))))
                                .bold()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color("Potassium"))
                    HStack {
                        Text("Sodium")
                        Spacer()
                        // Compiler couldn't handle this many computations at once so splitting it into variables
                        if unit == .milliliter {
                            let sodiumMlCalculcation = potassiumMultiplier*(2*0.58*sodiumDropCount)*(mlVolume/4500)
                            Text(String(Int(round(sodiumMlCalculcation))))
                                .bold()
                        } else if unit == .liter {
                            let sodiumLCalculcation = potassiumMultiplier*(2*0.58*sodiumDropCount)*(lVolume/4.5)
                            Text(String(Int(round(sodiumLCalculcation))))
                                .bold()
                        } else if unit == .gallon {
                            let sodiumGCalculcation = potassiumMultiplier*(2*0.58*sodiumDropCount)*(gVolume/(4500/3785))
                            Text(String(Int(round(sodiumGCalculcation))))
                                .bold()
                        }
                    }
                    .foregroundColor(Color("SodiumText"))
                    .listRowBackground(Color("Sodium"))
                }
                Text("Purchase these drops at [Lotus Coffee Products](https://lotuscoffeeproducts.com/collections/all)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
                .tabItem {
                    Label("Recipes", systemImage: "waterbottle")
                }
            Form {
                Section {
                    Toggle(isOn: $roundTippedDropperCalcium) {
                        Text("Calcium")
                    }
                    .onChange(of: roundTippedDropperCalcium) {
                        defaults.set(roundTippedDropperCalcium, forKey: "roundTippedDropperCalcium")
                        calculateMultipliers()
                    }
                    Toggle(isOn: $roundTippedDropperMagnesium) {
                        Text("Magnesium")
                    }
                    .onChange(of: roundTippedDropperMagnesium) {
                        defaults.set(roundTippedDropperMagnesium, forKey: "roundTippedDropperMagnesium")
                        calculateMultipliers()
                    }
                    Toggle(isOn: $roundTippedDropperPotassium) {
                        Text("Potassium")
                    }
                    .onChange(of: roundTippedDropperPotassium) {
                        defaults.set(roundTippedDropperPotassium, forKey: "roundTippedDropperPotassium")
                        calculateMultipliers()
                    }
                    Toggle(isOn: $roundTippedDropperSodium) {
                        Text("Sodium")
                    }
                    .onChange(of: roundTippedDropperSodium) {
                        defaults.set(roundTippedDropperSodium, forKey: "roundTippedDropperSodium")
                        calculateMultipliers()
                    }
                } header: {
                    Text("Round Tipped Droppers")
                } footer: {
                    Text("Lotus Water ships with two types of droppers: \n•Round Tipped\n•Straight Tipped\n\nIf your bottle has a **rounded tip**, please select it above to ensure the recipe is accurate.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
        }
        .onAppear {
            calculateMultipliers()
        }
    }
    func calculateMultipliers() {
        if roundTippedDropperCalcium == true {
            calciumMultiplier = 1.0
        } else {
            calciumMultiplier = 2.0
        }
        if roundTippedDropperMagnesium == true {
            magnesiumMultiplier = 1.0
        } else {
            magnesiumMultiplier = 2.0
        }
        if roundTippedDropperPotassium == true {
            potassiumMultiplier = 1.0
        } else {
            potassiumMultiplier = 2.0
        }
        if roundTippedDropperSodium == true {
            sodiumMultiplier = 1.0
        } else {
            sodiumMultiplier = 2.0
        }
    }
}

enum Recipes: String, CaseIterable, Identifiable {
    case none, light_and_bright, light_and_bright_espresso, simple_and_sweet, simple_and_sweet_espresso, rao_perger
    var id: Self { self }
}

enum Units: String, CaseIterable, Identifiable {
    case milliliter, liter, gallon
    var id: Self { self }
}

#Preview {
    ContentView()
}
