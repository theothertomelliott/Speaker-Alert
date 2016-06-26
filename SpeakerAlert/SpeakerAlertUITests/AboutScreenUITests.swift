//
//  AboutScreenUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/9/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class AboutScreenUITests: SpeakerAlertUITests {

    override func setUp() {
        super.setUp()
        startApp(isLandscape(), startTime: startTimeOffset())
    }
    
    func testLoadAboutScreen() {
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Settings"].tap()
        app.tables.staticTexts["About Speaker Alert"].tap()
        app.navigationBars["About"].buttons["Settings"].tap()
        tabBarsQuery.buttons["Speech"].tap()
    }

}
