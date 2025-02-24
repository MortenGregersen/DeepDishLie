//
//  EventEntry.swift
//  DeepDishWidget
//
//  Created by Morten Bjerg Gregersen on 17/02/2025.
//

import DeepDishCore
import WidgetKit

extension ScheduleWidget {
    struct Entry: TimelineEntry {
        let date: Date
        let widgetFamily: WidgetFamily
        let mode: Mode

        enum Mode {
            case countdown(until: Date)
            case currentNext(currentEvent: Event?, nextEvents: [Event])
            case ended
        }
    }
}
