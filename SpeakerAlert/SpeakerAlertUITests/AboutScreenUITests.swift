//
//  AboutScreenUITests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/9/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class AboutScreenUITests: SpeakerAlertUITests {

    func testLoadAboutScreen() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Vibration Alerts"]/*[[".cells.staticTexts[\"Vibration Alerts\"]",".staticTexts[\"Vibration Alerts\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["About Speaker Alert"]/*[[".cells.staticTexts[\"About Speaker Alert\"]",".staticTexts[\"About Speaker Alert\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let speakerAlertMakesUseOfTheFollowingThirdPartyLibrariesManyThanksToTheDevelopersMakingThemAvailableElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Speaker Alert makes use of the following third party libraries. Many thanks to the developers making them available!").element
        speakerAlertMakesUseOfTheFollowingThirdPartyLibrariesManyThanksToTheDevelopersMakingThemAvailableElement.swipeUp()
        speakerAlertMakesUseOfTheFollowingThirdPartyLibrariesManyThanksToTheDevelopersMakingThemAvailableElement.swipeDown()
    }
    
    

}
