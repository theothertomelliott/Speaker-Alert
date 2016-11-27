//
//  HistoryUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/1/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class HistoryUITests: SpeakerAlertUITests {
    
    func testSaveSpeech() {
        
        startApp(3)
        openSpeech()
        startSpeech()
        stopSpeech()
        
        app.tables.textFields["Speech Description"].tap()
        app.tables.textFields["Speech Description"].typeText("test speech")
        app.toolbars.buttons["Done"].tap()
        
        app.tabBars.buttons["History"].tap()
        XCTAssertEqual(app.tables.cells.count, 1)
        XCTAssert(app.staticTexts["test speech"].exists)
        // TODO: Determine the time that this stopped at and pass that on
        // XCTAssert(app.staticTexts["0:03"].exists || app.staticTexts["0:04"].exists)
    }

}
