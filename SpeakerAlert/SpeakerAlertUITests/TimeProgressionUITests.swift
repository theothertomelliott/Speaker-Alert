//
//  TimeProgressionUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/9/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class TimeProgressionUITests: SpeakerAlertUITests {

    func landscapeSuffix() -> String {
        if isLandscape() {
            return " - Landscape"
        }
        return ""
    }

    func testTimeProgression() {
        // Wait until the defaults are loaded
        let exists = NSPredicate(format: "exists == 1")
        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts["Toastmasters"], handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        // Open the profile
        app.tables.staticTexts["Toastmasters"].tap()

        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts["Table Topic"], handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        app.tables.staticTexts["Table Topic"].tap()
        snapshot("Before starting" + landscapeSuffix(), waitForLoadingIndicator: false)

        app.buttons["Play"].tap()
        XCTAssert(app.staticTexts["0:00"].exists)

        NSThread.sleepForTimeInterval(60)
        snapshot("Timer green" + landscapeSuffix(), waitForLoadingIndicator: false)

        NSThread.sleepForTimeInterval(30)
        snapshot("Timer amber" + landscapeSuffix(), waitForLoadingIndicator: false)

        NSThread.sleepForTimeInterval(30)
        snapshot("Timer red" + landscapeSuffix(), waitForLoadingIndicator: false)

        app.tap()
        app.buttons["Stop"].tap()

        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts["Speech Complete"],
                                handler: nil)
        waitForExpectationsWithTimeout(1.2, handler: nil)
        snapshot("Speech complete" + landscapeSuffix(), waitForLoadingIndicator: false)
    }

}
