//
//  Event.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

public enum Event: Decodable, Identifiable {
    case practical(Session)
    case session(Session)
    case special(Session)
    case pause(Break)
    case breakfast(Break)
    case lunch(Break)

    public var id: String {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.id
        case .pause(let event),
             .breakfast(let event),
             .lunch(let event):
            event.id
        }
    }

    public var start: Date {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.start
        case .pause(let event),
             .breakfast(let event),
             .lunch(let event):
            event.start
        }
    }

    public var end: Date {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.end
        case .pause(let event),
             .breakfast(let event),
             .lunch(let event):
            event.end
        }
    }

    public var description: String {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.description
        case .pause:
            "Break"
        case .breakfast:
            "Breakfast"
        case .lunch:
            "Lunch"
        }
    }

    public var speakers: [Speaker]? {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.speakers
        default:
            nil
        }
    }

    public var links: Links? {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.links
        default:
            nil
        }
    }

    public var emoji: String? {
        switch self {
        case .session(let session),
             .practical(let session),
             .special(let session):
            if let emoji = session.emoji {
                return emoji
            } else if session.id.hasPrefix("practical-registration") {
                return "🪪"
            } else if session.id.hasPrefix("practical-intro") {
                return "🤗"
            } else if session.id.hasPrefix("practical-morning-welcome") {
                return "☀️"
            } else if session.id.hasPrefix("special-concert") {
                return "🎸"
            } else if session.id.hasPrefix("special-apple") {
                return "🍎"
            } else if session.id.hasPrefix("practical-closing") {
                return "👋"
            }
            return nil
        case .pause:
            return "☕️"
        case .breakfast:
            return "🥐"
        case .lunch:
            return "🥪"
        }
    }

    public var isHappeningNow: Bool {
        start ... end ~= Date()
    }

    public var toBeDetermined: Bool {
        guard case .session(let session) = self else { return false }
        return session.id.hasPrefix("session-tbd")
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        if id.hasPrefix("practical") {
            self = try .practical(.init(from: decoder))
        } else if id.hasPrefix("session") {
            self = try .session(.init(from: decoder))
        } else if id.hasPrefix("special") {
            self = try .special(.init(from: decoder))
        } else if id.hasPrefix("breakfast") {
            self = try .breakfast(.init(from: decoder))
        } else if id.hasPrefix("lunch") {
            self = try .lunch(.init(from: decoder))
        } else {
            self = try .pause(.init(from: decoder))
        }
    }

    enum CodingKeys: CodingKey {
        case id
        case start
        case end
        case speakers
    }

    public static func dateFormatter(useLocalTimezone: Bool, use24hourClock: Bool) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = use24hourClock ? Locale(identifier: "da_DK") : Locale(identifier: "en_US")
        dateFormatter.timeZone = useLocalTimezone ? TimeZone.current : TimeZone(identifier: "America/Chicago")
        return dateFormatter
    }
}

public struct Break: Decodable, Identifiable {
    public let id: String
    public let start: Date
    public let end: Date
}

public struct Session: Decodable, Identifiable {
    public let id: String
    public let start: Date
    public let end: Date
    public let description: String
    public let speakers: [Speaker]?
    public let emoji: String?
    public let links: Links?
}
