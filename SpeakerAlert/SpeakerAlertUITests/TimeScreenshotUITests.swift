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
    
    func testBeforeStarting() {
        startApp(0, landscape: false, accessibility: false)
        openSpeech()
        snapshot("005 - Before starting", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("Before starting - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testTimerGreen() {
        startApp(300, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Green"].exists)
        snapshot("002 - Timer green", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("Timer green - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testTimerYellow() {
        startApp(360, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Yellow"].exists)
        snapshot("Timer yellow", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("003 - Timer yellow - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testTimerRed() {
        startApp(420, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Red"].exists)
        snapshot("Timer red", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.LandscapeLeft
        snapshot("Timer red - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.Portrait
    }
    
    func testStopSpeech() {
        startApp(430, landscape: false, accessibility: false)
        
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
