//
//  AudioAlertManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/30/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation
import AudioToolbox

class AudioAlertManager: NSObject, SpeechManagerDelegate {
    
    var configMan: ConfigurationManager
    var speechMan: SpeechManager
    
    init(configManager: ConfigurationManager, speechManager: SpeechManager) {
        self.configMan = configManager
        self.speechMan = speechManager
        super.init()
        speechMan.addSpeechObserver(self)
    }
    
    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {
        if configMan.isAudioEnabled {
            if state.phase == SpeechPhase.over_MAXIMUM && !configMan.isAlertOvertimeEnabled {
                return
            }
            playSound()
        }
    }
    
    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {}
    
    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech) {
    }
    
    var soundURL: URL?
    var soundID: SystemSoundID = 0
    
    func playSound() {
        if let filePath = Bundle.main.path(
            forResource: configMan.audioFile,
            ofType: "mp3"
            ) {
            soundURL = URL(fileURLWithPath: filePath)
            if let url = soundURL {
                AudioServicesCreateSystemSoundID(url as NSURL, &soundID)
            }
        } else {
            print("Sound file not found")
        }
        
        // Sound from: http://raisedbeaches.com/octave/
        // Add attribution to About screen
        if soundID != 0 {
                AudioServicesPlaySystemSound(soundID)
        }
    }

}
