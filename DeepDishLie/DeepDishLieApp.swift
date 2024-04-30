//
//  DeepDishLieApp.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

@main
struct DeepDishLieApp: App {
    @State private var scheduleController = ScheduleController()
    @State private var weatherController = WeatherController()
    @State private var giveawayController = GiveawayController()
    @Environment(\.scenePhase) private var scenePhase
    static let inDemoMode = UserDefaults.standard.bool(forKey: "Demo")

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
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active {
                    Task {
                        await scheduleController.fetchEvents()
                        await weatherController.fetchWeather()
                        await giveawayController.fetchGiveawayInfo()
                    }
                }
            }
        }
    }
}
