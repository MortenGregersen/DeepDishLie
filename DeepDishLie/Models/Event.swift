//
//  Event.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

enum Event: Decodable, Identifiable {
    case practical(Session)
    case session(Session)
    case special(Session)
    case pause(Break)
    case breakfast(Break)
    case lunch(Break)

    var id: String {
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

    var start: Date {
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

    var end: Date {
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

    var description: String {
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

    var speakers: [Speaker]? {
        switch self {
        case .practical(let session),
             .session(let session),
             .special(let session):
            session.speakers
        default:
            nil
        }
    }

    init(from decoder: any Decoder) throws {
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
}

struct Break: Decodable, Identifiable {
    let id: String
    let start: Date
    let end: Date
}

struct Session: Decodable, Identifiable {
    let id: String
    let start: Date
    let end: Date
    let description: String
    let speakers: [Speaker]?
}
