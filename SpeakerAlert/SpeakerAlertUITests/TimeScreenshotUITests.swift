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
    
    func testScreenshotHistory() {
        startAppWithArguments(["--populatemeeting"])
        app.tabBars.buttons["History"].tap()
        snapshot("003 - History", waitForLoadingIndicator: false)
    }
    
//    func testBeforeStarting() {
//        startApp(startTime: 0, landscape: false, accessibility: false)
//        openSpeech()
//        snapshot(name: "Before starting", waitForLoadingIndicator: false)
//    }
    
    func testTimerGreen() {
        startApp(300, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Green"].exists)
        snapshot("002 - Timer green", waitForLoadingIndicator: false)
    }
    
    func testTimerYellow() {
        startApp(360, landscape: true, accessibility: false, forceShowTime: true)
        openSpeech()
        startSpeech()
        snapshot("003 - Timer yellow with time - Landscape", waitForLoadingIndicator: false)
    }
    
//    func testTimerRed() {
//        startApp(startTime: 420, landscape: false, accessibility: false)
//        openSpeech()
//        startSpeech()
//        XCTAssert(!app.staticTexts["Red"].exists)
//        snapshot(name: "Timer red", waitForLoadingIndicator: false)
//        device.orientation = UIDeviceOrientation.landscapeLeft
//        snapshot(name: "Timer red - Landscape", waitForLoadingIndicator: false)
//        device.orientation = UIDeviceOrientation.portrait
//    }
//    
//    func testStopSpeech() {
//        startApp(startTime: 430, landscape: false, accessibility: false)
//        
//        openSpeech()
//        startSpeech()
//        stopSpeech()
//        
//        waitForElement(element: app.staticTexts["Speech Complete"])
//        
//        snapshot(name: "After stopping", waitForLoadingIndicator: false)
//        device.orientation = UIDeviceOrientation.landscapeLeft
//        snapshot(name: "After stopping - Landscape", waitForLoadingIndicator: false)
//        device.orientation = UIDeviceOrientation.portrait
//    }
    
}
