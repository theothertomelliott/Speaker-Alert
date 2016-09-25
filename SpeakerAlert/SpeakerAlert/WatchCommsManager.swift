//
//  WatchCommsManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/1/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol WatchComms: SpeechManagerDelegate {
    func activate()
}

class NullWatchCommsManager: NSObject, WatchComms {
    func activate() {}
    func phaseChanged(state: SpeechState, timer: SpeechTimer) {}
    func runningChanged(state: SpeechState, timer: SpeechTimer) {}
    func speechComplete(state: SpeechState, timer: SpeechTimer, record: Speech) {}
}

@available(iOS 9, *)
class WatchCommsManager: NSObject, WCSessionDelegate, WatchComms {

    var configMan: ConfigurationManager
    var speechMan: SpeechManager
    var watchSession: WCSession?
    
    init(configManager: ConfigurationManager, speechManager: SpeechManager) {
        self.configMan = configManager
        self.speechMan = speechManager
        super.init()
        if WCSession.isSupported() {
            NSLog("WCSession supported, initializing")
            watchSession = WCSession.defaultSession()
        } else {
            NSLog("WCSession is not supported, will not initialize")
        }
        speechMan.addSpeechObserver(self)
    }

    func activate() {
        if let ws: WCSession = watchSession {
            NSLog("Activating WCSession and adding delegate")
            ws.delegate = self
            ws.activateSession()
        } else {
            NSLog("No session added, will not activate")
        }
    }

    private func updateState(state: SpeechState) {
        do {
            var vibration: Bool = false
            if let cm: ConfigurationManager = self.configMan {
                vibration = cm.isVibrationEnabled
            }

            var speechName = ""
            if let sn = speechMan.profile?.name {
                speechName = sn
            }

            try watchSession?.updateApplicationContext(
                [
                    "speechName" : speechName,
                    "vibration" : vibration,
                    "state" : state.toDictionary()
                    ]
            )
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }

    // SpeechTimerDelegate

    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        // Watch app will catch phase changes, so no need to send
    }

    func runningChanged(state: SpeechState, timer: SpeechTimer) {
        updateState(state)
    }

    func speechComplete(state: SpeechState, timer: SpeechTimer, record: Speech) {
        do {
            // Send a notification that the speech ended
            watchSession?.sendMessage(
                [
                "messageName" : "speechComplete",
                "state" : state.toDictionary()
                ],
                replyHandler: { (reply: [String : AnyObject]) -> Void in
                NSLog("Reply received")
                }, errorHandler: { (error: NSError) -> Void in
                    NSLog("Error received")
            })

            // Update with an empty context to indicate no speech
            try watchSession?.updateApplicationContext([ : ])
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }

    // WSSessionDelegate
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        replyHandler([:])
        if let sm: SpeechManager = speechMan,
            let messageName: String = message["messageName"] as? String {
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
                } else if speechMan.state?.running == SpeechRunning.RUNNING {
                    sm.pause()
                } else {
                    NSLog("Did not expect to receive pauseResume while STOPPED")
                }
            }
        }
    }

    @available(iOS 9.3, *)
    func session(
        session: WCSession,
        activationDidCompleteWithState activationState: WCSessionActivationState,
                                       error: NSError?
        ) {}
    
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(session: WCSession) {}
    
    
    @available(iOS 9.3, *)
    func sessionDidDeactivate(session: WCSession) {}
    
}
