//
//  UserDefaults+AppGroup.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 03/04/2025.
//

import Foundation

public extension UserDefaults {
    @MainActor static let appGroup: UserDefaults = .init(suiteName: "group.com.CoolYellowOwl.DeepDishLie")!
}
