//
//  Units.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import Foundation

struct UnitOfMeasurement: Sendable {
    let name: String
    let inputPrompt: String
    let initialStep: Double
    let initialVolume: Double
    let maximumVolume: Double
}

enum Units: String, CaseIterable, Identifiable, Sendable {
    case milliliter, liter, gallon
    var id: String { self.rawValue }
}

extension Units {
    var selectedUnit: UnitOfMeasurement {
        switch self {
        case .milliliter: return UnitOfMeasurement(
            name: "Milliliter",
            inputPrompt: "Enter your desired volume in milliliters",
            initialStep: 25.0,
            initialVolume: 450.0,
            maximumVolume: 1000.0
        )
        case .liter: return UnitOfMeasurement(
            name: "Liter",
            inputPrompt: "Enter your desired volume in liters",
            initialStep: 1.0,
            initialVolume: 1.0,
            maximumVolume: 20.0
        )
        case .gallon: return UnitOfMeasurement(
            name: "Gallon",
            inputPrompt: "Enter your desired volume in gallons",
            initialStep: 1.0,
            initialVolume: 1.0,
            maximumVolume: 5.0
        )
        }
    }
}
