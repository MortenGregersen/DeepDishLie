//
//  EventsListView.swift
//  DeepDishAppCore
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishCore
import SwiftUI

public struct EventsListView: View {
    @Environment(ScheduleController.self) private var scheduleController
    @Environment(SettingsController.self) private var settingsController

    public init() {}

    public var body: some View {
        let dateFormatter = Event.dateFormatter(useLocalTimezone: settingsController.useLocalTimezone, use24hourClock: settingsController.use24hourClock)
        List(scheduleController.days) { day in
            Section {
                ForEach(day.events) { event in
                    EventRow(dayName: day.name, event: event, dateFormatter: dateFormatter)
                        .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 12))
                }
            } header: {
                let text = Text(day.name)
                    .foregroundStyle(Color.accentColor)
                if OperatingSystem.current == .watchOS {
                    text
                } else {
                    text
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    EventsListView()
        .environment(ScheduleController.forPreview())
        .environment(SettingsController.forPreview())
}
