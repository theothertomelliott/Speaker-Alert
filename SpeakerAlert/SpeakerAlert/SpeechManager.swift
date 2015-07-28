//
//  SpeechManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/27/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

/*
* Responsible for handling the currently running speech across the entire app.
*/
class SpeechManager: NSObject, SpeechTimerDelegate {

    // Speech timer
    private var timer : SpeechTimer?;
    
    var profile : Profile? {
        set(value) {
            
            // Stop any currently running timers
            if let t : SpeechTimer = timer {
                t.stop()
            }
            
            // Create a new timer with the appropriate profile
            if let p : Profile = value {
                timer = SpeechTimer(withTimings: p)
                timer?.delegate = self
            } else {
                timer = nil
            }
        }
        
        get {
            return timer!.timings;
        }
    }
    
    func green(timer : SpeechTimer){
        NSLog("Green")
    }
    func yellow(timer : SpeechTimer){
        NSLog("Yellow")
    }
    func red(timer : SpeechTimer){
        NSLog("Red")
    }
    func redBlink(timer : SpeechTimer){
        NSLog("RedBlink")
    }
    
    func tick(elapsed : NSTimeInterval){
        NSLog("Tick")
    }
    
    // Start, pause and stop methods for current speech
    func start(){
        timer?.start()
    }
    
    func stop(){
        timer?.stop()
    }
    
    func pause(){
        timer?.pause()
    }
    
    // TODO: Add notifications for changes in state and ticks
}
