//
//  DeepDishCoreTests.swift
//  DeepDishCoreTests
//
//  Created by Morten Bjerg Gregersen on 15/02/2025.
//

import Foundation
import Testing
@testable import DeepDishCore

struct DeepDishCoreTests {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    @Test func schedule2026BundleResourceDecodes() throws {
        let url = try #require(Bundle.core.url(forResource: ScheduleController.bundledScheduleResourceName, withExtension: "json"))
        let data = try Data(contentsOf: url)
        let events = try decoder.decode([Event].self, from: data)

        #expect(!events.isEmpty)
        #expect(events.count == 33)
    }

    @Test func scheduleControllerLoadsSchedule2026() throws {
        let controller = ScheduleController()
        let allEvents = controller.days.flatMap(\.events)
        let iso8601DateFormatter = ISO8601DateFormatter()
        let expectedFirstEventDate = try #require(iso8601DateFormatter.date(from: "2026-04-12T11:00:00-05:00"))

        #expect(controller.firstEventDate == expectedFirstEventDate)
        #expect(allEvents.first?.id == "practical-registration-opens")
        #expect(allEvents.contains(where: { $0.id == "special-opening-keynote" }))
    }

    @Test func schedule2026ContainsExpectedEventKinds() throws {
        let url = try #require(Bundle.core.url(forResource: ScheduleController.bundledScheduleResourceName, withExtension: "json"))
        let data = try Data(contentsOf: url)
        let events = try decoder.decode([Event].self, from: data)

        #expect(events.contains { if case .practical = $0 { return true } else { return false } })
        #expect(events.contains { if case .special = $0 { return true } else { return false } })
        #expect(events.contains { if case .session = $0 { return true } else { return false } })
        #expect(events.contains { if case .pause = $0 { return true } else { return false } })
        #expect(events.contains { if case .breakfast = $0 { return true } else { return false } })
        #expect(events.contains { if case .lunch = $0 { return true } else { return false } })
    }

    @Test func scheduleControllerUsesSchedule2026RemoteUrl() {
        #expect(ScheduleController.remoteScheduleUrl.absoluteString.hasSuffix("/DeepDishCore/Schedule2026.json"))
    }

    @Test func sessionTbdIdsStillDecodeAsToBeDetermined() throws {
        let data = Data("""
        [
            {
                "id": "session-tbd-sample",
                "start": "2026-04-13T09:00:00-05:00",
                "end": "2026-04-13T09:45:00-05:00",
                "description": "Schedule to be announced"
            }
        ]
        """.utf8)
        let events = try decoder.decode([Event].self, from: data)
        let event = try #require(events.first)

        #expect(event.toBeDetermined)
    }

    @Test func linksDecodeLinkedinUrl() throws {
        let data = Data("""
        {
            "linkedin": "https://www.linkedin.com/in/example-person/"
        }
        """.utf8)

        let links = try JSONDecoder().decode(Links.self, from: data)

        #expect(links.linkedin?.absoluteString == "https://www.linkedin.com/in/example-person/")
    }
}
