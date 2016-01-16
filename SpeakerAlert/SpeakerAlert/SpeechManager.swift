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
    private var timer: SpeechTimer?
    // Observers who receive state updates
    private var observers = [SpeechManagerDelegate]()

    override init() {
        super.init()
    }

    var state: SpeechState? {
        get {
            return timer?.state
        }
    }

    func addSpeechObserver(observer: SpeechManagerDelegate) {
        observers.append(observer)
    }

    func removeSpeechObserver(observer: SpeechManagerDelegate) {
        var index: Int? = nil
        for var i: Int = 0; i < observers.count; i++ {
            let obs: NSObject = observer as! NSObject
            let obs_i: NSObject = observers[i] as! NSObject
            if obs === obs_i {
                index = i
            }
        }

        if let ix = index {
            observers.removeAtIndex(ix)
        }
    }

    private var _profile: Profile?
    var profile: Profile? {
        set(value) {

            // Stop any currently running timers
            if let t: SpeechTimer = timer {
                t.stop()
            }

            // Create a new timer with the appropriate profile
            if let p: Profile = value {
                timer = SpeechTimer(withProfile: p)
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

    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        NSLog("Speech timer state changed: \(state)")
        for observer in observers {
            observer.phaseChanged(state, timer: timer)
        }
    }

    func runningChanged(state: SpeechState, timer: SpeechTimer) {
        for observer in observers {
            observer.runningChanged(state, timer: timer)
        }
    }

    func speechComplete(state: SpeechState, timer: SpeechTimer) {
        for observer in observers {
            observer.speechComplete(state, timer: timer)
        }
    }

    // MARK: Timer lifecycle methods

    func start() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.timer?.start()
        })
    }

    func stop() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.speechComplete(self.state!, timer: self.timer!)
            self.timer?.stop()
            self.timer = nil
        })
    }

    func pause() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.timer?.pause()
        })
    }

}

protocol SpeechManagerDelegate {

    func phaseChanged(state: SpeechState, timer: SpeechTimer)
    func runningChanged(state: SpeechState, timer: SpeechTimer)
    func speechComplete(state: SpeechState, timer: SpeechTimer)

}
