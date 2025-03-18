//
//  DeepDishWatchApp.swift
//  DeepDishWatchApp
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import DeepDishAppCore
import DeepDishCore
import SwiftUI

@main
struct DeepDishWatchApp: App {
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()
    @State private var weatherController = WeatherController()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            TabView {
                if !AppEnvironment.inDemoMode, let firstEventDate = scheduleController.firstEventDate, Date.now < firstEventDate {
                    CountdownView(eventDate: firstEventDate)
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
            }
            .environment(settingsController)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    Task {
                        await scheduleController.fetchEvents()
                        await weatherController.fetchWeather()
                    }
                }
            }
        }
    }
}
