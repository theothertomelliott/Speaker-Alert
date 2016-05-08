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

    var app: XCUIApplication!

	override func setUp() {
		super.setUp()
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		// UI tests must launch the application that they test.
		// Doing this in setup will make sure it happens for each test method.
		app = XCUIApplication()
		app.launchArguments = ["isUITesting"]
		setupSnapshot(app)
		app.launch()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testTimeProgression() {
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

        snapshot("Before starting")

		app.buttons["Play"].tap()

		XCTAssert(app.staticTexts["0:00"].exists)

		expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["0:01"], handler: nil)
		waitForExpectationsWithTimeout(1.2, handler: nil)

		expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["1:00"], handler: nil)
		waitForExpectationsWithTimeout(65, handler: nil)

		snapshot("Timer green")

        expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["1:30"], handler: nil)
        waitForExpectationsWithTimeout(65, handler: nil)

        snapshot("Timer amber")

        expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["2:00"], handler: nil)
        waitForExpectationsWithTimeout(65, handler: nil)

        snapshot("Timer red")

        app.buttons["Stop"].tap()

        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts["Speech Complete"],
                                handler: nil)
        waitForExpectationsWithTimeout(1.2, handler: nil)

        snapshot("Speech complete")
	}

	func testLoadProfileAndReturn() {

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

		let tabBarsQuery = app.tabBars
		tabBarsQuery.buttons["Settings"].tap()
		app.tables.staticTexts["About Speaker Alert"].tap()
		app.navigationBars["About"].buttons["Settings"].tap()
		tabBarsQuery.buttons["Speech"].tap()
	}

    func testCreateProfile() {

        let app = XCUIApplication()
        app.navigationBars["Profiles"].buttons["Add"].tap()
        app.alerts["Add"].collectionViews.buttons["New Speech Profile"].tap()

        app.tables.textFields["Profile Name"].tap()
        app.tables.textFields["Profile Name"].typeText("Test")
        app.toolbars.buttons["Done"].tap()
        app.tables.cells["Green"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("1")
        app.buttons["Save"].tap()

        app.tables.cells["Yellow"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("2")
        app.buttons["Save"].tap()

        app.tables.cells["Red"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("3")
        app.buttons["Save"].tap()

        app.tables.cells["Over Maximum"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("4")
        app.buttons["Save"].tap()

        app.buttons["Save"].tap()
        
        // TODO: Verify test
        //XCTAssert(app.tables.cells["Test"].exists)

    }

}
