//
//  LocalNotificationManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/17/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class LocalNotificationManager: NSObject, SpeechManagerDelegate {

    var configMan: ConfigurationManager
    var speechMan: SpeechManager

    init(configManager: ConfigurationManager, speechManager: SpeechManager) {
        self.configMan = configManager
        self.speechMan = speechManager
        super.init()
        speechMan.addSpeechObserver(self)
    }
    
    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {
        // Nothing to do
    }

    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {
    }

    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech) {
        // Kill all notifications if a speech has been stopped
        UIApplication.shared.cancelAllLocalNotifications()
    }

    fileprivate func setNotificationForPhase(_ phase: SpeechPhase) {

        if !configMan.areNotificationsEnabled {
            return
        }
        
        if phase == SpeechPhase.over_MAXIMUM {
            if !configMan.isAlertOvertimeEnabled {
                return
            }
        }
        
        if speechMan.state == nil || speechMan.state?.timeUntil(phase) < 0 {
            return
        }

        let state: SpeechState = speechMan.state!

        let phaseName: String = SpeechPhase.name[phase]!

        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Time Alert: \(phaseName)"
        notification.hasAction = false
        notification.fireDate = Date(timeIntervalSinceNow: state.timeUntil(phase))
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.shared.scheduleLocalNotification(notification)
    }

    fileprivate func setNotifications() {
        if speechMan.state?.running == SpeechRunning.running {
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
        UIApplication.shared.cancelAllLocalNotifications()
    }

}
