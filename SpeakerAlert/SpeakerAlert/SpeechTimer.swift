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
    
    var state : SpeechState {
        didSet {
            delegate?.phaseChanged(state, timer: self)
        }
    }
    
    private func setRunning(running : SpeechRunning){
        state = SpeechState(running: running, phase: state.phase, elapsed: elapsed())
    }
    
    private func setPhase(phase : SpeechPhase){
        state = SpeechState(running: state.running, phase: phase, elapsed: elapsed())
    }
    
    var timings : Profile;
    
    // Timers for tracking state changes
    var greenTimer : NSTimer?;
    var yellowTimer : NSTimer?;
    var redTimer : NSTimer?;
    var redBlinkTimer : NSTimer?;
    var tickTimer : NSTimer?
    
    // Required for pausing
    var startTime : NSDate?;
    var pauseInterval : NSTimeInterval = 0;
    
    init(withTimings timing : Profile){
        state = SpeechState()
        self.timings = timing;
    }
    
    /**
        Start this timer.

        If this timer was previously paused, start from the interval at which it was paused.
    */
    func start(){
        
        if(state.running != SpeechRunning.RUNNING){
            NSLog("Starting, pause interval = %g", pauseInterval);
            
            if(pauseInterval < NSTimeInterval(timings.green!)){
                greenTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timings.green!) - pauseInterval, target: self, selector: "green:", userInfo: nil, repeats: false);
            }
            if(pauseInterval < NSTimeInterval(timings.yellow!)){
                yellowTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timings.yellow!) - pauseInterval, target: self, selector: "yellow:", userInfo: nil, repeats: false);
            }
            if(pauseInterval < NSTimeInterval(timings.red!)){
                redTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timings.red!) - pauseInterval, target: self, selector: "red:", userInfo: nil, repeats: false);
            }
            if(pauseInterval < NSTimeInterval(timings.redBlink!)){
                redBlinkTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timings.redBlink!) - pauseInterval, target: self, selector: "redBlink:", userInfo: nil, repeats: false);
            }
            
            tickTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tick:", userInfo: nil, repeats: true)
            
            startTime = NSDate();
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
            pauseInterval = pauseInterval + NSDate().timeIntervalSinceDate(startTime!);
            
            NSLog("Pausing with interval %g", pauseInterval);
            
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
            pauseInterval = 0;
            startTime = nil;
        }
    }
    
    func green(timer: NSTimer!){
        setPhase(SpeechPhase.GREEN)
    }
    
    func yellow(timer: NSTimer!){
        setPhase(SpeechPhase.YELLOW)
    }
    
    func red(timer: NSTimer!){
        setPhase(SpeechPhase.RED)
    }
    
    func redBlink(timer: NSTimer!){
        setPhase(SpeechPhase.OVER_MAXIMUM)
    }
    
    func tick(timer: NSTimer!){
        delegate?.tick(SpeechState(running: state.running, phase: state.phase, elapsed: elapsed()), timer: self)
    }
    
    func elapsed() -> NSTimeInterval {
        if let s : NSDate = startTime {
            return pauseInterval + NSDate().timeIntervalSinceDate(s)
        } else {
            return pauseInterval
        }
    }
    
}

protocol SpeechTimerDelegate {

    func phaseChanged(state: SpeechState, timer: SpeechTimer)
    func tick(state: SpeechState, timer: SpeechTimer)
    
}

