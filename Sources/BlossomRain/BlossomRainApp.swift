//
//  Blossom_RainApp.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

@MainActor
@main
struct BlossomRainApp: App {
    @State private var brState = BRState()
    @State private var recipeLibrary = RecipeLibrary()
    #if os(iOS)
    // App-level scenePhase reflects all scenes before changing this process-wide setting.
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("disableIdleTimer") private var disableIdleTimer = true
    #endif

    var body: some Scene {
        #if os(macOS)
        Window("Blossom Rain", id: "recipes") {
            ContentView()
                .environment(brState)
                .environment(recipeLibrary)
                .frame(minWidth: 520, minHeight: 580)
        }
        .defaultSize(width: 640, height: 820)
        .windowResizability(.contentMinSize)

        Settings {
            SettingsTab()
                .environment(brState)
                .environment(recipeLibrary)
                .frame(width: 520, height: 680)
        }
        #else
        WindowGroup {
            ContentView()
                .environment(brState)
                .environment(recipeLibrary)
                .onChange(of: scenePhase, initial: true) { updateScreenIdleTimer() }
                .onChange(of: disableIdleTimer) { updateScreenIdleTimer() }
        }
        #endif
    }

    #if os(iOS)
    private func updateScreenIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = disableIdleTimer && scenePhase == .active
    }
    #endif
}
