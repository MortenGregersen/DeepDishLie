//
//  DeepDishApp.swift
//  DeepDishApp
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import DeepDishAppCore
import DeepDishCore
import SwiftUI
import TelemetryDeck

@main
struct DeepDishApp: App {
    @State private var welcomeController = WelcomeController(inDemoMode: AppEnvironment.inDemoMode)
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()
    @State private var weatherController = WeatherController()
    @State private var giveawayController = GiveawayController()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        if !AppEnvironment.inDemoMode {
            TelemetryDeck.initialize(config: .init(appID: "5DD04C64-E9D4-4FB0-AAD6-A48330771CBF"))
        }
    }

    var body: some Scene {
        WindowGroup {
            ConfettiEnabledView {
                TabView {
                    if !AppEnvironment.inDemoMode, let firstEventDate = scheduleController.firstEventDate, Date.now < firstEventDate {
                        CountdownView(eventDate: firstEventDate)
                        #if !os(macOS)
                            .toolbarBackground(.visible, for: .tabBar)
                        #endif
                            .tabItem {
                                Label("Countdown", systemImage: "timer")
                            }
                    }
                    ScheduleView()
                        .environment(scheduleController)
                        .tabItem {
                            Label("Schedule", systemImage: "person.2.wave.2")
                        }
                    WeatherView()
                        .environment(weatherController)
                        .tabItem {
                            Label("Weather", systemImage: "thermometer.sun")
                        }
//                    GiveawayView()
//                        .environment(giveawayController)
//                        .tabItem {
//                            Label("Giveaway", systemImage: "app.gift")
//                        }
                    AboutView()
                        .environment(scheduleController)
                        .tabItem {
                            Label("About", systemImage: "text.badge.star")
                        }
                }
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .active {
                        if !AppEnvironment.inDemoMode {
                            TelemetryDeck.signal("confettiStatus", floatValue: settingsController.randomConfettiIntensity)
                        }
                        Task {
                            await scheduleController.fetchEvents()
                            await weatherController.fetchWeather()
                            await giveawayController.fetchGiveawayInfo()
                        }
                    }
                }
                #if os(macOS)
                .sheet(isPresented: $welcomeController.showsWelcome) {
                    WelcomeView()
                        .frame(minHeight: 570)
                        .environment(welcomeController)
                        .environment(settingsController)
                }
                #else
                .fullScreenCover(isPresented: $welcomeController.showsWelcome) {
                            WelcomeView()
                                .environment(welcomeController)
                                .environment(settingsController)
                        }
                #endif
            }
            .environment(welcomeController)
            .environment(settingsController)
            .ifOS(.macOS) { $0.frame(minWidth: 600, idealWidth: 700, maxWidth: .infinity, minHeight: 720, idealHeight: 900, maxHeight: .infinity) }
        }
        #if os(macOS)
        Settings {
            SettingsView()
                .environment(settingsController)
        }
        .defaultSize(width: 400, height: 350)
        #endif
    }
}
