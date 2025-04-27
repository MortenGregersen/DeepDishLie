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
        @Bindable var scheduleController = scheduleController
        let dateFormatter = Event.dateFormatter(
            useLocalTimezone: settingsController.useLocalTimezone,
            use24hourClock: settingsController.use24hourClock)
        List(scheduleController.days, selection: $scheduleController.selectedEvent) { day in
            Section {
                ForEach(day.events) { event in
                    NavigationLink(value: event) {
                        EventRow(dayName: day.name, event: event, dateFormatter: dateFormatter)
                            .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 12))       
                    }
                    .listRowBackground(listRowBackgroundColor(event: event))
                }
            } header: {
                let text = Text(day.name)
                    .foregroundStyle(Color.accent)
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
        .navigationDestination(item: $scheduleController.selectedEvent) { event in
            EventView(dayName: scheduleController.dayName(for: event)!, event: event)
        }
    }
    
    private func listRowBackgroundColor(event: Event) -> Color? {
        guard event.isHappeningNow else {
            return switch event {
            case .session: nil
            default: Color.accent.opacity(0.1)
            }
        }
        return Color.accent
    }
}

#Preview {
    EventsListView()
        .environment(ScheduleController.forPreview())
        .environment(SettingsController.forPreview())
}
