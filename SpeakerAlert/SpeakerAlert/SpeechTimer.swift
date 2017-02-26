//
//  SpeechTimer.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/13/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

open class SpeechTimer: NSObject {

    var delegate: SpeechTimerDelegate?
    var state: SpeechState

    // Timers for tracking state changes
    var phaseTimers: [SpeechPhase : Timer]

    init(withProfile profile: Profile) {
        state = SpeechState(profile: SpeechProfileFactory.SpeechProfileWithProfile(profile))
        phaseTimers = [:]
    }
    
    func setInterval(_ interval: TimeInterval) {
        state.pauseInterval = interval
    }

    /**
        Start this timer.

        If this timer was previously paused, start from the interval at which it was paused.
    */
    func start() {

        if state.running != SpeechRunning.running {
            NSLog("Starting, pause interval = %g", self.state.pauseInterval)

            for p: SpeechPhase in SpeechPhase.allCases {
                let timeUntil: TimeInterval = state.timeUntil(p)
                if timeUntil > 0 {
                    phaseTimers[p] = Timer.scheduledTimer(
                        timeInterval: timeUntil + 0.1,
                        target: self,
                        selector: #selector(SpeechTimer.phaseChange(_:)),
                        userInfo: nil,
                        repeats: false)
                    phaseTimers[p]?.tolerance = 0.05
                }
            }

            self.state.startTime = Date()
            
            if state.running == SpeechRunning.stopped {
                self.state.initialStart = Date()
            }
            
            setRunning(SpeechRunning.running)
        }
    }

    /**
        Pause this timer.

        If the timer is not running, does nothing.

        When start() is next called, the timer will resume from the time at which it was paused.
    */
    func pause() {

        if state.running == SpeechRunning.running {
            self.state.pauseInterval = self.state.pauseInterval +
                Date().timeIntervalSince(self.state.startTime!)

            NSLog("Pausing with interval %g", self.state.pauseInterval)

            for p: SpeechPhase in phaseTimers.keys {
                let t: Timer = phaseTimers[p]!
                t.invalidate()
            }
            setRunning(SpeechRunning.paused)
        }
    }
    
    /**
     Reset this timer to zero.
     Returns the timer to the same state as immediately after initialization.
     */
    func reset() {
        let oldRunning = state.running
        for p: SpeechPhase in SpeechPhase.allCases {
            phaseTimers[p]?.invalidate()
        }
        state = SpeechState(profile: state.profile)
        phaseTimers = [:]
        setRunning(oldRunning)
    }

    /**
        Stop this timer.

        If the timer is not running, does nothing.

        When start() is next called, the timer will start from zero.
    */
    func stop() {
        if state.running != SpeechRunning.stopped {
            NSLog("Stopping")
            setRunning(SpeechRunning.stopped)

            for p: SpeechPhase in phaseTimers.keys {
                let t: Timer = phaseTimers[p]!
                t.invalidate()
            }

            // Reset the timer
            self.state.pauseInterval = 0
            self.state.startTime = nil
        }
    }

    fileprivate func setRunning(_ running: SpeechRunning) {
        state = SpeechState(
            profile: self.state.profile,
            running: running,
            startTime: self.state.startTime,
            initialStartTime: self.state.initialStart,
            pauseInterval: self.state.pauseInterval)
        delegate?.runningChanged(self.state, timer: self)
    }

    func phaseChange(_ timer: Timer!) {
        delegate?.phaseChanged(state, timer: self)
    }

    func elapsed() -> TimeInterval {
        if let s: Date = self.state.startTime {
            return self.state.pauseInterval + Date().timeIntervalSince(s)
        } else {
            return self.state.pauseInterval
        }
    }

}

protocol SpeechTimerDelegate {

    func phaseChanged(_ state: SpeechState, timer: SpeechTimer)
    func runningChanged(_ state: SpeechState, timer: SpeechTimer)

}
