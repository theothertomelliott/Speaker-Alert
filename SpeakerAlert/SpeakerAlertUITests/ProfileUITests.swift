//
//  ProfileEditUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/9/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class ProfileEditUITests: SpeakerAlertUITests {

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
        app.tables.cells["Green"].tap()
        app.pickerWheels.element(boundBy: 4).adjust(toPickerWheelValue: "1")
        app.buttons["Save"].tap()

        app.tables.cells["Yellow"].tap()
        app.pickerWheels.element(boundBy: 4).adjust(toPickerWheelValue: "2")
        app.buttons["Save"].tap()

        app.tables.cells["Red"].tap()
        app.pickerWheels.element(boundBy: 4).adjust(toPickerWheelValue: "3")
        app.buttons["Save"].tap()

        app.tables.cells["Over Maximum"].tap()
        app.pickerWheels.element(boundBy: 4).adjust(toPickerWheelValue: "4")
        app.buttons["Save"].tap()

        app.buttons["Save"].tap()

        // Verify the new profile was created
        expectation(
            for: NSPredicate(format: "exists == 1"),
            evaluatedWith: app.staticTexts["Test"],
            handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testOutOfOrderTimings() {
        openAddProfile()

        app.tables.textFields["Profile Name"].tap()
        app.tables.textFields["Profile Name"].typeText("Test")
        app.toolbars.buttons["Done"].tap()
        
        app.tables.cells["Green"].tap()
        app.pickerWheels.element(boundBy: 4).adjust(toPickerWheelValue: "4")
        app.buttons["Save"].tap()

        app.buttons["Save"].tap()

        // Expect an error
        expectation(
            for: NSPredicate(format: "exists == 1"),
            evaluatedWith: app.alerts["Out of order"],
            handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
    }
}
