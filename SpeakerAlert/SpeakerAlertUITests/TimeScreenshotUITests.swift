//
//  TimeScreenshotUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/19/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation

class TimeScreenshotUITests: SpeakerAlertUITests {
    
    override func setUp() {
        setUpNoApp()
    }
    
    func startSpeech(){
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
        
        app.buttons["Play"].tap()

    }
    
    func testTimerGreen() {
        startApp(false, startTime: 61)
        startSpeech()
        snapshot("Timer green", waitForLoadingIndicator: false)
    }
    
    func testTimerYellow() {
        startApp(false, startTime: 91)
        startSpeech()
        snapshot("Timer yellow", waitForLoadingIndicator: false)
    }
    
    func testTimerRed() {
        startApp(false, startTime: 121)
        startSpeech()
        snapshot("Timer red", waitForLoadingIndicator: false)
    }
    
    
}
