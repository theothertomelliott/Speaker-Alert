//
//  SpeechCompleteUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/11/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class SpeechCompleteUITests: SpeakerAlertUITests {
    
    // Check that pressing the back button from the speech complete view doesn't skip to the root
    func testBackButton() {
        openSpeech()
        startSpeech()
        stopSpeech()
        
        expectation(
            for: NSPredicate(format: "exists == 1"),
            evaluatedWith: app.navigationBars.buttons["Toastmasters"],
            handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        app.navigationBars.buttons["Toastmasters"].tap()
        
        expectation(
            for: NSPredicate(format: "exists == 1"),
            evaluatedWith: app.navigationBars["Toastmasters"],
            handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // Check that viewing the history automatically dismisses the speech complete dialog
    func testDismissedOnSwitchingToHistory() {
        openSpeech()
        startSpeech()
        stopSpeech()
        
        app.tabBars.buttons["History"].tap()
        expectation(
            for: NSPredicate(format: "exists == 1"),
            evaluatedWith: app.navigationBars["Speech History"],
            handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        
        app.tabBars.buttons["Speech"].tap()
        expectation(
            for: NSPredicate(format: "exists == 1"),
            evaluatedWith: app.navigationBars["Toastmasters"],
            handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}
