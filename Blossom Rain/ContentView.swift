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
    @State private var useManualVolumeInput = defaults.bool(forKey: "useManualVolumeInput")
    @State private var volumeInputStepper = defaults.double(forKey: "volumeInputStepper")
    let volumeInputSteppers = [1.0, 5.0, 10.0, 20.0, 25.0]
    private let numberZeroStringFormatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .none
        formatter.zeroSymbol = ""
          return formatter
      }()

    var body: some View {
        TabView {
            Form {
                Section {
                    Picker("Recipes", selection: $recipe) {
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
                Section {
                    Picker("Unit", selection: $unit) {
                        Text("Milliliter").tag(Units.milliliter)
                        Text("Liter").tag(Units.liter)
                        Text("Gallon").tag(Units.gallon)
                    }
                        #if os(macOS)
                        .pickerStyle(.inline)
                        #endif
                    if useManualVolumeInput {
                        if unit == .milliliter {
                            HStack {
                                #if os(macOS)
                                let mlText = "Volume (ml)"
                                #else
                                let mlText = "Enter your desired volume in milliliters"
                                #endif
                                TextField(mlText, value: $mlVolume, formatter: numberZeroStringFormatter)
                                    #if !os(macOS)
                                    .keyboardType(.numbersAndPunctuation)
                                    #else
                                    .frame(width: 450.0)
                                    .fixedSize()
                                    #endif
                            }
                        }
                        if unit == .liter {
                            HStack {
                                #if os(macOS)
                                let lText = "Volume (l)"
                                #else
                                let lText = "Enter your desired volume in liters"
                                #endif
                                TextField(lText, value: $lVolume, formatter: numberZeroStringFormatter)
                                    #if !os(macOS)
                                    .keyboardType(.numbersAndPunctuation)
                                    #else
                                    .frame(width: 450.0)
                                    .fixedSize()
                                    #endif
                            }
                        }
                        if unit == .gallon {
                            HStack {
                                #if os(macOS)
                                let gText = "Volume (g)"
                                #else
                                let gText = "Enter your desired volume in gallons"
                                #endif
                                TextField(gText, value: $gVolume, formatter: numberZeroStringFormatter)
                                    #if !os(macOS)
                                    .keyboardType(.numbersAndPunctuation)
                                    #else
                                    .frame(width: 450.0)
                                    .fixedSize()
                                    #endif
                            }
                        }
                    } else {
                        if unit == .milliliter {
                            HStack {
                                if volumeInputStepper > 0.0 {
                                    Slider(value: $mlVolume, in: 0...1000, step: volumeInputStepper)
                                } else {
                                    Slider(value: $mlVolume, in: 0...1000, step: 5)
                                }
                                Text(String(Int(mlVolume)))
                            }
                        }
                        if unit == .liter {
                            HStack {
                                Slider(value: $lVolume, in: 0...20, step: 1)
                                Text(String(Int(lVolume)))
                            }
                        }
                        if unit == .gallon {
                            HStack {
                                Slider(value: $gVolume, in: 0...5, step: 1)
                                Text(String(Int(gVolume)))
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
                        if unit == .milliliter {
                            let calciumMlCalculation = (0.55*calciumDropCount)*(mlVolume/4500)/calciumMultiplier
                            Text(String(Int(round(calciumMlCalculation))))
                                .bold()
                        } else if unit == .liter {
                            let calciumLCalculation = (0.55*calciumDropCount)*(lVolume/4.5)/calciumMultiplier
                            Text(String(Int(round(calciumLCalculation))))
                                .bold()
                        } else if unit == .gallon {
                            let calciumGCalculation = (0.55*calciumDropCount)*(gVolume/4500/3785)/calciumMultiplier
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
                        if unit == .milliliter {
                            let magnesiumMlCalculcation = (0.54*magnesiumDropCount)*(mlVolume/4500)/magnesiumMultiplier
                            Text(String(Int(round(magnesiumMlCalculcation))))
                                .bold()
                        } else if unit == .liter {
                            let magnesiumLCalculcation = (0.54*magnesiumDropCount)*(lVolume/4.5)/magnesiumMultiplier
                            Text(String(Int(round(magnesiumLCalculcation))))
                                .bold()
                        } else if unit == .gallon {
                            let magnesiumGCalculcation = (0.54*magnesiumDropCount)*(gVolume/4500/3785)/magnesiumMultiplier
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
                        if unit == .milliliter {
                            let potassiumMlCalculcation = (2*0.56*potassiumDropCount)*(mlVolume/4500)/potassiumMultiplier
                            Text(String(Int(round(potassiumMlCalculcation))))
                                .bold()
                        } else if unit == .liter {
                            let potassiumLCalculcation = (2*0.56*potassiumDropCount)*(lVolume/4.5)/potassiumMultiplier
                            Text(String(Int(round(potassiumLCalculcation))))
                                .bold()
                        } else if unit == .gallon {
                            let potassiumGCalculcation = (2*0.56*potassiumDropCount)*(gVolume/(4500/3785))/potassiumMultiplier
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
                        if unit == .milliliter {
                            let sodiumMlCalculcation = (2*0.58*sodiumDropCount)*(mlVolume/4500)/sodiumMultiplier
                            Text(String(Int(round(sodiumMlCalculcation))))
                                .bold()
                        } else if unit == .liter {
                            let sodiumLCalculcation = (2*0.58*sodiumDropCount)*(lVolume/4.5)/sodiumMultiplier
                            Text(String(Int(round(sodiumLCalculcation))))
                                .bold()
                        } else if unit == .gallon {
                            let sodiumGCalculcation = (2*0.58*sodiumDropCount)*(gVolume/(4500/3785))/sodiumMultiplier
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
            Form {
                Section {
                    Toggle(isOn: $useManualVolumeInput) {
                        VStack(alignment: .leading) {
                            Text("Manual Volume Input")
                            Text("If you would prefer to input the volume manually, select this option.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onChange(of: useManualVolumeInput) {
                        defaults.set(useManualVolumeInput, forKey: "useManualVolumeInput")
                        mlVolume = 0.0
                        lVolume = 0.0
                        gVolume = 0.0
                    }
                    
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
                            .onChange(of: volumeInputStepper) {
                                defaults.set(volumeInputStepper, forKey: "volumeInputStepper")
                            }
                        }
                    }
                } header: {
                    Text("User Interface")
                } footer: {}
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
        .onAppear {
            if 0.0 >= volumeInputStepper {
                volumeInputStepper = 5.0
            }
            calculateMultipliers()
        }
    }
    func calculateMultipliers() {
        if roundTippedDropperCalcium == true {
            calciumMultiplier = 1.0
        } else {
            calciumMultiplier = 0.56
        }
        if roundTippedDropperMagnesium == true {
            magnesiumMultiplier = 1.0
        } else {
            magnesiumMultiplier = 0.56
        }
        if roundTippedDropperPotassium == true {
            potassiumMultiplier = 1.0
        } else {
            potassiumMultiplier = 0.56
        }
        if roundTippedDropperSodium == true {
            sodiumMultiplier = 1.0
        } else {
            sodiumMultiplier = 0.56
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
