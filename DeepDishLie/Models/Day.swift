//
//  Day.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

struct Day: Identifiable {
    var id: String { name }
    let name: String
    var events: [Event]
}
