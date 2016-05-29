//
//  TimeScreenshotUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/19/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation
import XCTest

class TimeScreenshotUITests: SpeakerAlertUITests {
    
    override func setUp() {
        setUpNoApp()
    }
    
    let speechGroup = "Toastmasters"
    let speechTitle = "Speech: Five to Seven Minutes"
    
    func openSpeech() {
        // Wait until the defaults are loaded
        let exists = NSPredicate(format: "exists == 1")
        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts[speechGroup], handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        // Open the profile
        app.tables.staticTexts[speechGroup].tap()
        
        expectationForPredicate(exists,
                                evaluatedWithObject: app.staticTexts[speechTitle],
                                handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        app.tables.staticTexts[speechTitle].tap()
    }
    
    func startSpeech() {
        app.buttons["Play"].tap()

    }
    
    func stopSpeech() {
        app.tap()
        app.buttons["Stop"].tap()
    }
    
    func testBeforeStarting() {
        startApp(false, startTime: 0)
        openSpeech()
        snapshot("005 - Before starting", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("Before starting - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testTimerGreen() {
        startApp(false, startTime: 300)
        openSpeech()
        startSpeech()
        snapshot("002 - Timer green", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("Timer green - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testTimerYellow() {
        startApp(false, startTime: 360)
        openSpeech()
        startSpeech()
        snapshot("Timer yellow", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("003 - Timer yellow - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testTimerRed() {
        startApp(false, startTime: 420)
        openSpeech()
        startSpeech()
        snapshot("Timer red", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("Timer red - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testStopSpeech() {
        startApp(false, startTime: 430)
        
        openSpeech()
        startSpeech()
        stopSpeech()
        
        waitForElement(app.staticTexts["Speech Complete"])
        
        snapshot("004 - After stopping", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("After stopping - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
}
