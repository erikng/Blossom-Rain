import Foundation

@main
struct BrewStateChecks {
    @MainActor
    static func main() {
        var failures = 0
        func check(_ condition: Bool, _ message: String) {
            if !condition {
                failures += 1
                print("FAIL: \(message)")
            }
        }

        let suite = "BlossomRain.BrewStateChecks.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let first = BRState(defaults: defaults)
        let second = BRState(defaults: defaults)
        first.unit = .liter
        first.unitVolume = 3
        second.unit = .milliliter
        second.unitVolume = 750
        first.unit = .gallon
        check(first.unitVolume == 1, "Changing units must reset volume in the owning session")
        check(second.unit == .milliliter && second.unitVolume == 750,
              "Changing one session must not change another session")
        first.unit = .milliliter
        check(first.unitVolume == 450, "Switching back to milliliters must restore its initial volume")

        defaults.set("liter", forKey: "defaultUnit")
        defaults.set(true, forKey: "useManualVolumeInput")
        let manual = BRState(defaults: defaults, locale: Locale(identifier: "fr_FR"))
        check(manual.unit == .liter && manual.usesManualInput && manual.volume == 1,
              "Manual input must launch with the stored unit's default volume")
        manual.unitVolumeString = " 1,5 "
        check(manual.volume == 1.5, "Manual volume must accept a localized decimal separator")
        manual.setManualInput(true)
        check(manual.volume == 1.5, "Reapplying a preference must preserve the current input")
        for invalid in ["", "abc", "-1", "nan", "inf", "1e309"] {
            manual.unitVolumeString = invalid
            check(manual.volume == nil, "Invalid volume \(invalid) must not produce misleading drops")
        }
        manual.unitVolumeString = "0"
        check(manual.volume == 0, "Zero is a valid volume")
        manual.unit = .gallon
        check(manual.volume == 1, "Changing units must populate the new unit's default volume")
        manual.setManualInput(false)
        check(manual.unit == .gallon && manual.volume == 1,
              "Returning to the slider must keep the selected unit and restore a valid volume")
        manual.unitVolume = .infinity
        check(manual.volume == nil, "Non-finite slider values must not reach drop calculations")
        defaults.set("unknown-unit", forKey: "defaultUnit")
        defaults.set(false, forKey: "useManualVolumeInput")
        check(BRState(defaults: defaults).volume == 450,
              "An unknown stored unit must fall back to the milliliter default")

        for invalid in [-1, Double.nan, .infinity, -.infinity, Double.greatestFiniteMagnitude] {
            check(RecipeCalculator.drops(for: lightAndBright, volume: invalid,
                  unit: .gallon, droppers: DropperConfiguration()) == nil,
                  "Invalid or overflowing batch volume must be rejected without trapping")
        }
        check(RecipeCalculator.drops(for: lightAndBright, volume: 0,
              unit: .liter, droppers: DropperConfiguration())?.map(\.count) == [0, 0, 0, 0],
              "Zero volume must produce four zero drop counts")
        for mineral in RecipeMineral.allCases {
            for invalid in [-1, Double.nan, .infinity] {
                check(RecipeCalculator.dropCount(partsPerMillion: invalid, mineral: mineral,
                      volume: 450, unit: .milliliter, roundTipped: true) == nil,
                      "Invalid mineral targets must not produce drop counts")
            }
        }

        let initialVolumes: [(unit: Units, volume: Double)] = [
            (.milliliter, 450), (.liter, 1), (.gallon, 1)
        ]
        for localeID in ["en_US", "fr_FR", "ar_SA"] {
            for manualInput in [false, true] {
                defaults.set(manualInput, forKey: "useManualVolumeInput")
                for sample in initialVolumes {
                    defaults.set(sample.unit.rawValue, forKey: "defaultUnit")
                    let launched = BRState(defaults: defaults, locale: Locale(identifier: localeID))
                    check(launched.unit == sample.unit && launched.volume == sample.volume,
                          "Launch must supply \(sample.volume) \(sample.unit), manual=\(manualInput), locale=\(localeID)")
                    launched.setManualInput(!manualInput)
                    check(launched.volume == sample.volume,
                          "Changing input mode must supply \(sample.volume) \(sample.unit), locale=\(localeID)")
                }

                // The last launch preference is gallon, so each assignment changes units.
                let switching = BRState(defaults: defaults, locale: Locale(identifier: localeID))
                for sample in initialVolumes {
                    switching.unitVolume = 7
                    switching.unitVolumeString = "7"
                    switching.unit = sample.unit
                    check(switching.volume == sample.volume,
                          "Switching units must supply \(sample.volume) \(sample.unit), manual=\(manualInput), locale=\(localeID)")
                }
            }
        }

        print("Brew state checks: \(failures) failures")
        exit(failures == 0 ? 0 : 1)
    }
}
