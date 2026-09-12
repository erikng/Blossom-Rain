import Foundation

@main
struct RecipeFeatureChecks {
    static func main() throws {
        var failures = 0
        func check(_ condition: Bool, _ message: String) {
            if !condition {
                failures += 1
                print("FAIL: \(message)")
            }
        }

        check(!lightAndBrightEspresso.description.isEmpty &&
              lightAndBrightEspresso.description == lightAndBright.description,
              "Light & Bright Espresso must retain its parent description and creator credit")
        check(!simpleAndSweetEspresso.description.isEmpty &&
              simpleAndSweetEspresso.description == simpleAndSweet.description,
              "Simple & Sweet Espresso must retain its parent description and creator credit")

        var sliderDraft = CustomRecipeDraft()
        let sliderSamples: [(input: Double, expected: Double)] = [
            (83.2507610, 83), (78.4818202, 78), (40.5, 41),
            (0, 0), (0.499999, 0), (149.999999, 150), (150, 150),
            (-0.1, 0), (150.1, 150)
        ]
        for mineral in RecipeMineral.allCases {
            for sample in sliderSamples {
                sliderDraft.setSliderValue(sample.input, for: mineral)
                check(sliderDraft.value(for: mineral) == sample.expected,
                      "\(mineral.name) slider must write \(sample.expected) ppm for \(sample.input)")
            }
            sliderDraft[mineral] = "40.25"
            check(sliderDraft.value(for: mineral) == 40.25,
                  "Typing a decimal must remain independent of slider snapping")
            for invalid in [Double.nan, Double.infinity, -Double.infinity] {
                sliderDraft.setSliderValue(invalid, for: mineral)
                check(sliderDraft.value(for: mineral) == 40.25,
                      "A non-finite slider value must not replace a valid target")
            }
        }

        let suite = "BlossomRain.RecipeChecks.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set("rao_perger", forKey: "defaultRecipe")
        let library = RecipeLibrary(defaults: defaults)
        check(library.currentRecipe?.name == "Rao's Recipe", "Legacy default recipe must survive")
        library.select(RecipeLibrary.customSelectionID)
        check(library.currentRecipe?.calciumPartsPerMillion == 60 &&
              library.currentRecipe?.magnesiumPartsPerMillion == 30 &&
              library.currentRecipe?.potassiumPartsPerMillion == 25 &&
              library.currentRecipe?.sodiumPartsPerMillion == 15,
              "Custom editor must start with the website's input values")
        library.draft.name = "  Morning coffee  "
        library.draft[.calcium] = "40.2"
        library.draft[.magnesium] = "32.1"
        library.draft[.potassium] = "8"
        library.draft[.sodium] = "12.1"
        check(abs((library.currentRecipe?.hardness ?? -1) - 72.3) < 1e-9 &&
              library.currentRecipe?.alkalinity == 20.1,
              "Chart must respond to decimal custom targets")
        try library.saveDraft()
        let savedID = library.selectedID
        let original = library.savedRecipes[0]
        check(original.name == "Morning coffee", "Saved names must be trimmed")
        library.setDefault(savedID)
        let restored = RecipeLibrary(defaults: UserDefaults(suiteName: suite)!)
        check(restored.currentRecipe == original, "Saved custom recipe and default must survive reload")
        restored.editSelectedRecipe()
        restored.draft[.calcium] = "80"
        check(restored.currentRecipe?.calciumPartsPerMillion == 80, "Editing must update the preview")
        check(RecipeLibrary(defaults: defaults).currentRecipe == original,
              "Unsaved edits must not change the persisted recipe")
        restored.cancelEditing()
        check(restored.currentRecipe == original, "Cancel must restore the saved recipe")
        restored.editSelectedRecipe()
        restored.draft.name = "Updated morning coffee"
        restored.draft[.calcium] = "80"
        try restored.saveDraft()
        check(restored.savedRecipes.count == 1 && restored.selectedID == savedID,
              "Updating a saved recipe must preserve its identity and default")
        check(RecipeLibrary(defaults: defaults).currentRecipe?.calciumPartsPerMillion == 80,
              "Updated targets must survive reload")

        restored.select(RecipeLibrary.customSelectionID)
        restored.draft.name = "Updated morning coffee"
        do {
            try restored.saveDraft()
            check(false, "Duplicate names must not overwrite saved recipes")
        } catch {}
        restored.draft.name = "Another recipe"
        for invalid in ["", "-1", "151", "nan", "inf", "1e309", "abc"] {
            restored.draft[.calcium] = invalid
            check(restored.currentRecipe == nil, "Invalid target \(invalid) must not show stale results")
            do {
                try restored.saveDraft()
                check(false, "Invalid target \(invalid) must not be saved")
            } catch {}
        }
        restored.draft[.calcium] = "40,2"
        check(restored.draft.value(for: .calcium, locale: Locale(identifier: "fr_FR")) == 40.2,
              "Decimal input must respect the user's locale")
        restored.draft[.calcium] = "0"
        restored.draft.name = "  "
        do {
            try restored.saveDraft()
            check(false, "Blank recipe names must not be saved")
        } catch {}
        restored.draft.name = "Another recipe"
        restored.draft.setSliderValue(83.2507610, for: .potassium)
        restored.draft.setSliderValue(78.4818202, for: .sodium)
        try restored.saveDraft()
        check(restored.savedRecipes.count == 2, "Users must be able to save multiple custom recipes")
        let savedSliderRecipe = RecipeLibrary(defaults: defaults).savedRecipes.first { $0.name == "Another recipe" }
        check(savedSliderRecipe?.potassiumPartsPerMillion == 83 &&
              savedSliderRecipe?.sodiumPartsPerMillion == 78,
              "Slider targets must remain whole numbers after saving and loading")
        try restored.deleteRecipe(original.id)
        let afterDelete = RecipeLibrary(defaults: defaults)
        check(afterDelete.savedRecipes.count == 1 &&
              afterDelete.defaultID == Recipes.light_and_bright.rawValue,
              "Deleting the default custom recipe must repair the saved default")

        let unreadable = Data("not valid JSON".utf8)
        defaults.set(unreadable, forKey: RecipeLibrary.storageKey)
        let damaged = RecipeLibrary(defaults: defaults)
        check(damaged.loadError != nil, "Unreadable saved data must be reported")
        damaged.select(RecipeLibrary.customSelectionID)
        damaged.draft.name = "Do not overwrite"
        do {
            try damaged.saveDraft()
            check(false, "A failed load must not allow overwriting saved data")
        } catch {}
        check(defaults.data(forKey: RecipeLibrary.storageKey) == unreadable,
              "Unreadable saved data must remain intact")

        var zero = CustomRecipeDraft()
        for mineral in RecipeMineral.allCases { zero[mineral] = "0" }
        check(zero.recipe?.ions.allSatisfy { $0.partsPerMillion == 0 } == true,
              "Zero-mineral water must show zero ion concentrations")
        check(zero.recipe?.alkalinityAxisMaximum == 100 && zero.recipe?.hardnessAxisMaximum == 160,
              "Zero values must retain readable chart scales")
        for mineral in RecipeMineral.allCases { zero[mineral] = "150" }
        check(zero.recipe?.alkalinityAxisMaximum == 360 && zero.recipe?.hardnessAxisMaximum == 360,
              "Chart must expand to include high custom targets")
        print("Recipe checks: \(failures) failures")
        exit(failures == 0 ? 0 : 1)
    }
}
