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
            let entry = ScheduleWidget.Entry(date: Date(), widgetFamily: context.family, mode: .currentNext(currentEvent: eventBeforeOpeningKeynote, nextEvents: [openingKeynoteEvent]))
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleWidget.Entry>) -> ()) {
            var entries: [ScheduleWidget.Entry] = []
            let currentDate = Date()

            let upcomingEvents = allEvents
                .filter { $0.start > currentDate }

            let speedRun = false
            var dummyDate = Date.now.addingTimeInterval(2)
            if Date.now < allEvents.first!.start {
                entries.append(.init(date: Date.now, widgetFamily: context.family, mode: .countdown(until: allEvents.first!.start)))
            }
            for event in upcomingEvents {
                let currentEventIndex = allEvents.firstIndex(where: { $0 == event })!
                let previousEventIndex = allEvents.index(before: currentEventIndex)
                let entry: ScheduleWidget.Entry
                let date = speedRun ? dummyDate : event.start
                var previousEvent: Event? = nil
                if previousEventIndex >= allEvents.startIndex {
                    previousEvent = allEvents[previousEventIndex]
                }
                var nextEvents = [event]
                let nextNextEventIndex = allEvents.index(after: currentEventIndex)
                if nextNextEventIndex < allEvents.endIndex {
                    nextEvents.append(allEvents[nextNextEventIndex])
                }
                let nextNextNextEventIndex = allEvents.index(after: nextNextEventIndex)
                if nextNextNextEventIndex < allEvents.endIndex {
                    nextEvents.append(allEvents[nextNextNextEventIndex])
                }
                entry = ScheduleWidget.Entry(date: date, widgetFamily: context.family, mode: .currentNext(currentEvent: previousEvent, nextEvents: nextEvents))
                entries.append(entry)
                dummyDate = dummyDate.addingTimeInterval(2)
            }
            let endDate = speedRun ? dummyDate : allEvents.last!.end
            entries.append(.init(date: endDate, widgetFamily: context.family, mode: .ended))

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
