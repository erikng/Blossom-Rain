import SwiftUI

/// Observes volume independently so dragging a slider need not rebuild the chart.
struct RecipeVolumeSection: View {
    @Environment(BRState.self) private var brState
    @AppStorage("volumeInputStepper") private var volumeInputStepper = 25.0
    @FocusState.Binding var focusedField: RecipeInputField?

    var body: some View {
        @Bindable var brState = brState
        let unit = brState.unit.selectedUnit

        Section("Volume") {
            Picker("Unit", selection: $brState.unit) {
                ForEach(Units.allCases) { unit in
                    Text(LocalizedStringKey(unit.selectedUnit.name)).tag(unit)
                }
            }
            .accessibilityIdentifier("volumeUnitPicker")

            if brState.usesManualInput {
                TextField(LocalizedStringKey(unit.inputPrompt), text: $brState.unitVolumeString)
                    .decimalInputKeyboard()
                    .focused($focusedField, equals: .volume)
                    .accessibilityIdentifier("manualVolumeInput")
            } else {
                HStack {
                    let storedStep = [1.0, 5.0, 10.0, 20.0, 25.0].contains(volumeInputStepper) ? volumeInputStepper : 25
                    let stepSize = brState.unit == .milliliter ? storedStep : unit.initialStep
                    let shouldOmitStep = brState.unit == .milliliter && [1.0, 5.0, 10.0].contains(storedStep)
                    let binding = Binding<Double>(
                        get: { brState.unitVolume },
                        set: { brState.unitVolume = ($0 / stepSize).rounded() * stepSize }
                    )

                    if shouldOmitStep {
                        Slider(value: binding, in: 0...unit.maximumVolume)
                            .accessibilityLabel("Volume")
                    } else {
                        Slider(value: binding, in: 0...unit.maximumVolume, step: stepSize)
                            .accessibilityLabel("Volume")
                    }
                    Text(brState.unitVolume, format: .number.precision(.fractionLength(0)))
                        .monospacedDigit()
                        .accessibilityIdentifier("volumeReadout")
                }
            }
        }
    }
}
