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
    var device: XCUIDevice!
    
    func setUpNoApp() {
        super.setUp()
    }
    
	override func setUp() {
		super.setUp()
        startApp(isLandscape(), startTime: startTimeOffset())
	}

    func startApp(landscape: Bool, startTime: Int) {
        addUIInterruptionMonitorWithDescription("Local Notifications") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments = ["--uitesting", "--starttime", String(startTime)]
        setupSnapshot(app)
        app.launch()
        
        device = XCUIDevice.sharedDevice()
        if landscape {
            device.orientation = UIDeviceOrientation.LandscapeLeft
        } else {
            device.orientation = UIDeviceOrientation.Portrait
        }
    }
    
	override func tearDown() {
		super.tearDown()
	}
    
    func isLandscape() -> Bool {
        return false
    }
    
    // Number of seconds to offset the timer's start time
    func startTimeOffset() -> Int {
        return 0
    }
    
    func waitForElement(element: XCUIElement) -> XCUIElement {
        // Verify the new profile was created
        expectationForPredicate(
            NSPredicate(format: "exists == 1"),
            evaluatedWithObject: element,
            handler: nil)
        waitForExpectationsWithTimeout(0.5, handler: nil)
        return element
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

}
