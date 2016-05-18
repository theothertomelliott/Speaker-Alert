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
    
	override func setUp() {
        
        addUIInterruptionMonitorWithDescription("Local Notifications") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
        
		super.setUp()
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		// UI tests must launch the application that they test.
		// Doing this in setup will make sure it happens for each test method.
		app = XCUIApplication()
		app.launchArguments = ["--uitesting"]
		setupSnapshot(app)
		app.launch()
        
        device = XCUIDevice.sharedDevice()
        if self.isLandscape() {
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
    
    func waitForElement(element: XCUIElement) -> XCUIElement {
        // Verify the new profile was created
        expectationForPredicate(
            NSPredicate(format: "exists == 1"),
            evaluatedWithObject: element,
            handler: nil)
        waitForExpectationsWithTimeout(0.5, handler: nil)
        return element
    }

}
