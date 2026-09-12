import Foundation
import Observation

@MainActor
@Observable
final class RecipeLibrary {
    static let storageKey = "customRecipes.v1"
    static let customSelectionID = "custom"

    private(set) var savedRecipes: [Recipe] = []
    private(set) var selectedID = Recipes.light_and_bright.rawValue
    private(set) var defaultID = Recipes.light_and_bright.rawValue
    private(set) var editingRecipeID: UUID?
    private(set) var loadError: String?
    var draft = CustomRecipeDraft()

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private var previousSelectionID = Recipes.light_and_bright.rawValue

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.storageKey) {
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                guard Set(recipes.map(\.id)).count == recipes.count,
                      recipes.allSatisfy({ CustomRecipeDraft(recipe: $0).recipe != nil &&
                          !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
                    throw LibraryError.invalidSavedData
                }
                savedRecipes = recipes
            } catch {
                loadError = "Saved recipes could not be read. Your stored data has been kept intact."
            }
        }
        let storedDefault = defaults.string(forKey: "defaultRecipe") ?? defaultID
        if isSavedSelection(storedDefault) { defaultID = storedDefault }
        selectedID = defaultID
    }

    static func selectionID(for recipe: Recipe) -> String { "saved:\(recipe.id.uuidString)" }

    var currentRecipe: Recipe? {
        if selectedID == Self.customSelectionID { return draft.recipe }
        return Recipes(rawValue: selectedID)?.selectedRecipe ?? selectedSavedRecipe
    }

    var selectedSavedRecipe: Recipe? {
        savedRecipes.first { Self.selectionID(for: $0) == selectedID }
    }

    var canSaveDraft: Bool {
        loadError == nil && draft.recipe != nil &&
            !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func select(_ id: String) {
        if id == Self.customSelectionID {
            guard selectedID != id else { return }
            previousSelectionID = selectedID
            editingRecipeID = nil
            draft = CustomRecipeDraft()
            selectedID = id
        } else if isSavedSelection(id) {
            editingRecipeID = nil
            selectedID = id
        }
    }

    func editSelectedRecipe() {
        guard let recipe = selectedSavedRecipe else { return }
        previousSelectionID = selectedID
        editingRecipeID = recipe.id
        draft = CustomRecipeDraft(recipe: recipe)
        selectedID = Self.customSelectionID
    }

    func cancelEditing() {
        selectedID = isSavedSelection(previousSelectionID) ? previousSelectionID : defaultID
        editingRecipeID = nil
    }

    func saveDraft() throws {
        guard selectedID == Self.customSelectionID, canSaveDraft, let recipe = draft.recipe else {
            throw LibraryError.invalidDraft
        }
        guard !savedRecipes.contains(where: {
            $0.id != editingRecipeID && $0.name.localizedCaseInsensitiveCompare(recipe.name) == .orderedSame
        }) else {
            throw LibraryError.duplicateName
        }
        var updated = savedRecipes
        if let id = editingRecipeID {
            guard let index = updated.firstIndex(where: { $0.id == id }) else {
                throw LibraryError.missingRecipe
            }
            updated[index] = recipe
        } else {
            updated.append(recipe)
        }
        try persist(updated)
        selectedID = Self.selectionID(for: recipe)
        editingRecipeID = nil
    }

    func setDefault(_ id: String) {
        guard isSavedSelection(id) else { return }
        defaults.set(id, forKey: "defaultRecipe")
        defaultID = id
        select(id)
    }

    func deleteRecipe(_ id: UUID) throws {
        guard let recipe = savedRecipes.first(where: { $0.id == id }) else { return }
        let selection = Self.selectionID(for: recipe)
        try persist(savedRecipes.filter { $0.id != id })
        if defaultID == selection {
            defaultID = Recipes.light_and_bright.rawValue
            defaults.set(defaultID, forKey: "defaultRecipe")
        }
        if selectedID == selection || editingRecipeID == id {
            selectedID = defaultID
            editingRecipeID = nil
        }
    }

    private func isSavedSelection(_ id: String) -> Bool {
        Recipes(rawValue: id) != nil || savedRecipes.contains { Self.selectionID(for: $0) == id }
    }

    private func persist(_ recipes: [Recipe]) throws {
        guard loadError == nil else { throw LibraryError.invalidSavedData }
        let data = try JSONEncoder().encode(recipes)
        defaults.set(data, forKey: Self.storageKey)
        savedRecipes = recipes
    }

    private enum LibraryError: LocalizedError {
        case invalidDraft, duplicateName, missingRecipe, invalidSavedData

        var errorDescription: String? {
            switch self {
            case .invalidDraft: return "Enter a recipe name and a number from 0 to 150 for each mineral."
            case .duplicateName: return "A saved recipe already has that name. Choose a different name."
            case .missingRecipe: return "This recipe is no longer available to update."
            case .invalidSavedData: return "Saved recipes could not be read. Your stored data has been kept intact."
            }
        }
    }
}
