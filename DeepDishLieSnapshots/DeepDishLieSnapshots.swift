//
//  DeepDishLieSnapshots.swift
//  DeepDishLieSnapshots
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import XCTest

final class ScoreWondersUITests: XCTestCase {
    @MainActor func testAppStoreScreenshots() async throws {
        let app = XCUIApplication()
        app.launchArguments.append("-Demo")
        app.launchArguments.append("true")
        setupSnapshot(app)
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]
        snapshot("1-Schedule")
        tabBar.buttons["Wu with the Weather"].tap()
        snapshot("2-Weather")
        tabBar.buttons["About"].tap()
        snapshot("3-About")
    }
}
