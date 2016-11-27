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
        startApp(startTime: 0, landscape: false, accessibility: false)
        openSpeech()
        snapshot(name: "005 - Before starting", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.landscapeLeft
        snapshot(name: "Before starting - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.portrait
    }
    
    func testTimerGreen() {
        startApp(startTime: 300, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Green"].exists)
        snapshot(name: "002 - Timer green", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.landscapeLeft
        snapshot(name: "Timer green - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.portrait
    }
    
    func testTimerYellow() {
        startApp(startTime: 360, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Yellow"].exists)
        snapshot(name: "Timer yellow", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.landscapeLeft
        snapshot(name: "003 - Timer yellow - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.portrait
    }
    
    func testTimerRed() {
        startApp(startTime: 420, landscape: false, accessibility: false)
        openSpeech()
        startSpeech()
        XCTAssert(!app.staticTexts["Red"].exists)
        snapshot(name: "Timer red", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.landscapeLeft
        snapshot(name: "Timer red - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.portrait
    }
    
    func testStopSpeech() {
        startApp(startTime: 430, landscape: false, accessibility: false)
        
        openSpeech()
        startSpeech()
        stopSpeech()
        
        waitForElement(element: app.staticTexts["Speech Complete"])
        
        snapshot(name: "004 - After stopping", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.landscapeLeft
        snapshot(name: "After stopping - Landscape", waitForLoadingIndicator: false)
        device.orientation = UIDeviceOrientation.portrait
    }
    
}
