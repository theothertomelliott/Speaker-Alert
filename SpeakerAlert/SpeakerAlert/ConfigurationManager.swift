//
//  ConfigurationManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class ConfigurationManager: NSObject {

    var parameterManager: ParameterManager?
    
    var defaults: NSUserDefaults

    override init() {
        defaults = NSUserDefaults.standardUserDefaults()
    }

    init(defaults: NSUserDefaults) {
        self.defaults = defaults
    }

    let autoStartKey = "autoStartEnabled"
    var isAutoStartEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(autoStartKey) {
                return defaults.boolForKey(autoStartKey)
            }
            // Default
            return false
        }
        set {
           defaults.setBool(newValue, forKey: autoStartKey)
        }
    }

    let displayTimeKey = "displayTimeByDefault"
    var isDisplayTime: Bool {
        get {
            if let _ = defaults.objectForKey(displayTimeKey) {
                return defaults.boolForKey(displayTimeKey)
            }
            return true
        }
        set {
            defaults.setBool(newValue, forKey: displayTimeKey)
        }
    }

    let vibrationEnabledKey = "vibrationEnabled"
    var isVibrationEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(vibrationEnabledKey) {
                return defaults.boolForKey(vibrationEnabledKey)
            }
            return true
        }
        set {
            defaults.setBool(newValue, forKey: vibrationEnabledKey)
        }
    }
    
    let audioEnabledKey = "audioEnabled"
    var isAudioEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(audioEnabledKey) {
                return defaults.boolForKey(audioEnabledKey)
            }
            return false
        }
        set {
            defaults.setBool(newValue, forKey: audioEnabledKey)
        }
    }
    
    let audioFileKey = "audioFile"
    var audioFile: String {
        get {
            if let fileName = defaults.objectForKey(audioFileKey) as? String {
                return fileName
            }
            return "alarm-frenzy"
        }
        set {
            defaults.setObject(newValue, forKey: audioFileKey)
        }
    }
    
    
    let hideControlsKey = "hideControlsInSpeech"
    var isHideControlsEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(hideControlsKey) {
                return defaults.boolForKey(hideControlsKey)
            }
            return true
        }
        set {
            defaults.setBool(newValue, forKey: hideControlsKey)
        }
    }
    
    let speechDisplayKey = "speechDisplay"
    var speechDisplay: String {
        get {
            if let display = parameterManager?.speechDisplay {
                return display
            }
            if let output = defaults.stringForKey(speechDisplayKey) {
                return output
            }
            // Default
            return "Default"
        }
        set {
            defaults.setObject(newValue, forKey: speechDisplayKey)
        }
    }

}
