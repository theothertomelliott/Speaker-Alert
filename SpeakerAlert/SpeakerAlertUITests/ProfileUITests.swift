//
//  ProfileEditUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/9/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class ProfileEditUITests: SpeakerAlertUITests {

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

    func testCreateProfile() {
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

        // Verify the new profile was created
        expectationForPredicate(
            NSPredicate(format: "exists == 1"),
            evaluatedWithObject: app.staticTexts["Test"],
            handler: nil)
        waitForExpectationsWithTimeout(2, handler: nil)
    }

    func testOutOfOrderTimings() {
        app.navigationBars["Profiles"].buttons["Add"].tap()
        app.alerts["Add"].collectionViews.buttons["New Speech Profile"].tap()

        app.tables.textFields["Profile Name"].tap()
        app.tables.textFields["Profile Name"].typeText("Test")
        app.toolbars.buttons["Done"].tap()
        app.tables.cells["Green"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("4")
        app.buttons["Save"].tap()

        app.tables.cells["Yellow"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("1")
        app.buttons["Save"].tap()

        app.tables.cells["Red"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("2")
        app.buttons["Save"].tap()

        app.tables.cells["Over Maximum"].staticTexts["0:00"].tap()
        app.pickerWheels.elementBoundByIndex(4).adjustToPickerWheelValue("3")
        app.buttons["Save"].tap()

        app.buttons["Save"].tap()

        // Verify the new profile was created
        expectationForPredicate(
            NSPredicate(format: "exists == 1"),
            evaluatedWithObject: app.staticTexts["Test"],
            handler: nil)
        waitForExpectationsWithTimeout(2, handler: nil)

        app.navigationBars["Profiles"].buttons["Edit"].tap()

        app.tables.buttons["Delete Test, ● 4 ● 1 ● 2 ○ 3"].tap()
        app.tables.buttons["Edit"].tap()

        // Verify the new profile was created
        expectationForPredicate(
            NSPredicate(format: "exists == 1"),
            evaluatedWithObject: app.tables.cells["Green"],
            handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)

        app.buttons["Back"].tap()

        app.tables.staticTexts["Test"].tap()
        app.buttons["Play"].tap()
    }
}
