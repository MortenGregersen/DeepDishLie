//
//  SettingsController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import Foundation

@Observable
class SettingsController {
    var useLocalTimezone: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-local-timezone") }}
    var use24hourClock: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-24-hour-clock") }}
    var openLinksInApp: Bool { didSet { UserDefaults.standard.set(openLinksInApp, forKey: "open-links-in-app") }}
    var useCelcius: Bool { didSet { UserDefaults.standard.set(useCelcius, forKey: "use-celcius") }}

    init() {
        self.useLocalTimezone = UserDefaults.standard.bool(forKey: "use-local-timezone")
        self.use24hourClock = UserDefaults.standard.bool(forKey: "use-24-hour-clock")
        self.openLinksInApp = UserDefaults.standard.bool(forKey: "open-links-in-app")
        self.useCelcius = UserDefaults.standard.bool(forKey: "use-fahrenheit")
    }
}

extension SettingsController {
    static func forPreview() -> SettingsController {
        .init()
    }
}
