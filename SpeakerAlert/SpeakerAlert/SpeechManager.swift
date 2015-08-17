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
    
    private var observers = [SpeechTimerDelegate]()
    
    func addSpeechObserver(observer: SpeechTimerDelegate) {
        observers.append(observer)
    }
    
    func removeSpeechObserver(observer: SpeechTimerDelegate){
        // TODO: Figure out how to do this safely
        var index : Int? = nil
        for(var i : Int = 0; i < observers.count; i++){
            let obs : NSObject = observer as! NSObject
            let obs_i : NSObject = observers[i] as! NSObject
            if(obs === obs_i){
                index = i;
            }
        }
        
        if let ix = index {
            observers.removeAtIndex(ix)
        }
    }
    
    override init(){
        super.init()
    }
    
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
            return timer!.state.profile;
        }
    }
    
    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        NSLog("Speech timer state changed: \(state)")
        for observer in observers {
            observer.phaseChanged(state, timer: timer)
        }
    }
    
    func tick(state: SpeechState, timer: SpeechTimer){
        for observer in observers {
            observer.tick(state, timer: timer)
        }
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
