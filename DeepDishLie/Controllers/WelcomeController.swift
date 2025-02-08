//
//  WelcomeController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

@Observable
class WelcomeController {
    var hasSeenWelcome: Bool { didSet { UserDefaults.standard.set(hasSeenWelcome, forKey: hasSeenWelcomeKey) }}
    var hasRequestedReview: Bool { didSet { UserDefaults.standard.set(hasRequestedReview, forKey: hasSeenReviewKey) }}
    var showsWelcome: Bool
    var hasJustSeenWelcome = false
    
    private let hasSeenWelcomeKey = "has-seen-welcome-2025"
    private let hasSeenReviewKey = "has-seen-review-2025"

    init() {
        let hasSeenWelcome = UserDefaults.standard.bool(forKey: hasSeenWelcomeKey)
        self.hasSeenWelcome = hasSeenWelcome
        self.hasRequestedReview = UserDefaults.standard.bool(forKey: hasSeenReviewKey)
        showsWelcome = !hasSeenWelcome || DeepDishLieApp.inDemoMode
    }
}

extension WelcomeController {
    static func forPreview(hasSeenWelcome: Bool) -> WelcomeController {
        let controller = WelcomeController()
        controller.hasSeenWelcome = hasSeenWelcome
        return controller
    }
}
