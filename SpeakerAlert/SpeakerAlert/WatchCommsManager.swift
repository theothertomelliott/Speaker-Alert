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
    
    func stateChanged(state: SpeechState, timer: SpeechTimer){
        
    }
    
    func tick(elapsed : NSTimeInterval){
        do {
            try watchSession?.updateApplicationContext(
                ["elapsed" : elapsed]
            )
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }
    
}
