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
    var profile : SpeechProfile
    var phase : SpeechPhase {
        get {
            var phase : SpeechPhase = SpeechPhase.BELOW_MINIMUM
            if(elapsed >= profile.green){
                phase = SpeechPhase.GREEN
            }
            if(elapsed >= profile.yellow){
                phase = SpeechPhase.YELLOW
            }
            if(elapsed >= profile.red){
                phase = SpeechPhase.RED
            }
            if(elapsed >= profile.redBlink){
                phase = SpeechPhase.OVER_MAXIMUM
            }
            return phase
        }
    }
    

    func timeUntil(phase: SpeechPhase) -> NSTimeInterval {
        var targetElapsed : NSTimeInterval = 0
        switch phase {
        case SpeechPhase.GREEN:
            targetElapsed = self.profile.green
        case SpeechPhase.YELLOW:
            targetElapsed = self.profile.yellow
        case SpeechPhase.RED:
            targetElapsed = self.profile.red
        case SpeechPhase.OVER_MAXIMUM:
            targetElapsed = self.profile.redBlink
        default:
            targetElapsed = 0
        }
        let e : NSTimeInterval = elapsed
        return targetElapsed - e
    }
    
    
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
    
    init(profile: SpeechProfile){
        self.profile = profile
        running = SpeechRunning.STOPPED
        pauseInterval = 0
    }
    
    init(profile: SpeechProfile, running: SpeechRunning, startTime : NSDate?, pauseInterval : NSTimeInterval?){
        self.profile = profile
        self.running = running
        if(running == SpeechRunning.RUNNING){
            self.startTime = startTime
        } else {
            self.startTime = nil
        }
        if let p = pauseInterval {
            self.pauseInterval = p
        } else {
            self.pauseInterval = 0
        }
    }
    
    static func fromDictionary(dict : [String : AnyObject]) -> SpeechState {
        
        let r : Int = dict["running"] as! Int
        
        var running : SpeechRunning = SpeechRunning.STOPPED
        if(r == SpeechRunning.PAUSED.hashValue){
            running = SpeechRunning.PAUSED
        }
        if(r == SpeechRunning.RUNNING.hashValue){
            running = SpeechRunning.RUNNING
        }
        
        // Parse profile from dictionary
        let profileDict : [String : AnyObject] = (dict["profile"] as? [String : AnyObject])!
        let green : NSTimeInterval = (profileDict["green"] as? NSTimeInterval)!
        let yellow : NSTimeInterval  = (profileDict["yellow"] as? NSTimeInterval)!
        let red : NSTimeInterval  = (profileDict["red"] as? NSTimeInterval)!
        let redBlink : NSTimeInterval = (profileDict["redBlink"] as? NSTimeInterval)!
        
        let profile : SpeechProfile = SpeechProfile(green: green, yellow: yellow, red: red, redBlink: redBlink)
        return SpeechState(profile: profile, running: running, startTime: dict["startTime"] as? NSDate, pauseInterval: dict["pauseInterval"] as? NSTimeInterval)
    }
    
    func toDictionary() -> [String : AnyObject] {
        var dict : [String : AnyObject] = [
            "profile" : [
                "green" : profile.green,
                "yellow" : profile.yellow,
                "red" : profile.red,
                "redBlink" : profile.redBlink
            ],
            "running" : self.running.hashValue,
            "pauseInterval" : self.pauseInterval
        ]

        if let s : NSDate = self.startTime {
            dict["startTime"] = s
        }
        
        return dict
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
    
    static var allCases: [SpeechPhase] = [.BELOW_MINIMUM, .GREEN, .YELLOW, .RED, .OVER_MAXIMUM]
}