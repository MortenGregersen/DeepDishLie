//
//  DeepDishSnapshots.swift
//  DeepDishSnapshots
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import XCTest

final class DeepDishSnapshots: XCTestCase {
    @MainActor func testAppStoreScreenshots() async throws {
        let app = XCUIApplication()
        app.launchArguments.append("-Demo")
        app.launchArguments.append("true")
        setupSnapshot(app)
        app.launch()
        snapshot("1-Schedule")
        app.buttons["Weather"].tap()
        guard app.staticTexts["Forecast data provided by"].waitForExistence(timeout: 10) else { XCTFail(); return }
        snapshot("2-Weather")
        app.buttons["About"].tap()
        snapshot("3-About")
    }
}
