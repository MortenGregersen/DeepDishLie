//
//  WelcomeController.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

@Observable
public class WelcomeController {
    public var hasSeenWelcome: Bool { didSet { UserDefaults.standard.set(hasSeenWelcome, forKey: hasSeenWelcomeKey) }}
    public var hasRequestedReview: Bool { didSet { UserDefaults.standard.set(hasRequestedReview, forKey: hasSeenReviewKey) }}
    public var showsWelcome: Bool
    public var hasJustSeenWelcome = false

    private let hasSeenWelcomeKey = "has-seen-welcome-2025"
    private let hasSeenReviewKey = "has-seen-review-2025"

    public init(inDemoMode: Bool) {
        let hasSeenWelcome = UserDefaults.standard.bool(forKey: hasSeenWelcomeKey)
        self.hasSeenWelcome = hasSeenWelcome
        self.hasRequestedReview = UserDefaults.standard.bool(forKey: hasSeenReviewKey)
        showsWelcome = !hasSeenWelcome && !inDemoMode
    }
}

public extension WelcomeController {
    static func forPreview(hasSeenWelcome: Bool) -> WelcomeController {
        let controller = WelcomeController(inDemoMode: true)
        controller.hasSeenWelcome = hasSeenWelcome
        return controller
    }
}
