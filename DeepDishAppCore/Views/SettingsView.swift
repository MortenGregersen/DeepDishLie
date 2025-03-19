//
//  SettingsView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import DeepDishCore
import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsController.self) private var settingsController

    public init() {}

    public var body: some View {
        @Bindable var settingsController = settingsController
        NavigationStack {
            Form {
                if OperatingSystem.current != .watchOS {
                    Section("General") {
                        Toggle(isOn: $settingsController.enableRandomConfetti) {
                            Label {
                                Text("Random pizza confetti")
                            } icon: {
                                Text("🍕")
                            }
                        }
                        if settingsController.enableRandomConfetti {
                            LabeledContent {
                                Slider(value: $settingsController.randomConfettiIntensity, in: 1 ... 5, step: 1)
                            } label: {
                                Label("Intensity", systemImage: "bubbles.and.sparkles")
                                    .padding(.trailing)
                            }
                        }
                    }
                }
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
                    if OperatingSystem.current != .watchOS {
                        Toggle(isOn: $settingsController.openLinksInApp) {
                            Label("Open social links in-app", systemImage: "link.circle")
                        }
                    }
                }
                Section("Weather") {
                    Picker(selection: $settingsController.temperatureScale) {
                        Text("Wrong (°F)")
                            .tag(TemperatureScale.fahrenheit)
                        Text("Right (°C)")
                            .tag(TemperatureScale.celsius)
                        Text("Weird (K)")
                            .tag(TemperatureScale.kelvin)
                    } label: {
                        Label("Temperature scale", systemImage: settingsController.temperatureScale.systemImage)
                    }
                }
            }
            .animation(.default, value: settingsController.enableRandomConfetti)
            .navigationTitle("Settings")
            #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.navigationBarBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            #endif
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
