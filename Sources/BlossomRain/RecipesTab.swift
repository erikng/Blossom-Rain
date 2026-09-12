//
//  RecipesTab.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/7/23.
//

import SwiftUI

enum RecipeInputField: Hashable {
    case name
    case description
    case mineral(RecipeMineral)
    case volume
}

struct RecipesTab: View {
    @Environment(RecipeLibrary.self) private var library
    @FocusState private var focusedField: RecipeInputField?
    @State private var recipeToDelete: Recipe?
    @State private var errorMessage: String?
    @State private var errorTitle: LocalizedStringKey = "Could Not Delete Recipe"
    
    var body: some View {
        @Bindable var library = library
        let recipe = library.currentRecipe
        NavigationStack {
            Form {
                Section {
                    Picker("Recipes", selection: Binding(
                        get: { library.selectedID },
                        set: { library.select($0) }
                    )) {
                        RecipePickerOptions()
                    }
                    .accessibilityIdentifier("recipePicker")
                }

                if let message = library.loadError {
                    Section { Text(message).foregroundStyle(.red) }
                }
                if library.selectedID == RecipeLibrary.customSelectionID {
                    CustomRecipeEditor(focusedField: $focusedField)
                }

                RecipeVolumeSection(focusedField: $focusedField)

                if let recipe {
                    RecipeDropsSection(recipe: recipe)
                    RecipeAnalysisView(recipe: recipe)
                }

                // Keep naming and notes beside the final actions, even with invalid mineral input.
                Section {
                    if library.selectedID == RecipeLibrary.customSelectionID {
                        TextField("Recipe name", text: $library.draft.name)
                            .focused($focusedField, equals: .name)
                            .submitLabel(.next)
                            .accessibilityIdentifier("customRecipeName")

                        TextField("Recipe description (optional)", text: $library.draft.description, axis: .vertical)
                            .lineLimit(3...6)
                            .focused($focusedField, equals: .description)
                            .submitLabel(.return)
                            .submitScope()
                            .accessibilityIdentifier("customRecipeDescription")
                    } else if let recipe, !recipe.description.isEmpty {
                        if library.selectedSavedRecipe != nil {
                            Text(verbatim: recipe.description)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        } else {
                            Text(LocalizedStringKey(recipe.description))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Recipe Information")
                } footer: {
                    if library.selectedID == RecipeLibrary.customSelectionID {
                        Text("Name your recipe to save it on this device.")
                    } else {
                        Text("Purchase these drops at [Lotus Coffee Products](https://lotuscoffeeproducts.com/collections/all)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                }

                // Keep actions last, including when invalid input hides the recipe preview.
                if library.selectedID == RecipeLibrary.customSelectionID {
                    Section {
                        VStack(spacing: 12) {
                            Button(action: saveCustomRecipe) {
                                Text(library.editingRecipeID == nil ? "Save Recipe" : "Save Changes")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .keyboardShortcut(.defaultAction)
                            .disabled(!library.canSaveDraft)
                            .accessibilityIdentifier("saveCustomRecipe")

                            Button("Cancel", role: .cancel) {
                                focusedField = nil
                                library.cancelEditing()
                            }
                            .buttonStyle(.borderless)
                            .keyboardShortcut(.cancelAction)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .accessibilityIdentifier("cancelCustomRecipe")
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Recipes")
            .inlineNavigationTitle()
            .onSubmit {
                if focusedField == .name {
                    focusedField = .description
                } else if focusedField != .description {
                    saveCustomRecipe()
                }
            }
            .toolbar {
                #if os(macOS)
                ToolbarItem {
                    SettingsLink {
                        Label("Settings", systemImage: "slider.horizontal.3")
                    }
                }
                #endif
                if let saved = library.selectedSavedRecipe {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button {
                                focusedField = nil
                                library.editSelectedRecipe()
                            } label: {
                                Label("Edit Recipe", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                focusedField = nil
                                recipeToDelete = saved
                            } label: {
                                Label("Delete Recipe", systemImage: "trash")
                            }
                        } label: {
                            Label("Recipe Actions", systemImage: "square.and.pencil")
                        }
                        .accessibilityHint("Edit or delete this saved recipe.")
                        .accessibilityIdentifier("savedRecipeActions")
                    }
                }
                #if os(iOS)
                // Own the keyboard toolbar here once; Section rows can duplicate it.
                if focusedField != nil {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { focusedField = nil }
                            .accessibilityIdentifier("dismissRecipeKeyboard")
                    }
                }
                #endif
            }
        }
        .alert("Delete \(recipeToDelete?.name ?? "recipe")?", isPresented: Binding(
            get: { recipeToDelete != nil },
            set: { if !$0 { recipeToDelete = nil } }
        ), presenting: recipeToDelete) { recipe in
            Button("Cancel", role: .cancel) { recipeToDelete = nil }
            Button("Delete Recipe", role: .destructive) {
                do { try library.deleteRecipe(recipe.id) }
                catch {
                    errorTitle = "Could Not Delete Recipe"
                    errorMessage = error.localizedDescription
                }
                recipeToDelete = nil
            }
        }
        .alert(errorTitle, isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        #if os(iOS)
        .scrollDismissesKeyboard(.immediately)
        .onTapGesture(count: focusedField == .volume ? 1 : .max, perform: {
            // Preserve tap-to-dismiss without intercepting editor controls.
            focusedField = nil
        })
        #endif
    }

    private func saveCustomRecipe() {
        guard library.selectedID == RecipeLibrary.customSelectionID, library.canSaveDraft else { return }
        focusedField = nil
        do { try library.saveDraft() }
        catch {
            errorTitle = "Could Not Save Recipe"
            errorMessage = error.localizedDescription
        }
    }

}
