//
//  SpeakerAlertUITests.swift
//  SpeakerAlertUITests
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import XCTest

class SpeakerAlertUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["isUITesting"]
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddProfile() {

    }

    func testLoadProfileAndReturn() {
        let app = XCUIApplication()

        // Wait until the defaults are loaded
        let label = app.staticTexts["Five Minutes"]
        let exists = NSPredicate(format: "exists == 1")

        expectationForPredicate(exists, evaluatedWithObject: label, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        XCTAssertEqual(app.tables.cells.count, 6)

        app.tables.staticTexts["Five Minutes"].tap()
        app.navigationBars["Five Minutes"].buttons["Profiles"].tap()

        XCTAssertEqual(app.tables.cells.count, 6)
    }

    func testLoadAboutScreen() {
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Settings"].tap()
        app.tables.staticTexts["About Speaker Alert"].tap()
        app.navigationBars["About"].buttons["Settings"].tap()
        tabBarsQuery.buttons["Speech"].tap()

    }

}
