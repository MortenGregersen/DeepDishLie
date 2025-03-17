//
//  ContentView.swift
//  DeepDishWatchApp
//
//  Created by Morten Bjerg Gregersen on 17/03/2025.
//

import DeepDishAppCore
import DeepDishCore
import SwiftUI

struct ContentView: View {
    @State private var settingsController = SettingsController()
    @State private var scheduleController = ScheduleController()

    var body: some View {
        NavigationView {
            ScheduleListView()
                .navigationTitle("Deep Dish")
                .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
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
