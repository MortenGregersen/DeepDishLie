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
    @State private var giveawayController = GiveawayController()
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
            .task {
                if !Self.inDemoMode {
                    await scheduleController.fetchEvents()
                    await giveawayController.fetchWinners()
                }
            }
        }
    }
}
