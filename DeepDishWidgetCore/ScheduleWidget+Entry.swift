//
//  EventEntry.swift
//  DeepDishWidget
//
//  Created by Morten Bjerg Gregersen on 17/02/2025.
//

import DeepDishCore
import WidgetKit

public extension ScheduleWidget {
    struct Entry: TimelineEntry {
        public let date: Date
        public let widgetFamily: WidgetFamily
        public let mode: Mode

        public enum Mode {
            case countdown(until: Date)
            case currentNext(currentEvent: Event?, nextEvents: [Event])
            case ended
        }
    }
}
