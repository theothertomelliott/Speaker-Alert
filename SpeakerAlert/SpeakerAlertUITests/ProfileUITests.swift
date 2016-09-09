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
        XCTAssertEqual(app.tables.cells.count, 7)

        // Open the profile
        app.tables.staticTexts["Five Minutes"].tap()

        // Hit the back button
        app.navigationBars["Five Minutes"].buttons["Profiles"].tap()

        XCTAssertEqual(app.tables.cells.count, 7)

        snapshot("001 Profile list", waitForLoadingIndicator: false)
    }
    
    
    func openAddProfile() {
        app.navigationBars["Profiles"].buttons["Add"].tap()
        if app.alerts["Add"].collectionViews.buttons["New Speech Profile"].exists {
            app.alerts["Add"].collectionViews.buttons["New Speech Profile"].tap()
        } else if app.alerts["Add"].buttons["New Speech Profile"].exists {
            app.alerts["Add"].buttons["New Speech Profile"].tap()
        }
    }

    func testCreateProfile() {
        openAddProfile()
        
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
        openAddProfile()

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
        waitForElement(app.staticTexts["Test"])

        app.navigationBars["Profiles"].buttons["Edit"].tap()
        app.tables.buttons["Delete Test, ● 4 ● 1 ● 2 ▾ 3"].tap()
        app.tables.buttons["Edit"].tap()
        app.buttons["Back"].tap()
        app.navigationBars["Profiles"].buttons["Done"].tap()
        
        app.tables.staticTexts["Test"].tap()
        app.buttons["Play"].tap()
    }
}
