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
