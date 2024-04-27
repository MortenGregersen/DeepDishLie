//
//  ScheduleController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2024.
//

import Algorithms
import Foundation

@Observable
class ScheduleController {
    private(set) var days: [Day] = []
    private static let cachedJsonFilename = "Schedule.json"
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init() {
        if let events = Self.loadCachedEvents() {
            self.days = chunkUpEvents(events)
        } else {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "Schedule", withExtension: "json")!)
            self.days = chunkUpEvents(try! Self.decoder.decode([Event].self, from: jsonData))
        }
    }

    private static func loadCachedEvents() -> [Event]? {
        guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let cachedJsonData = try? Data(contentsOf: cacheFolderURL.appending(component: cachedJsonFilename)) else { return nil }
        return try? decoder.decode([Event].self, from: cachedJsonData)
    }

    @MainActor func fetchEvents() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/main/DeepDishLie/Schedule.json")!
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            days = try chunkUpEvents(Self.decoder.decode([Event].self, from: data))
            guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            try data.write(to: cacheFolderURL.appending(component: Self.cachedJsonFilename))
        } catch {
            // Fail silently
        }
    }

    private func chunkUpEvents(_ events: [Event]) -> [Day] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(identifier: "America/Chicago")
        return events.chunked(on: { dateFormatter.string(from: $0.start) })
            .map { dayName, events in
                Day(name: dayName, events: Array(events))
            }
    }
}

extension ScheduleController {
    static func forPreview() -> ScheduleController {
        let controller = ScheduleController()
        return controller
    }
}
