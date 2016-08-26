//
//  LocalNotificationManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/17/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class LocalNotificationManager: NSObject, SpeechManagerDelegate {

    var configMan: ConfigurationManager?
    
    var speechMan: SpeechManager? {
        didSet {
            speechMan?.addSpeechObserver(self)
        }
    }

    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        // Nothing to do
    }

    func runningChanged(state: SpeechState, timer: SpeechTimer) {
    }

    func speechComplete(state: SpeechState, timer: SpeechTimer, record: Speech) {
        // Kill all notifications if a speech has been stopped
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    private func setNotificationForPhase(phase: SpeechPhase) {

        if let cm = configMan where cm.isVibrationEnabled {
            return
        }
        
        if phase == SpeechPhase.OVER_MAXIMUM {
            if let cm = configMan where !cm.isAlertOvertimeEnabled {
                return
            }
        }
        
        if speechMan == nil || speechMan!.state == nil || speechMan?.state?.timeUntil(phase) < 0 {
            return
        }

        let state: SpeechState = speechMan!.state!

        let phaseName: String = SpeechPhase.name[phase]!

        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Time Alert: \(phaseName)"
        notification.hasAction = false
        notification.fireDate = NSDate(timeIntervalSinceNow: state.timeUntil(phase))
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    private func setNotifications() {
        if speechMan?.state?.running == SpeechRunning.RUNNING {
            for s: SpeechPhase in SpeechPhase.allCases {
                setNotificationForPhase(s)
            }
        }
    }

    func enteredBackground() {
        NSLog("Entered background")
        setNotifications()
    }

    func leftBackground() {
        NSLog("Left background")
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

}
