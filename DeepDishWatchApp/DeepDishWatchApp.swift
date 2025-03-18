//
//  DeepDishWatchApp.swift
//  DeepDishWatchApp
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import DeepDishCore
import SwiftUI

@main
struct DeepDishWatchApp: App {
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()

    var body: some Scene {
        WindowGroup {
            ScheduleView()
                .environment(settingsController)
                .environment(scheduleController)
        }
    }
}
