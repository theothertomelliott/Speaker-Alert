//
//  SpeakerAlertUITests.swift
//  SpeakerAlertUITests
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import XCTest

class SpeakerAlertUITests: XCTestCase {

    var app: XCUIApplication!

	override func setUp() {
		super.setUp()
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		// UI tests must launch the application that they test.
		// Doing this in setup will make sure it happens for each test method.
		app = XCUIApplication()
		app.launchArguments = ["isUITesting"]
		setupSnapshot(app)
		app.launch()
	}

	override func tearDown() {
		super.tearDown()
	}

}
