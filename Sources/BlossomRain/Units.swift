//
//  Units.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import Foundation

struct UnitOfMeasurement: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var iOSText: String
    var initialStep: Double
    var initialVolume: Double
    var maxStep: Double
}

enum Units: String, CaseIterable, Identifiable {
    case milliliter, liter, gallon
    var id: String { self.rawValue }
}

extension Units {
    var selectedUnit: UnitOfMeasurement {
        switch self {
        case .milliliter: return UnitOfMeasurement(
            id: UUID(),
            name: "Milliliter",
            iOSText: "Enter your desired volume in milliliters",
            initialStep: 25.0,
            initialVolume: 450.0,
            maxStep: 1000.0
        )
        case .liter: return UnitOfMeasurement(
            id: UUID(),
            name: "Liter",
            iOSText: "Enter your desired volume in liters",
            initialStep: 1.0,
            initialVolume: 1.0,
            maxStep: 20.0
        )
        case .gallon: return UnitOfMeasurement(
            id: UUID(),
            name: "Gallon",
            iOSText: "Enter your desired volume in gallons",
            initialStep: 1.0,
            initialVolume: 1.0,
            maxStep: 5.0
        )
        }
    }
}

func updateUnits(selectedUnit: Units) {
    mainBRState.unitText = selectedUnit.selectedUnit.iOSText
    mainBRState.unitVolume = selectedUnit.selectedUnit.initialVolume
    mainBRState.unitVolumeString = String(Int(selectedUnit.selectedUnit.initialVolume))
}
