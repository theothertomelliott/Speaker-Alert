//
//  SpeechState.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/28/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

/**
 * Immutable class representing the current state of a speech
*/
class SpeechState {

    var running : SpeechRunning
    var phase : SpeechPhase
    var elapsed : NSTimeInterval
    
    init(){
        running = SpeechRunning.STOPPED
        phase = SpeechPhase.BELOW_MINIMUM
        elapsed = 0
    }
    
    init(running: SpeechRunning, phase : SpeechPhase, elapsed : NSTimeInterval){
        self.running = running;
        self.phase = phase;
        self.elapsed = elapsed
    }

}

enum SpeechRunning {
    case RUNNING
    case STOPPED
    case PAUSED
}

enum SpeechPhase {
    case BELOW_MINIMUM
    case GREEN
    case YELLOW
    case RED
    case OVER_MAXIMUM // Speaker has gone significantly over time
}