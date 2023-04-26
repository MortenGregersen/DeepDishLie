//
//  DeepDishLieSnapshots.swift
//  DeepDishLieSnapshots
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import XCTest

final class ScoreWondersUITests: XCTestCase {
    func testAppStoreScreenshots() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-Demo")
        app.launchArguments.append("true")
        setupSnapshot(app)
        app.launch()
        snapshot("1-Welcome")
        app.buttons["Let's go!"].tap()
        let charlie = app.staticTexts["Charlie Chapman"]
        guard charlie.waitForExistence(timeout: 4) else { XCTFail(); return }
        charlie.tap()
        guard app.staticTexts["I've step foot on every US State, except Alaska"].waitForExistence(timeout: 4) else { XCTFail(); return }
        snapshot("2-Speakers")
    }
}
