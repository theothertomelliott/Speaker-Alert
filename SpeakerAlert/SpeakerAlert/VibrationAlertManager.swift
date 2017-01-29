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

    var configMan: ConfigurationManager
    var speechMan: SpeechManager
    
    init(configManager: ConfigurationManager, speechManager: SpeechManager) {
        self.configMan = configManager
        self.speechMan = speechManager
        super.init()
        speechMan.addSpeechObserver(self)
    }
    
    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {
        if configMan.isVibrationEnabled {
            if state.phase == SpeechPhase.over_MAXIMUM && !configMan.isAlertOvertimeEnabled {
                return
            }
            NSLog("Vibrating")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {}

    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech) {
    }
}
