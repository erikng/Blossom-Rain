//
//  Units.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

struct Unit: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var iOSText: String
    var initialStep: Double
    var initialVolume: Double
    var macText: String
    var maxStep: Double
}

enum Units: String, CaseIterable, Identifiable {
    case milliliter, liter, gallon
    var id: Self { self }
}

extension Units {
    var selectedUnit: Unit {
        switch self {
        case .milliliter: return Unit(
            id: UUID(),
            name: "Milliliter",
            iOSText: "Enter your desired volume in milliliters",
            initialStep: 5.0,
            initialVolume: 450.0,
            macText: "Volume (ml)",
            maxStep: 1000.0
        )
        case .liter: return Unit(
            id: UUID(),
            name: "Liter",
            iOSText: "Enter your desired volume in liters",
            initialStep: 1.0,
            initialVolume: 1.0,
            macText: "Volume (l)",
            maxStep: 20.0
        )
        case .gallon: return Unit(
            id: UUID(),
            name: "Gallon",
            iOSText: "Enter your desired volume in gallons",
            initialStep: 1.0,
            initialVolume: 1.0,
            macText: "Volume (g)",
            maxStep: 5.0
        )
        }
    }
}

func updateUnits() {
    #if os(macOS)
    mainBRState.unitText = mainBRState.unit.selectedUnit.macText
    #else
    mainBRState.unitText = mainBRState.unit.selectedUnit.iOSText
    #endif
    if mainBRState.useManualVolumeInput {
        mainBRState.unitVolume = 0.0
    } else {
        mainBRState.unitVolume = mainBRState.unit.selectedUnit.initialVolume
    }
}
