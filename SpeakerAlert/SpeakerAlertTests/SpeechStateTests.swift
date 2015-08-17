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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testItSerializesCorrectly() {
        
        let profile : SpeechProfile = SpeechProfile(green: 1, yellow: 2, red: 3, redBlink: 4)
        let state : SpeechState = SpeechState(profile: profile)
        let dict : [String : AnyObject] = state.toDictionary()
        
        if let profileRetrieved : [String : AnyObject] = dict["profile"] as? [String : AnyObject] {
            XCTAssert(profileRetrieved["green"] as? Int == 1);
            XCTAssert(profileRetrieved["yellow"] as? Int == 2);
            XCTAssert(profileRetrieved["red"] as? Int == 3);
            XCTAssert(profileRetrieved["redBlink"] as? Int == 4);
        } else {
            XCTFail("No profile obtained")
        }
        
    }
    
    func testItDeserializesCorrectly() {
        
        let profile : SpeechProfile = SpeechProfile(green: 1, yellow: 2, red: 3, redBlink: 4)
        let state : SpeechState = SpeechState(profile: profile)
        let dict : [String : AnyObject] = state.toDictionary()
        
        let stateRetrieved : SpeechState = SpeechState.fromDictionary(dict)
        
        XCTAssert(stateRetrieved.profile.green == 1)
        XCTAssert(stateRetrieved.profile.yellow == 2)
        XCTAssert(stateRetrieved.profile.red == 3)
        XCTAssert(stateRetrieved.profile.redBlink == 4)
        
    }

}
