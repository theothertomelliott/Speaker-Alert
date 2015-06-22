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
    
    var timings : Timing;
    var greenTimer : NSTimer?;
    var yellowTimer : NSTimer?;
    var redTimer : NSTimer?;
    var redBlinkTimer : NSTimer?;
    
    var running : Bool;
    
    // Required for pausing
    var startTime : NSDate?;
    var pauseInterval : NSTimeInterval = 0;
    
    init(withTimings timing : Timing){
        self.timings = timing;
        running = false;
    }
    
    /**
        Start this timer.

        If this timer was previously paused, start from the interval at which it was paused.
    */
    func start(){
        
        if(!running){
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
            startTime = NSDate();
            running = true;
        }
    }
    
    /**
        Pause this timer.
    
        If the timer is not running, does nothing.
    
        When start() is next called, the timer will resume from the time at which it was paused.
    */
    func pause(){
        
        if(running){
            pauseInterval = pauseInterval + NSDate().timeIntervalSinceDate(startTime!);
            
            NSLog("Pausing with interval %g", pauseInterval);
            
            greenTimer?.invalidate();
            yellowTimer?.invalidate();
            redTimer?.invalidate();
            redBlinkTimer?.invalidate();
            running = false;
        }
    }
    
    /**
        Stop this timer.
    
        If the timer is not running, does nothing.
    
        When start() is next called, the timer will start from zero.
    */
    func stop(){
        if(running){
            NSLog("Stopping");
            
            pauseInterval = 0;
            startTime = nil;

            greenTimer?.invalidate();
            yellowTimer?.invalidate();
            redTimer?.invalidate();
            redBlinkTimer?.invalidate();
            running = false;
        }
    }
    
    func green(timer: NSTimer!){
        NSLog("Green");
        
        delegate?.green(self);
    }
    
    func yellow(timer: NSTimer!){
        NSLog("Yellow");
        
        delegate?.yellow(self);
    }
    
    func red(timer: NSTimer!){
        NSLog("Red");
        
        delegate?.red(self);
    }
    
    func redBlink(timer: NSTimer!){
        NSLog("RedBlink");
        
        // This is the last interval, stop here
        stop();
        
        delegate?.redBlink(self);
    }
    
}

protocol SpeechTimerDelegate {
    
    func green(timer : SpeechTimer);
    func yellow(timer : SpeechTimer);
    func red(timer : SpeechTimer);
    func redBlink(timer : SpeechTimer);
    
}

