//
//  Event.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

struct Event: Codable, Identifiable {
    let id: String
    let start: Date
    let end: Date
    let description: String
    let speakers: [Speaker]?
}
