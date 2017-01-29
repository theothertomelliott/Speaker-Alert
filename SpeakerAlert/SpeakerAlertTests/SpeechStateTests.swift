//
//  SpeechStateTests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/16/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import XCTest

class SpeechStateTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testItSerializesCorrectly() {

        let profile: SpeechProfile = SpeechProfile(green: 1, yellow: 2, red: 3, redBlink: 4)
        let startTime: Date = Date()
        let pauseInterval: TimeInterval = 5
        let state: SpeechState = SpeechState(
            profile: profile,
            running: SpeechRunning.running,
            startTime: startTime,
            initialStartTime: startTime,
            pauseInterval: pauseInterval)
        let dict: [String : Any] = state.toDictionary()

        if let interval = dict["pauseInterval"] as? TimeInterval {
            XCTAssert(interval == 5)
        } else {
            XCTFail("pauseInterval was not a time interval object")
        }

        if let profileRetrieved: [String : Any] = dict["profile"] as? [String : Any] {
            XCTAssert(profileRetrieved["green"] as? TimeInterval == 1)
            XCTAssert(profileRetrieved["yellow"] as? TimeInterval == 2)
            XCTAssert(profileRetrieved["red"] as? TimeInterval == 3)
            XCTAssert(profileRetrieved["redBlink"] as? TimeInterval == 4)
        } else {
            XCTFail("No profile obtained")
        }

    }

    func testItDeserializesCorrectly() {

        let profile: SpeechProfile = SpeechProfile(green: 1, yellow: 2, red: 3, redBlink: 4)
        let startTime: Date = Date()
        let pauseInterval: TimeInterval = 5
        let state: SpeechState = SpeechState(
            profile: profile,
            running: SpeechRunning.running,
            startTime: startTime,
            initialStartTime: startTime,
            pauseInterval: pauseInterval)
        let dict: [String : Any] = state.toDictionary()

        let stateRetrieved: SpeechState = SpeechState.fromDictionary(dict)!

        XCTAssert(stateRetrieved.profile.green == 1)
        XCTAssert(stateRetrieved.profile.yellow == 2)
        XCTAssert(stateRetrieved.profile.red == 3)
        XCTAssert(stateRetrieved.profile.redBlink == 4)
        XCTAssert(stateRetrieved.pauseInterval == 5)
        XCTAssert(stateRetrieved.phase == SpeechPhase.over_MAXIMUM)
        XCTAssert(stateRetrieved.running == SpeechRunning.running)

    }

}
