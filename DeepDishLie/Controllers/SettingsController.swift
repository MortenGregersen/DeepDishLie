//
//  SettingsController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import Foundation

@Observable
class SettingsController {
    var useCelcius: Bool { didSet { UserDefaults.standard.set(useCelcius, forKey: "use-celcius") }}
    var useLocalTimezone: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-local-timezone") }}
    var use24hourClock: Bool {  didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-24-hour-clock") }}

    init() {
        self.useCelcius = UserDefaults.standard.bool(forKey: "use-fahrenheit")
        self.useLocalTimezone = UserDefaults.standard.bool(forKey: "use-local-timezone")
        self.use24hourClock = UserDefaults.standard.bool(forKey: "use-24-hour-clock")
    }
}

extension SettingsController {
    static func forPreview() -> SettingsController {
        .init()
    }
}
