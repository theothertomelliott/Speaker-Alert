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
    
    private func setRunning(running : SpeechRunning){
        state = SpeechState(profile: self.state.profile, running: running, startTime: self.state.startTime, pauseInterval: self.state.pauseInterval)
    }
    
    // Timers for tracking state changes
    var greenTimer : NSTimer?;
    var yellowTimer : NSTimer?;
    var redTimer : NSTimer?;
    var redBlinkTimer : NSTimer?;
    var tickTimer : NSTimer?
    
    init(withProfile profile : Profile){
        state = SpeechState(profile: SpeechProfileFactory.SpeechProfileWithProfile(profile))
    }
    
    /**
        Start this timer.

        If this timer was previously paused, start from the interval at which it was paused.
    */
    func start(){
        
        if(state.running != SpeechRunning.RUNNING){
            NSLog("Starting, pause interval = %g", self.state.pauseInterval);
            
            if(self.state.pauseInterval < NSTimeInterval(state.profile.green)){
                greenTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(state.profile.green) - self.state.pauseInterval, target: self, selector: "phaseChange:", userInfo: nil, repeats: false);
            }
            if(self.state.pauseInterval < NSTimeInterval(state.profile.yellow)){
                yellowTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(state.profile.yellow) - self.state.pauseInterval, target: self, selector: "phaseChange:", userInfo: nil, repeats: false);
            }
            if(self.state.pauseInterval < NSTimeInterval(state.profile.red)){
                redTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(state.profile.red) - self.state.pauseInterval, target: self, selector: "phaseChange:", userInfo: nil, repeats: false);
            }
            if(self.state.pauseInterval < NSTimeInterval(state.profile.redBlink)){
                redBlinkTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(state.profile.redBlink) - self.state.pauseInterval, target: self, selector: "phaseChange:", userInfo: nil, repeats: false);
            }
            
            tickTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tick:", userInfo: nil, repeats: true)
            
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
            
            greenTimer?.invalidate();
            yellowTimer?.invalidate();
            redTimer?.invalidate();
            redBlinkTimer?.invalidate();
            tickTimer?.invalidate()
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

            greenTimer?.invalidate();
            yellowTimer?.invalidate();
            redTimer?.invalidate();
            redBlinkTimer?.invalidate();
            tickTimer?.invalidate()
            
            // Reset the timer
            self.state.pauseInterval = 0;
            self.state.startTime = nil;
        }
    }
    
    func phaseChange(timer: NSTimer!){
        delegate?.phaseChanged(state, timer: self)
    }
    
    func tick(timer: NSTimer!){
        delegate?.tick(SpeechState(profile: state.profile, running: state.running, startTime: state.startTime, pauseInterval: state.pauseInterval), timer: self)
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
    func tick(state: SpeechState, timer: SpeechTimer)
    
}

