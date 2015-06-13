//
//  SpeechTimer.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/13/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

public class SpeechTimer : NSObject {
    
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
    
    func start(){
        
        if(!running){
            NSLog("Starting, pause interval = %g", pauseInterval);
            
            if(pauseInterval < timings.green){
                greenTimer = NSTimer.scheduledTimerWithTimeInterval(timings.green - pauseInterval, target: self, selector: "green:", userInfo: nil, repeats: false);
            }
            if(pauseInterval < timings.yellow){
                yellowTimer = NSTimer.scheduledTimerWithTimeInterval(timings.yellow - pauseInterval, target: self, selector: "yellow:", userInfo: nil, repeats: false);
            }
            if(pauseInterval < timings.red){
                redTimer = NSTimer.scheduledTimerWithTimeInterval(timings.red - pauseInterval, target: self, selector: "red:", userInfo: nil, repeats: false);
            }
            if(pauseInterval < timings.redBlink){
                redBlinkTimer = NSTimer.scheduledTimerWithTimeInterval(timings.redBlink - pauseInterval, target: self, selector: "redBlink:", userInfo: nil, repeats: false);
            }
            startTime = NSDate();
            running = true;
        }
    }
    
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
    }
    
    func yellow(timer: NSTimer!){
        NSLog("Yellow");
    }
    
    func red(timer: NSTimer!){
        NSLog("Red");
    }
    
    func redBlink(timer: NSTimer!){
        NSLog("RedBlink");
        
        // This is the last interval, stop here
        stop();
    }
    
}