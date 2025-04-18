//
//  ScheduleController.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 25/04/2024.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

@Observable
public class ScheduleController {
    public private(set) var days: [Day] = []
    public var firstEventDate: Date? { days.first?.events.first?.start }
    public var selectedEvent: Event?

    private static let cacheFolderUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.CoolYellowOwl.DeepDishLie")
    private static let cachedJsonUrl = cacheFolderUrl?.appending(component: "Schedule.json")
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    public init() {
        if let events = Self.loadCachedEvents() {
            self.days = chunkUpEvents(events)
        } else {
            let jsonData = try! Data(contentsOf: Bundle.core.url(forResource: "Schedule", withExtension: "json")!)
            self.days = chunkUpEvents(try! Self.decoder.decode([Event].self, from: jsonData))
        }
    }

    private static func loadCachedEvents() -> [Event]? {
        guard let cachedJsonUrl, let cachedJsonData = try? Data(contentsOf: cachedJsonUrl) else { return nil }
        return try? decoder.decode([Event].self, from: cachedJsonData)
    }

    @MainActor public func fetchEvents() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/main/DeepDishCore/Schedule.json")!
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            days = try chunkUpEvents(Self.decoder.decode([Event].self, from: data))
            guard let cachedJsonUrl = Self.cachedJsonUrl else { return }
            try data.write(to: cachedJsonUrl)
            #if canImport(WidgetKit)
            WidgetCenter.shared.reloadAllTimelines()
            #endif
        } catch {
            // Fail silently
        }
    }

    public var currentDateEvent: Event? {
        for day in days {
            for event in day.events {
                if event.isHappeningNow {
                    return event
                }
            }
        }
        return nil
    }

    public func dayName(for event: Event) -> String? {
        days.first { $0.events.contains(where: { $0.id == event.id }) }?.name
    }

    private func chunkUpEvents(_ events: [Event]) -> [Day] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(identifier: "America/Chicago")
        return events
            .reduce(into: [String: Day]()) { partialResult, event in
                let dayName = dateFormatter.string(from: event.start)
                if var day = partialResult[dayName] {
                    day.events.append(event)
                    day.events.sort(using: KeyPathComparator(\Event.start))
                    partialResult[dayName] = day
                } else {
                    partialResult[dayName] = .init(name: dayName, events: [event])
                }
            }
            .map(\.value)
            .sorted(using: KeyPathComparator(\.events.first?.start))
    }
}

public extension ScheduleController {
    static func forPreview() -> ScheduleController {
        .init()
    }
}
