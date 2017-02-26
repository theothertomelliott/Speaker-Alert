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
    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {}
    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {}
    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech) {}
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
            watchSession = WCSession.default()
        } else {
            NSLog("WCSession is not supported, will not initialize")
        }
        speechMan.addSpeechObserver(self)
    }

    func activate() {
        if let ws: WCSession = watchSession {
            NSLog("Activating WCSession and adding delegate")
            ws.delegate = self
            ws.activate()
        } else {
            NSLog("No session added, will not activate")
        }
    }

    fileprivate func updateState(_ state: SpeechState) {
        do {
            let vibration = self.configMan.isVibrationEnabled
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

    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {
        // Watch app will catch phase changes, so no need to send
    }

    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {
        updateState(state)
    }

    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech) {
        do {
            // Send a notification that the speech ended
            watchSession?.sendMessage(
                [
                "messageName" : "speechComplete",
                "state" : state.toDictionary()
                ],
                replyHandler: { (reply: [String : Any]) -> Void in
                NSLog("Reply received")
                }, errorHandler: { (error: Error) -> Void in
                    NSLog("Error received: \(error.localizedDescription)")
            })

            // Update with an empty context to indicate no speech
            try watchSession?.updateApplicationContext([ : ])
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }

    // WSSessionDelegate
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler([:])
        if let messageName: String = message["messageName"] as? String {
            if messageName == "startStop" {
                if speechMan.state?.running == SpeechRunning.stopped ||
                    speechMan.state?.running == SpeechRunning.paused {
                    speechMan.start()
                } else {
                    speechMan.stop()
                }
            }
            if messageName == "pauseResume" {
                if speechMan.state?.running == SpeechRunning.paused {
                    speechMan.start()
                } else if speechMan.state?.running == SpeechRunning.running {
                    speechMan.pause()
                } else {
                    NSLog("Did not expect to receive pauseResume while STOPPED")
                }
            }
        }
    }

    @available(iOS 9.3, *)
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
                                       error: Error?
        ) {}
    
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {}
    
}
