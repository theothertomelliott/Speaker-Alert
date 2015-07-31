//
//  VibrationAlertManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/31/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import AudioToolbox

class VibrationAlertManager: NSObject, SpeechTimerDelegate {

    var speechMan : SpeechManager? {
        didSet {
            speechMan?.addSpeechObserver(self)
        }
    }
    
    func stateChanged(state: SpeechState, timer: SpeechTimer){
        NSLog("Vibrating")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func tick(elapsed : NSTimeInterval){}
    
}
