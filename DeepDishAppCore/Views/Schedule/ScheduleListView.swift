//
//  ScheduleListView.swift
//  DeepDishAppCore
//
//  Created by Matt Heaney on 22/02/2025.
//

import DeepDishCore
import SwiftUI

public struct ScheduleListView: View {
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
                Text(day.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .listStyle(.plain)
    }
}
