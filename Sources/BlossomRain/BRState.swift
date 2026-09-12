import Foundation
import Observation

/// Transient brewing input, owned by the app rather than a mutable global.
@MainActor
@Observable
final class BRState {
    var unit: Units {
        didSet {
            if unit != oldValue { resetVolume() }
        }
    }
    var unitVolume = 450.0
    var unitVolumeString = "450"
    private(set) var usesManualInput: Bool
    @ObservationIgnored private let locale: Locale

    init(defaults: UserDefaults = .standard, locale: Locale = .current) {
        unit = defaults.string(forKey: "defaultUnit").flatMap(Units.init(rawValue:)) ?? .milliliter
        usesManualInput = defaults.bool(forKey: "useManualVolumeInput")
        self.locale = locale
        resetVolume()
    }

    /// Invalid input stays visible for editing but never reaches integer drop conversion.
    var volume: Double? {
        let value: Double?
        if usesManualInput {
            let text = unitVolumeString.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: locale.decimalSeparator ?? ".", with: ".")
            value = Double(text)
        } else {
            value = unitVolume
        }
        guard let value, value.isFinite, value >= 0 else { return nil }
        return value
    }

    func setManualInput(_ enabled: Bool) {
        guard enabled != usesManualInput else { return }
        usesManualInput = enabled
        resetVolume()
    }

    private func resetVolume() {
        unitVolume = unit.selectedUnit.initialVolume
        // Defaults are whole volumes; keep their editable text parseable in every locale.
        unitVolumeString = String(Int(unitVolume))
    }
}
