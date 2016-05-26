//
//  PhaseProgressionUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/26/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class PhaseProgressionUITests: SpeakerAlertUITests {
 
    override func setUp() {
        setUpNoApp()
    }
    
    func startAppTestDisplay(startTime: Int) {
        addUIInterruptionMonitorWithDescription("Local Notifications") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments = [
            "--uitesting",
            "--starttime", String(startTime),
            "--speechdisplay", "Test"
        ]
        setupSnapshot(app)
        app.launch()
        
        device = XCUIDevice.sharedDevice()
        device.orientation = UIDeviceOrientation.Portrait
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
    
    func testTimerBefore() {
        startAppTestDisplay(0)
        openSpeech()
        startSpeech()
        XCTAssert(app.staticTexts["Below minimum"].exists)
    }
    
    func testTimerGreen() {
        startAppTestDisplay(300)
        openSpeech()
        startSpeech()
        XCTAssert(app.staticTexts["Green"].exists)
    }
    
    func testTimerYellow() {
        startAppTestDisplay(360)
        openSpeech()
        startSpeech()
        XCTAssert(app.staticTexts["Yellow"].exists)
    }
    
    func testTimerRed() {
        startAppTestDisplay(420)
        openSpeech()
        startSpeech()
        XCTAssert(app.staticTexts["Red"].exists)
    }
    
    func testTimerAlert() {
        startAppTestDisplay(450)
        openSpeech()
        startSpeech()
        XCTAssert(app.staticTexts["Alert"].exists)
    }
    
}
