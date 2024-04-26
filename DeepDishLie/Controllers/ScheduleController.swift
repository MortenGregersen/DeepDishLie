//
//  ScheduleController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2024.
//

import Foundation

@Observable
class ScheduleController {
    private(set) var events: [Event]
    private static let cachedJsonFilename = "Schedule.json"
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init() {
        if let events = Self.loadCachedEvents() {
            self.events = events
        } else {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "Schedule", withExtension: "json")!)
            self.events = try! Self.decoder.decode([Event].self, from: jsonData)
        }
    }
    
    private static func loadCachedEvents() -> [Event]? {
        guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let cachedJsonData = try? Data(contentsOf: cacheFolderURL.appending(component: cachedJsonFilename)) else { return nil }
        return try? decoder.decode([Event].self, from: cachedJsonData)
    }
    
    @MainActor func fetchEvents() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/schedule/DeepDishLie/Schedule.json")!
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            events = try Self.decoder.decode([Event].self, from: data)
            guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            try data.write(to: cacheFolderURL.appending(component: Self.cachedJsonFilename))
        } catch {
            // Fail silently
        }
    }
}

struct Event: Codable, Identifiable {
    let id: String
    let start: Date
    let end: Date
    let description: String
    let speakers: [String]?
}
