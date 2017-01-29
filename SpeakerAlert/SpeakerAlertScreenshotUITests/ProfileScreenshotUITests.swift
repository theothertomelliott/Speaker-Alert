//
//  ProfileScreenshotUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 11/27/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class ProfileScreenshotUITests: SpeakerAlertUITests {
        
    func testLoadProfileAndReturn() {
        
        // Wait until the defaults are loaded
        let label = app.staticTexts["Five Minutes"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // TODO: Base this off the seed data
        XCTAssertEqual(app.tables.cells.count, 7)
        
        // Open the profile
        app.tables.staticTexts["Five Minutes"].tap()
        
        // Hit the back button
        app.navigationBars["Five Minutes"].buttons["Profiles"].tap()
        
        XCTAssertEqual(app.tables.cells.count, 7)
        
        snapshot("001 Profile list", waitForLoadingIndicator: false)
    }
    
}
