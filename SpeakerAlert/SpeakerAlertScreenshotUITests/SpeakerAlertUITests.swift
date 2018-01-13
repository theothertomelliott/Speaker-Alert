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
        startApp(startTimeOffset(), landscape: isLandscape())
	}

    func startAppWithArguments(_ arguments: [String], landscape: Bool = false) {
        addUIInterruptionMonitor(withDescription: "Local Notifications") { (alert) -> Bool in
            if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
                return true
            } else if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments = arguments
        app.launchArguments.append("--uitesting")
        setupSnapshot(app)
        app.launch()
        
        device = XCUIDevice.shared
        if landscape {
            device.orientation = UIDeviceOrientation.landscapeLeft
        } else {
            device.orientation = UIDeviceOrientation.portrait
        }
    }
    
    func startApp(
        _ startTime: Int,
        landscape: Bool = false,
        accessibility: Bool = true,
        forceShowTime: Bool = false
        ) {
        var arguments: [String] = ["--starttime", String(startTime)]
        if accessibility {
            arguments.append("--accessibility")
        }
        if forceShowTime {
            arguments.append("--forceshowtime")
        }
        startAppWithArguments(arguments, landscape: landscape)
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

    let speechGroup = "Toastmasters"
    let speechTitle = "Speech: Five to Seven Minutes"
    
    func openSpeech() {
        // Wait until the defaults are loaded
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists,
                    evaluatedWith: app.staticTexts[speechGroup], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Open the profile
        app.tables.staticTexts[speechGroup].tap()
        
        expectation(for: exists,
                    evaluatedWith: app.staticTexts[speechTitle],
                                handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
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
