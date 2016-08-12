//
//  ConfigurationManagerTests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/6/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class ConfigurationManagerTests: XCTestCase {

    var defaults: NSUserDefaults?
    let suite = "speakerAlertTestSuite"
    
    override func setUp() {
        super.setUp()
        defaults = NSUserDefaults(suiteName: suite)
        clearDefaults()
    }
    
    override func tearDown() {
        super.tearDown()
        clearDefaults()
    }
    
    func clearDefaults() {
        for key in (defaults?.dictionaryRepresentation().keys)! {
            defaults?.removeObjectForKey(key)
        }
        defaults?.synchronize()
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
            "Practice",
            "Expected practice as default mode"
        )
        
        cfgMan.timeDisplayMode = TimeDisplay.None
        cfgMan.isVibrationEnabled = false
        XCTAssertEqual(
            cfgMan.currentPreset()?.name,
            "Meeting",
            "Expected meeting as mode"
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
