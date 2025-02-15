//
//  Day.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

public struct Day: Identifiable {
    public var id: String { name }
    public let name: String
    public var events: [Event]
    
    public init(name: String, events: [Event]) {
        self.name = name
        self.events = events
    }
}
