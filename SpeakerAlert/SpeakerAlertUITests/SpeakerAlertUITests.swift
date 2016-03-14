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
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		// UI tests must launch the application that they test.
		// Doing this in setup will make sure it happens for each test method.
		let app = XCUIApplication()
		app.launchArguments = ["isUITesting"]
		setupSnapshot(app)
		app.launch()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testTimeProgression() {
		let app = XCUIApplication()

		// Wait until the defaults are loaded
		let label = app.staticTexts["Toastmasters"]
		let exists = NSPredicate(format: "exists == 1")

		expectationForPredicate(exists, evaluatedWithObject: label, handler: nil)
		waitForExpectationsWithTimeout(5, handler: nil)

		// Open the profile
		app.tables.staticTexts["Toastmasters"].tap()

        let topic = app.staticTexts["Table Topic"]

        expectationForPredicate(exists, evaluatedWithObject: topic, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        app.tables.staticTexts["Table Topic"].tap()

        app.buttons["Play"].tap()

        sleep(60)

        XCTAssert(app.staticTexts["1:00"].exists)

        snapshot("Timer green")
	}

	func testLoadProfileAndReturn() {
		let app = XCUIApplication()

		// Wait until the defaults are loaded
		let label = app.staticTexts["Five Minutes"]
		let exists = NSPredicate(format: "exists == 1")

		expectationForPredicate(exists, evaluatedWithObject: label, handler: nil)
		waitForExpectationsWithTimeout(5, handler: nil)

		// TODO: Base this off the seed data
		XCTAssertEqual(app.tables.cells.count, 6)

		// Open the profile
		app.tables.staticTexts["Five Minutes"].tap()

		// Hit the back button
		app.navigationBars["Five Minutes"].buttons["Profiles"].tap()

		XCTAssertEqual(app.tables.cells.count, 6)

		snapshot("Profile list")
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
