//
//  DeepDishAppClip.swift
//  DeepDishAppClip
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishCore
import SwiftUI

@main
struct DeepDishAppClipApp: App {
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settingsController)
                .environment(scheduleController)
        }
    }
}
