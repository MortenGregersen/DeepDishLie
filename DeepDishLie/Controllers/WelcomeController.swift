//
//  WelcomeController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

@Observable
class WelcomeController {
    var hasSeenWelcome: Bool { didSet { UserDefaults.standard.set(hasSeenWelcome, forKey: "has-seen-welcome-2024") }}
    var showsWelcome = false
    var hasJustSeenWelcome = false

    init() {
        self.hasSeenWelcome = UserDefaults.standard.bool(forKey: "has-seen-welcome-2024")
    }
}

extension WelcomeController {
    static func forPreview(hasSeenWelcome: Bool) -> WelcomeController {
        let controller = WelcomeController()
        controller.hasSeenWelcome = hasSeenWelcome
        return controller
    }
}
