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
    var profile : Profile
    var phase : SpeechPhase
    var elapsed : NSTimeInterval {
        get {
            if let s : NSDate = startTime {
                return pauseInterval + NSDate().timeIntervalSinceDate(s)
            } else {
                return pauseInterval
            }
        }
    }
    
    //
    var startTime : NSDate?
    var pauseInterval : NSTimeInterval
    
    init(profile: Profile){
        self.profile = profile
        running = SpeechRunning.STOPPED
        phase = SpeechPhase.BELOW_MINIMUM
        pauseInterval = 0
    }
    
    init(profile: Profile, running: SpeechRunning, phase : SpeechPhase, startTime : NSDate?, pauseInterval : NSTimeInterval?){
        self.profile = profile
        self.running = running
        self.phase = phase
        self.startTime = startTime
        if let p = pauseInterval {
            self.pauseInterval = p
        } else {
            self.pauseInterval = 0
        }
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
        
        // TODO: Parse profile from dictionary
        let profile : Profile = Profile()
//        let profileDict : [String : AnyObject] = (dict["profile"] as? [String : AnyObject])!
//        profile.green = profileDict["green"] as? NSTimeInterval
//        profile.yellow = profileDict["yellow"] as? NSTimeInterval
//        profile.red = profileDict["red"] as? NSTimeInterval
//        profile.redBlink = profileDict["redBlink"] as? NSTimeInterval
        
        return SpeechState(profile: profile, running: running, phase: phase, startTime: dict["startTime"] as? NSDate, pauseInterval: dict["pauseInterval"] as? NSTimeInterval)
    }
    
    func toDictionary() -> [String : AnyObject] {
        // TODO: Write profile into dictionary
        return [
//            "profile" : [
//                "green" : profile.green!,
//                "yellow" : profile.yellow!,
//                "red" : profile.red!,
//                "redBlink" : profile.redBlink!
//            ],
            "phase" : self.phase.hashValue,
            "running" : self.running.hashValue,
            "pauseInterval" : self.pauseInterval,
            "startTime" : self.startTime!
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