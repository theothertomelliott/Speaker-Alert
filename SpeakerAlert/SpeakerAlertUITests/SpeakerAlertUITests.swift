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

	func testAddProfile() {

		let app = XCUIApplication()
		app.navigationBars["Profiles"].buttons["Add"].tap()
		app.alerts["Add"].collectionViews.buttons["New Speech Profile"].tap()

		let tablesQuery = app.tables
		let textField = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).childrenMatchingType(.TextField).element
		textField.tap()

//		let deleteKey = app.keys["delete"]
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		deleteKey.tap()
//		app.buttons["shift"]		.tap()
//		textField.typeText("Test")
//		app.toolbars.buttons["Done"].tap()
		tablesQuery.cells["Green"]		.staticTexts["0:00"].tap()

		// Wait until the button is there
		let button = app.buttons["Cancel"]
		let exists = NSPredicate(format: "exists == 1")

		expectationForPredicate(exists, evaluatedWithObject: button, handler: nil)
		waitForExpectationsWithTimeout(5, handler: nil)

//        app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue("1")
//        app.pickerWheels.elementBoundByIndex(2).adjustToPickerWheelValue("2")
//        app.pickerWheels.elementBoundByIndex(3).adjustToPickerWheelValue("3")

		app.buttons["Cancel"].tap()
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

		app.tables.staticTexts["Five Minutes"].tap()
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
