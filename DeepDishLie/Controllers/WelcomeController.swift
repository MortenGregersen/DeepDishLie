//
//  WelcomeController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

class WelcomeController: ObservableObject {
    @AppStorage("has-seen-welcome") var hasSeenWelcome = false
    @Published var isShowingWelcome = false
}

extension WelcomeController {
    static func forPreview(hasSeenWelcome: Bool) -> WelcomeController {
        let controller = WelcomeController()
        controller.hasSeenWelcome = hasSeenWelcome
        return controller
    }
}
