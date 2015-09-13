//
//  SpeechTimer.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/13/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

public class SpeechTimer : NSObject {
    
    var delegate : SpeechTimerDelegate?;
    var state : SpeechState
    
    // Timers for tracking state changes
    var phaseTimers : [SpeechPhase : NSTimer]
    
    init(withProfile profile : Profile){
        state = SpeechState(profile: SpeechProfileFactory.SpeechProfileWithProfile(profile))
        phaseTimers = [:]
    }
    
    /**
        Start this timer.

        If this timer was previously paused, start from the interval at which it was paused.
    */
    func start(){
        
        if(state.running != SpeechRunning.RUNNING){
            NSLog("Starting, pause interval = %g", self.state.pauseInterval)
            
            for p : SpeechPhase in SpeechPhase.allCases {
                let timeUntil : NSTimeInterval = state.timeUntil(p)
                if(timeUntil > 0){
                    phaseTimers[p] = NSTimer.scheduledTimerWithTimeInterval(timeUntil + 0.1, target: self, selector: "phaseChange:", userInfo: nil, repeats: false);
                    phaseTimers[p]?.tolerance = 0.05
                }
            }

            self.state.startTime = NSDate();
            setRunning(SpeechRunning.RUNNING)
        }
    }
    
    /**
        Pause this timer.
    
        If the timer is not running, does nothing.
    
        When start() is next called, the timer will resume from the time at which it was paused.
    */
    func pause(){
        
        if(state.running == SpeechRunning.RUNNING){
            self.state.pauseInterval = self.state.pauseInterval + NSDate().timeIntervalSinceDate(self.state.startTime!);
            
            NSLog("Pausing with interval %g", self.state.pauseInterval);
            
            for p : SpeechPhase in phaseTimers.keys {
                let t : NSTimer = phaseTimers[p]!
                t.invalidate()
            }
            setRunning(SpeechRunning.PAUSED)
        }
    }
    
    /**
        Stop this timer.
    
        If the timer is not running, does nothing.
    
        When start() is next called, the timer will start from zero.
    */
    func stop(){
        if(state.running != SpeechRunning.STOPPED){
            NSLog("Stopping");
            setRunning(SpeechRunning.STOPPED)

            for p : SpeechPhase in phaseTimers.keys {
                let t : NSTimer = phaseTimers[p]!
                t.invalidate()
            }
            
            // Reset the timer
            self.state.pauseInterval = 0;
            self.state.startTime = nil;
        }
    }
    
    private func setRunning(running : SpeechRunning){
        state = SpeechState(profile: self.state.profile, running: running, startTime: self.state.startTime, pauseInterval: self.state.pauseInterval)
        delegate?.runningChanged(self.state, timer: self)
    }
    
    func phaseChange(timer: NSTimer!){
        delegate?.phaseChanged(state, timer: self)
    }
    
    func elapsed() -> NSTimeInterval {
        if let s : NSDate = self.state.startTime {
            return self.state.pauseInterval + NSDate().timeIntervalSinceDate(s)
        } else {
            return self.state.pauseInterval
        }
    }
    
}

protocol SpeechTimerDelegate {

    func phaseChanged(state: SpeechState, timer: SpeechTimer)
    func runningChanged(state: SpeechState, timer: SpeechTimer)
    
}

