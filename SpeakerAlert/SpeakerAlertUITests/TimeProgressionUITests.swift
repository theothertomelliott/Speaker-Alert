//
//  TimeProgressionUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/9/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class TimeProgressionUITests: SpeakerAlertUITests {

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
        snapshot("Before starting", waitForLoadingIndicator: false)

        app.buttons["Play"].tap()
        XCTAssert(app.staticTexts["0:00"].exists)

        expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["1:00"], handler: nil)
        waitForExpectationsWithTimeout(65, handler: nil)
        snapshot("Timer green", waitForLoadingIndicator: false)

        expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["1:30"], handler: nil)
        waitForExpectationsWithTimeout(65, handler: nil)
        snapshot("Timer amber", waitForLoadingIndicator: false)

        expectationForPredicate(exists, evaluatedWithObject: app.staticTexts["2:00"], handler: nil)
        waitForExpectationsWithTimeout(65, handler: nil)
        snapshot("Timer red", waitForLoadingIndicator: false)

        app.tap()
        app.buttons["Stop"].tap()

        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts["Speech Complete"],
                                handler: nil)
        waitForExpectationsWithTimeout(1.2, handler: nil)
        snapshot("Speech complete", waitForLoadingIndicator: false)
    }

}
