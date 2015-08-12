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
    
    static func fromDictionary(dict : [String : AnyObject]) -> SpeechState {
        
        let r : Int = dict["running"] as! Int
        let p : Int = dict["phase"] as! Int
        
        var running : SpeechRunning = SpeechRunning.STOPPED
        if(r == SpeechRunning.PAUSED.hashValue){
            running = SpeechRunning.PAUSED
        }
        if(r == SpeechRunning.RUNNING.hashValue){
            running = SpeechRunning.RUNNING
        }
        
        var phase : SpeechPhase = SpeechPhase.BELOW_MINIMUM
        if(p == SpeechPhase.GREEN.hashValue){
            phase = SpeechPhase.GREEN
        }
        if(p == SpeechPhase.YELLOW.hashValue){
            phase = SpeechPhase.YELLOW
        }
        if(p == SpeechPhase.RED.hashValue){
            phase = SpeechPhase.RED
        }
        if(p == SpeechPhase.OVER_MAXIMUM.hashValue){
            phase = SpeechPhase.OVER_MAXIMUM
        }
        
        return SpeechState(running: running, phase: phase, elapsed: dict["elapsed"] as! NSTimeInterval)
    }
    
    func toDictionary() -> [String : AnyObject] {
        return [
            "elapsed" : self.elapsed,
            "phase" : self.phase.hashValue,
            "running" : self.running.hashValue
        ]
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