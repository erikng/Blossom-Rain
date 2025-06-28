//
//  Blossom_RainApp.swift
//  Blossom Rain
//
//  Created by Erik Gomez on 11/4/23.
//

import Foundation
import OSLog
import SwiftUI

let logger: Logger = Logger(subsystem: "Skye-Design.Blossom-Rain", category: "Food & Drink")
/// The Android SDK number we are running against, or `nil` if not running on Android
let androidSDK = ProcessInfo.processInfo.environment["android.os.Build.VERSION.SDK_INT"].flatMap({ Int($0) })

class BRState: ObservableObject {
    @Published var calciumDropperTypeMultiplier = 1.0
    @Published var calciumPartsPerMillion = 1.0
    @Published var magnesiumDropperTypeMultiplier = 1.0
    @Published var magnesiumPartsPerMillion = 1.0
    @Published var numberZeroStringFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.zeroSymbol = ""
        return formatter
    }()
    @Published var potassiumDropperTypeMultiplier = 1.0
    @Published var potassiumPartsPerMillion = 1.0
    @Published var recipe: Recipes = .light_and_bright
    @Published var recipeDescription: String = lightAndBright.description
    @Published var sodiumDropperTypeMultiplier = 1.0
    @Published var sodiumPartsPerMillion = 1.0
    @Published var unit: Units = .milliliter
    @Published var unitText = ""
    @Published var unitVolume = 1.0
    @Published var unitVolumeString = "1.0"
}
var mainBRState = BRState()

public struct RootView : View {
    @StateObject private var brState: BRState = mainBRState
    
    public init() {
    }
    
    public var body: some View {
        ContentView()
            .environmentObject(brState)
            .task {
                logger.log("Running on \(androidSDK != nil ? "Android" : "Darwin")!")
            }
    }
}

#if !SKIP
public protocol BlossomRainApp : App {
}

public extension BlossomRainApp {
    var body: some Scene {
        WindowGroup {
            RootView()
            #if targetEnvironment(macCatalyst)
                .onReceive(NotificationCenter.default.publisher(for: UIScene.willConnectNotification)) { _ in
                    // prevent window in macOS from being resized down
                    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 800, height: 1000)
                        windowScene.sizeRestrictions?.maximumSize = CGSize(width: 800, height: 1000)
                        windowScene.sizeRestrictions?.allowsFullScreen = false
                    }
                }
            #endif
        }
    }
}
#endif

