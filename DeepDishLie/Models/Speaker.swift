//
//  Speaker.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 26/04/2024.
//

import Foundation

struct Speaker: Codable, Identifiable {
    var id: String { name }
    let name: String
    let image: String
}
