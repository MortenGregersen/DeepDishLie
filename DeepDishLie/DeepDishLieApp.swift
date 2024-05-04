//
//  DeepDishLieApp.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI
import TelemetryClient

@main
struct DeepDishLieApp: App {
    @State private var welcomeController = WelcomeController()
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()
    @State private var weatherController = WeatherController()
    @State private var giveawayController = GiveawayController()
    @Environment(\.scenePhase) private var scenePhase
    static let inDemoMode = UserDefaults.standard.bool(forKey: "Demo")

    init() {
        if !Self.inDemoMode {
            TelemetryManager.initialize(with: .init(appID: "5DD04C64-E9D4-4FB0-AAD6-A48330771CBF"))
        }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ScheduleView()
                    .environment(scheduleController)
                    .tabItem {
                        Label("Schedule", systemImage: "person.2.wave.2")
                    }
                WeatherView()
                    .environment(weatherController)
                    .tabItem {
                        Label("Wu with the Weather", systemImage: "thermometer.sun")
                    }
                GiveawayView()
                    .environment(giveawayController)
                    .tabItem {
                        Label("Giveaway", systemImage: "app.gift")
                    }
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "text.badge.star")
                    }
            }
            .environment(welcomeController)
            .environment(settingsController)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    if !Self.inDemoMode {
                        TelemetryManager.send("confettiStatus", floatValue: settingsController.randomConfettiIntensity)
                    }
                    Task {
                        await scheduleController.fetchEvents()
                        await weatherController.fetchWeather()
                        await giveawayController.fetchGiveawayInfo()
                    }
                }
            }
            .onAppear {
                if !welcomeController.hasSeenWelcome || DeepDishLieApp.inDemoMode {
                    welcomeController.showsWelcome = true
                }
            }
            .overlay {
                if welcomeController.showsWelcome {
                    WelcomeView()
                        .environment(welcomeController)
                        .environment(settingsController)
                }
            }
        }
    }
}
