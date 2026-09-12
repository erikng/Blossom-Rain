import Charts
import SwiftUI

struct RecipeAnalysisView: View {
    let recipe: Recipe

    var body: some View {
        Section {
            LabeledContent("Alkalinity", value: "\(recipe.alkalinity.formatted(.number.precision(.fractionLength(0...1)))) ppm")
            LabeledContent("Hardness", value: "\(recipe.hardness.formatted(.number.precision(.fractionLength(0...1)))) ppm")

            Chart {
                PointMark(
                    x: .value("Alkalinity", recipe.alkalinity),
                    y: .value("Hardness", recipe.hardness)
                )
                .symbolSize(100)
                .accessibilityLabel(recipe.name)
                .accessibilityValue("Alkalinity \(recipe.alkalinity.formatted()) ppm, hardness \(recipe.hardness.formatted()) ppm as CaCO₃")
            }
            .chartXScale(domain: 0...recipe.alkalinityAxisMaximum)
            .chartYScale(domain: 0...recipe.hardnessAxisMaximum)
            .chartXAxis { AxisMarks(values: .stride(by: 20)) }
            .chartYAxis { AxisMarks(position: .leading, values: .stride(by: 20)) }
            .chartXAxisLabel("Alkalinity (ppm as CaCO₃)")
            .chartYAxisLabel(position: .leading, alignment: .center) {
                // Charts rotates leading labels clockwise; reverse only the title to read upward.
                Text("Hardness (ppm as CaCO₃)")
                    .rotationEffect(.degrees(180))
            }
            .frame(height: 240)
            .padding(.vertical, 8)
            .accessibilityIdentifier("waterProfileChart")
        } header: {
            Text("Water Profile")
        } footer: {
            Text("Target hardness and alkalinity, expressed as ppm as CaCO₃.")
        }

        Section {
            ForEach(recipe.ions) { ion in
                HStack {
                    Text(LocalizedStringKey(ion.name))
                    Text(ion.symbol).foregroundStyle(.secondary)
                    Spacer()
                    Text("\(ion.partsPerMillion) ppm").monospacedDigit()
                }
                .accessibilityElement(children: .combine)
                .accessibilityIdentifier("ion-\(ion.id)")
            }
        } header: {
            Text("Ion Concentrations")
        } footer: {
            Text("Target ion concentrations before rounding drops. Batch size and dropper style change the drop counts, not this profile.")
        }
    }
}
