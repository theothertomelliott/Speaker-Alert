//
//  VibrationAlertManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/31/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import AudioToolbox

class VibrationAlertManager: NSObject, SpeechManagerDelegate {

    var configMan: ConfigurationManager?

    var speechMan: SpeechManager? {
        didSet {
            speechMan?.addSpeechObserver(self)
        }
    }

    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        if let cm = configMan where cm.isVibrationEnabled {
            NSLog("Vibrating")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    func runningChanged(state: SpeechState, timer: SpeechTimer) {}

    func speechComplete(state: SpeechState, timer: SpeechTimer) {
    }
}
