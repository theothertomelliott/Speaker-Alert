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
        
        waitForElement(app.navigationBars.buttons["Toastmasters"])
        app.navigationBars.buttons["Toastmasters"].tap()
        
        waitForElement(app.navigationBars["Toastmasters"])
    }
    
    // Check that viewing the history automatically dismisses the speech complete dialog
    func testDismissedOnSwitchingToHistory() {
        openSpeech()
        startSpeech()
        stopSpeech()
        
        app.tabBars.buttons["History"].tap()
        waitForElement(app.navigationBars["Speech History"])
        
        app.tabBars.buttons["Speech"].tap()
        waitForElement(app.navigationBars["Toastmasters"])
    }
    
}
