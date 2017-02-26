//
//  SpeechManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/27/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord

/*
* Responsible for handling the currently running speech across the entire app.
*/
class SpeechManager: NSObject, SpeechTimerDelegate {

    // Speech timer
    fileprivate var timer: SpeechTimer?
    // Observers who receive state updates
    fileprivate var observers = [SpeechManagerDelegate]()

    var parameterManager: ParameterManager
    
    init(parameterManager: ParameterManager) {
        self.parameterManager = parameterManager
        super.init()
    }

    var state: SpeechState? {
        get {
            return timer?.state
        }
    }

    func addSpeechObserver(_ observer: SpeechManagerDelegate) {
        observers.append(observer)
    }

    func removeSpeechObserver(_ observer: SpeechManagerDelegate) {
        var index: Int? = nil
        for i in 0...(observers.count-1) {
            if let obs: NSObject = observer as? NSObject,
                let obs_i: NSObject = observers[i] as? NSObject {
                    if obs === obs_i {
                    index = i
                    }
            }
        }

        if let ix = index {
            observers.remove(at: ix)
        }
    }

    fileprivate var _profile: Profile?
    var profile: Profile? {
        set(value) {

            // Stop any currently running timers
            if let t: SpeechTimer = timer {
                t.stop()
            }

            // Create a new timer with the appropriate profile
            if let p: Profile = value {
                timer = SpeechTimer(withProfile: p)
                timer?.setInterval(TimeInterval(parameterManager.starttime))
                timer?.delegate = self
            } else {
                timer = nil
            }

            _profile = value
        }

        get {
            return _profile
        }
    }

    // MARK: SpeechTimerDelegate

    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {
        NSLog("Speech timer state changed: \(state)")
        for observer in observers {
            observer.phaseChanged(state, timer: timer)
        }
    }

    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {
        for observer in observers {
            observer.runningChanged(state, timer: timer)
        }
    }

    func speechComplete(_ state: SpeechState, timer: SpeechTimer) {
        
        var speechRecord: Speech?
        
        MagicalRecord.save({ (localContext: NSManagedObjectContext?) -> Void in
            
            let speech: Speech = Speech.mr_createEntity(in: localContext)
            speech.duration = state.elapsed as NSNumber
            speech.startTime = state.initialStart
            speech.profile = self._profile?.mr_(in: localContext)
            
            speechRecord = speech
            
        }) { (success: Bool, error: Error?) -> Void in
            // TODO: Handle failure more clearly (error out to user?)
            if !success {
                NSLog("Failure saving speech record: \(String(describing: error?.localizedDescription))")
            }
            DispatchQueue.main.async(execute: { () -> Void in
                for observer in self.observers {
                    observer.speechComplete(
                        state,
                        timer: timer,
                        record: speechRecord!.mr_inThreadContext())
                }
            })
        }
        
    }

    // MARK: Timer lifecycle methods

    func start() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.timer?.start()
        })
    }

    func stop() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.speechComplete(self.state!, timer: self.timer!)
            self.timer?.stop()
            self.timer = nil
        })
    }

    func pause() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.timer?.pause()
        })
    }

    func reset() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.timer?.reset()
        })
    }

    
}

protocol SpeechManagerDelegate {

    func phaseChanged(_ state: SpeechState, timer: SpeechTimer)
    func runningChanged(_ state: SpeechState, timer: SpeechTimer)
    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech)

}
