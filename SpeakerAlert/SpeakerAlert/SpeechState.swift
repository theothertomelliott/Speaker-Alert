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

    var running: SpeechRunning
    var profile: SpeechProfile
    var phase: SpeechPhase {
        get {
            var phase: SpeechPhase = SpeechPhase.below_MINIMUM
            if elapsed >= profile.green {
                phase = SpeechPhase.green
            }
            if elapsed >= profile.yellow {
                phase = SpeechPhase.yellow
            }
            if elapsed >= profile.red {
                phase = SpeechPhase.red
            }
            if elapsed >= profile.redBlink {
                phase = SpeechPhase.over_MAXIMUM
            }
            return phase
        }
    }
    
    var initialStart: Date?

    func timeUntil(_ phase: SpeechPhase) -> TimeInterval {
        var targetElapsed: TimeInterval = 0
        switch phase {
        case SpeechPhase.green:
            targetElapsed = self.profile.green
        case SpeechPhase.yellow:
            targetElapsed = self.profile.yellow
        case SpeechPhase.red:
            targetElapsed = self.profile.red
        case SpeechPhase.over_MAXIMUM:
            targetElapsed = self.profile.redBlink
        default:
            targetElapsed = 0
        }
        let e: NSInteger = Int(elapsed)
        return targetElapsed - Double(e)
    }


    var elapsed: TimeInterval {
        get {
            if let s: Date = startTime {
                return pauseInterval + Date().timeIntervalSince(s)
            } else {
                return pauseInterval
            }
        }
    }

    //
    var startTime: Date?
    var pauseInterval: TimeInterval

    init(profile: SpeechProfile) {
        self.profile = profile
        running = SpeechRunning.stopped
        pauseInterval = 0
    }

    init(profile: SpeechProfile,
        running: SpeechRunning,
        startTime: Date?,
        initialStartTime: Date?,
        pauseInterval: TimeInterval?) {
        self.profile = profile
        self.running = running
        self.initialStart = initialStartTime
        if running == SpeechRunning.running {
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

    static func fromDictionary(_ dict: [String : Any]) -> SpeechState? {

        if let profileDict: [String : Any] = dict["profile"] as? [String : Any],
            let r: Int = dict["running"] as? Int {

            var running: SpeechRunning = SpeechRunning.stopped
            if r == SpeechRunning.paused.hashValue {
                running = SpeechRunning.paused
            }
            if r == SpeechRunning.running.hashValue {
                running = SpeechRunning.running
            }

            // Parse profile from dictionary
            let green: TimeInterval = (profileDict["green"] as? TimeInterval)!
            let yellow: TimeInterval  = (profileDict["yellow"] as? TimeInterval)!
            let red: TimeInterval  = (profileDict["red"] as? TimeInterval)!
            let redBlink: TimeInterval = (profileDict["redBlink"] as? TimeInterval)!

            let profile: SpeechProfile = SpeechProfile(
                green: green,
                yellow: yellow,
                red: red,
                redBlink: redBlink)
            return SpeechState(
                profile: profile,
                running: running,
                startTime: dict["startTime"] as? Date,
                initialStartTime: dict["initialStart"] as? Date,
                pauseInterval: dict["pauseInterval"] as? TimeInterval)

        }

        return nil
    }

    func toDictionary() -> [String : Any] {
        var dict: [String : Any] = [
            "profile" : [
                "green" : profile.green,
                "yellow" : profile.yellow,
                "red" : profile.red,
                "redBlink" : profile.redBlink
            ],
            "running" : self.running.hashValue,
            "pauseInterval" : self.pauseInterval,
        ]

        if let s: Date = self.initialStart {
            dict["initialStart"] = s
        }
        
        if let s: Date = self.startTime {
            dict["startTime"] = s
        }

        return dict
    }

}

enum SpeechRunning {
    case running
    case stopped
    case paused
}

enum SpeechPhase {
    case below_MINIMUM
    case green
    case yellow
    case red
    case over_MAXIMUM // Speaker has gone significantly over time

    static var allCases: [SpeechPhase] = [.below_MINIMUM, .green, .yellow, .red, .over_MAXIMUM]

    static var name: [SpeechPhase : String] = [
        .below_MINIMUM : "Below Minimum Time",
        .green : "Green",
        .yellow : "Yellow",
        .red : "Red",
        .over_MAXIMUM : "Over Maximum"
    ]
}
