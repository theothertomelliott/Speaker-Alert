//
//  ProfileEditorTests.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/10/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import XCTest

class ProfileEditorTests: XCTestCase {

    func testInOrderCheckSuccess() {
        let profileEditor: ProfileTableViewController = ProfileTableViewController()
        profileEditor.phaseTimes[SpeechPhase.green] = 1
        profileEditor.phaseTimes[SpeechPhase.yellow] = 2
        profileEditor.phaseTimes[SpeechPhase.red] = 3
        profileEditor.phaseTimes[SpeechPhase.over_MAXIMUM] = 4
        
        XCTAssertTrue(profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.green] = 5
        profileEditor.phaseTimes[SpeechPhase.yellow] = 5
        profileEditor.phaseTimes[SpeechPhase.red] = 5
        profileEditor.phaseTimes[SpeechPhase.over_MAXIMUM] = 5
        
        XCTAssertTrue(profileEditor.phasesInOrder())
    }
    
    func testInOrderCheckFail() {
        let profileEditor: ProfileTableViewController = ProfileTableViewController()
    
        profileEditor.phaseTimes[SpeechPhase.green] = 5
        profileEditor.phaseTimes[SpeechPhase.yellow] = 0
        profileEditor.phaseTimes[SpeechPhase.red] = 0
        profileEditor.phaseTimes[SpeechPhase.over_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.green] = 5
        profileEditor.phaseTimes[SpeechPhase.yellow] = 0
        profileEditor.phaseTimes[SpeechPhase.red] = 0
        profileEditor.phaseTimes[SpeechPhase.over_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.green] = 0
        profileEditor.phaseTimes[SpeechPhase.yellow] = 6
        profileEditor.phaseTimes[SpeechPhase.red] = 0
        profileEditor.phaseTimes[SpeechPhase.over_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.green] = 0
        profileEditor.phaseTimes[SpeechPhase.yellow] = 0
        profileEditor.phaseTimes[SpeechPhase.red] = 7
        profileEditor.phaseTimes[SpeechPhase.over_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
    }
    
}
