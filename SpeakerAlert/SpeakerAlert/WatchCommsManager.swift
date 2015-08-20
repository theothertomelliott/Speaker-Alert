//
//  WatchCommsManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/1/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchCommsManager: NSObject, WCSessionDelegate, SpeechTimerDelegate {

    var watchSession : WCSession?
    
    var speechMan : SpeechManager? {
        didSet {
            speechMan?.addSpeechObserver(self)
        }
    }
    
    override init() {
        if(WCSession.isSupported()){
            NSLog("WCSession supported, initializing")
            watchSession = WCSession.defaultSession()
        } else {
            NSLog("WCSession is not supported, will not initialize")
        }
    }
    
    func activate(){
        if let ws : WCSession = watchSession {
            NSLog("Activating WCSession and adding delegate")
            ws.delegate = self
            ws.activateSession()
        } else {
            NSLog("No session added, will not activate")
        }
    }
    
    private func updateState(state : SpeechState){
        do {
            try watchSession?.updateApplicationContext(
                state.toDictionary()
            )
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }
    
    // SpeechTimerDelegate
    
    func phaseChanged(state: SpeechState, timer: SpeechTimer){
        updateState(state)
    }
    
    func tick(state: SpeechState, timer: SpeechTimer){
        updateState(state)
    }
    
    func runningChanged(state: SpeechState, timer: SpeechTimer){
        updateState(state)
    }
    
    // WSSessionDelegate
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]){
        
        if let sm : SpeechManager = speechMan {
            if let messageName : String = message["messageName"] as? String {
                if messageName == "startStop" {
                    if sm.state?.running == SpeechRunning.STOPPED {
                        sm.start()
                    } else {
                        sm.stop()
                    }
                }
                if messageName == "pauseResume" {
                    if sm.state?.running == SpeechRunning.PAUSED {
                        sm.start()
                    } else if speechMan!.state?.running == SpeechRunning.RUNNING {
                        sm.pause()
                    } else {
                        NSLog("Did not expect to receive pauseResume while STOPPED");
                    }
                }
            }
        }
    }
    
}
