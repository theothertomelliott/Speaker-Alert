//
//  ConfigurationManagerTests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/6/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class ConfigurationManagerTests: XCTestCase {

    var defaults: UserDefaults?
    let suite = "speakerAlertTestSuite"
    
    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suite)
        defaults?.clear()
    }
    
    override func tearDown() {
        super.tearDown()
        defaults?.clear()
    }
    
    func testItAppliesDefaultPreset() {
        guard let _ = defaults else {
            XCTFail("Defaults not set up")
            return
        }
        let cfgMan = ConfigurationManager(defaults: defaults!)
        XCTAssertTrue(cfgMan == cfgMan.defaultConfiguration, "Default was not applied as expected")
    }
    
    func testItFindsModes() {
        guard let _ = defaults else {
            XCTFail("Defaults not set up")
            return
        }
        let cfgMan = ConfigurationManager(defaults: defaults!)
        XCTAssertEqual(
            cfgMan.currentPreset()?.name,
            "Meeting",
            "Expected meeting as default mode"
        )
        
        cfgMan.timeDisplayMode = TimeDisplay.CountUp
        cfgMan.isVibrationEnabled = true
        cfgMan.areNotificationsEnabled = true
        XCTAssertEqual(
            cfgMan.currentPreset()?.name,
            "Practice",
            "Expected practice as mode"
        )
    }
    
    func testItFindsNilModes() {
        guard let _ = defaults else {
            XCTFail("Defaults not set up")
            return
        }
        let cfgMan = ConfigurationManager(defaults: defaults!)
        cfgMan.isAudioEnabled = true
        
        if let _ = cfgMan.currentPreset() {
            XCTFail("Should not have found preset")
        }
    }
    
    func testItAppliesModes() {
        guard let _ = defaults else {
            XCTFail("Defaults not set up")
            return
        }
        let cfgMan = ConfigurationManager(defaults: defaults!)
        let contest = cfgMan.findPreset("Contest")
        guard let _ = contest else {
            XCTFail("Contest preset not found")
            return
        }
        
        cfgMan.applyPreset(contest!)
        XCTAssertTrue(cfgMan == contest!, "Preset was not applied as expected")
        
    }
    
    
}
