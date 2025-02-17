//
//  ScheduleWidget+Provider.swift
//  ScheduleWidgetExtension
//
//  Created by Morten Bjerg Gregersen on 17/02/2025.
//

import DeepDishCore
import WidgetKit

extension ScheduleWidget {
    struct Provider: TimelineProvider {
        private let scheduleController = ScheduleController()
        private var allEvents: [Event] {
            scheduleController.days
                .flatMap(\.events)
                .sorted { $0.start < $1.start }
        }

        func placeholder(in context: Context) -> ScheduleWidget.Entry {
            .init(date: Date(), widgetFamily: context.family, mode: .ended)
        }

        func getSnapshot(in context: Context, completion: @escaping (ScheduleWidget.Entry) -> ()) {
            let openingKeynoteEventIndex = allEvents.firstIndex(where: { $0.id == "special-opening-keynote" })!
            let openingKeynoteEvent = allEvents[openingKeynoteEventIndex]
            let eventBeforeOpeningKeynote = allEvents[allEvents.index(before: openingKeynoteEventIndex)]
            let entry = ScheduleWidget.Entry(date: Date(), widgetFamily: context.family, mode: .currentNext(current: eventBeforeOpeningKeynote, next: openingKeynoteEvent))
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleWidget.Entry>) -> ()) {
            var entries: [ScheduleWidget.Entry] = []
            let currentDate = Date()

            let upcomingEvents = allEvents
                .filter { $0.start > currentDate }

            for event in upcomingEvents {
                let currentEventIndex = allEvents.firstIndex(where: { $0 == event })!
                let previousEventIndex = allEvents.index(before: currentEventIndex)
                let entry: ScheduleWidget.Entry
                if previousEventIndex > 0 {
                    let previousEvent = allEvents[previousEventIndex]
                    entry = ScheduleWidget.Entry(date: event.start, widgetFamily: context.family, mode: .currentNext(current: previousEvent, next: event))
                } else {
                    entry = ScheduleWidget.Entry(date: event.start, widgetFamily: context.family, mode: .countdown(until: event.start))
                }
                entries.append(entry)
            }
            entries.append(.init(date: allEvents.last!.end, widgetFamily: context.family, mode: .ended))

            let timeline: Timeline<ScheduleWidget.Entry>
            if let lastEntryDate = entries.last?.date {
                timeline = Timeline(entries: entries, policy: .after(lastEntryDate))
            } else {
                let reloadDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
                timeline = Timeline(entries: entries, policy: .after(reloadDate))
            }

            completion(timeline)
        }
    }
}
