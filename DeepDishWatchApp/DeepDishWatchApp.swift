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
            }
            .environment(settingsController)
        }
    }
}
