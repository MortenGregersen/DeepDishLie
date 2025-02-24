//
//  ContentView.swift
//  DeepDishAppClip
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishCore
import SwiftUI

struct ContentView: View {
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()

    var body: some View {
        NavigationView {
            ScheduleListView()
                .navigationTitle("Deep Dish Swift 🍕")
                .toolbarBackground(Color.navigationBarBackground,
                                   for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .environment(settingsController)
        .environment(scheduleController)
    }
}

#Preview {
    ContentView()
}
