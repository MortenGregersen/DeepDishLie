//
//  SettingsView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsController.self) private var settingsController

    var body: some View {
        @Bindable var settingsController = settingsController
        NavigationStack {
            Form {
                Section("Schedule") {
                    Toggle(isOn: $settingsController.useLocalTimezone) {
                        Label("Use local time zone", systemImage: "globe.europe.africa")
                    }
                    Picker(selection: $settingsController.use24hourClock) {
                        Text("Limited (1.37 PM)")
                            .tag(false)
                        Text("Beautiful (13.37)")
                            .tag(true)
                    } label: {
                        Label("Time format", systemImage: "clock.badge.checkmark")
                    }
                    Toggle(isOn: $settingsController.openLinksInApp) {
                        Label("Open social links in-app", systemImage: "link.circle")
                    }
                }
                Section("Weather") {
                    Picker(selection: $settingsController.useCelcius) {
                        Text("Wrong (°F)")
                            .tag(false)
                        Text("Right (°C)")
                            .tag(true)
                    } label: {
                        Label("Temperature scale", systemImage: settingsController.useCelcius ? "thermometer.low" : "thermometer.high")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(SettingsController.forPreview())
}
