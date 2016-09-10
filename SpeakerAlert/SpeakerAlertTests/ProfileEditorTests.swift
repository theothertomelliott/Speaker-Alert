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
        profileEditor.phaseTimes[SpeechPhase.GREEN] = 1
        profileEditor.phaseTimes[SpeechPhase.YELLOW] = 2
        profileEditor.phaseTimes[SpeechPhase.RED] = 3
        profileEditor.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 4
        
        XCTAssertTrue(profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.GREEN] = 5
        profileEditor.phaseTimes[SpeechPhase.YELLOW] = 5
        profileEditor.phaseTimes[SpeechPhase.RED] = 5
        profileEditor.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 5
        
        XCTAssertTrue(profileEditor.phasesInOrder())
    }
    
    func testInOrderCheckFail() {
        let profileEditor: ProfileTableViewController = ProfileTableViewController()
    
        profileEditor.phaseTimes[SpeechPhase.GREEN] = 5
        profileEditor.phaseTimes[SpeechPhase.YELLOW] = 0
        profileEditor.phaseTimes[SpeechPhase.RED] = 0
        profileEditor.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.GREEN] = 5
        profileEditor.phaseTimes[SpeechPhase.YELLOW] = 0
        profileEditor.phaseTimes[SpeechPhase.RED] = 0
        profileEditor.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.GREEN] = 0
        profileEditor.phaseTimes[SpeechPhase.YELLOW] = 6
        profileEditor.phaseTimes[SpeechPhase.RED] = 0
        profileEditor.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
        
        profileEditor.phaseTimes[SpeechPhase.GREEN] = 0
        profileEditor.phaseTimes[SpeechPhase.YELLOW] = 0
        profileEditor.phaseTimes[SpeechPhase.RED] = 7
        profileEditor.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 0
        
        XCTAssertTrue(!profileEditor.phasesInOrder())
    }
    
}
