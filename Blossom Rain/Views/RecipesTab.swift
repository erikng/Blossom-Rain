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
                #if !os(macOS)
                .foregroundColor(.white)
                .listRowBackground(Color("Calcium"))
                #endif
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
                #if !os(macOS)
                .foregroundColor(.white)
                .listRowBackground(Color("Magnesium"))
                #endif
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
                #if !os(macOS)
                .foregroundColor(.white)
                .listRowBackground(Color("Potassium"))
                #endif
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

