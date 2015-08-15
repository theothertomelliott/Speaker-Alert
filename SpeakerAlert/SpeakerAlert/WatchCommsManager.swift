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
    
    func phaseChanged(state: SpeechState, timer: SpeechTimer){
        updateState(state)
    }
    
    func tick(state: SpeechState, timer: SpeechTimer){
        updateState(state)
    }
    
    // WSSessionDelegate
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]){
        let messageName : String = message["messageName"] as! String
        if messageName == "startStop" {
            speechMan!.stop();
        }
    }
    
}
