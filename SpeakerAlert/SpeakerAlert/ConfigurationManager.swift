//
//  ConfigurationManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class ConfigurationManager: NSObject, AppConfiguration {

    var parameterManager: ParameterManager?
    
    private var defaults: NSUserDefaults
    private var presetModes: [ConfigurationMode]
    
    func allPresets() -> [ConfigurationMode] {
        return presetModes
    }
    
    let defaultConfiguration = ConfigurationMode(
        name: "Practice",
        isDisplayTime: true,
        isVibrationEnabled: true,
        isAudioEnabled: false,
        speechDisplay: "Default",
        isHideStatusEnabled: true,
        isAlertOvertimeEnabled: true
    )

    init(defaults: NSUserDefaults) {
        self.defaults = defaults
        presetModes = []
        
        super.init()
        presetModes = defaultPresets()
    }
    
    func currentPreset() -> ConfigurationMode? {
        for preset in self.presetModes {
            if self == preset {
                return preset
            }
        }
        return nil
    }
    
    func findPreset(name: String) -> ConfigurationMode? {
        for preset in self.presetModes {
            if preset.name == name {
                return preset
            }
        }
        return nil
    }
    
    func applyPreset(preset: ConfigurationMode) {
        self.isDisplayTime = preset.isDisplayTime
        self.isVibrationEnabled = preset.isVibrationEnabled
        self.isAudioEnabled = preset.isAudioEnabled
        self.speechDisplay = preset.speechDisplay
        self.isHideStatusEnabled = preset.isHideStatusEnabled
        self.isAlertOvertimeEnabled = preset.isAlertOvertimeEnabled
    }

    private func defaultPresets() -> [ConfigurationMode] {
        return [
            ConfigurationMode(
                name: "Meeting",
                isDisplayTime: false,
                isVibrationEnabled: false,
                isAudioEnabled: false,
                speechDisplay: "Default",
                isHideStatusEnabled: true,
                isAlertOvertimeEnabled: true
            ),
            ConfigurationMode(
                name: "Contest",
                isDisplayTime: false,
                isVibrationEnabled: false,
                isAudioEnabled: false,
                speechDisplay: "Default",
                isHideStatusEnabled: true,
                isAlertOvertimeEnabled: false
            ),
            defaultConfiguration
        ]
    }
    
    private let autoStartKey = "autoStartEnabled"
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

    private let displayTimeKey = "displayTimeByDefault"
    var isDisplayTime: Bool {
        get {
            if let _ = defaults.objectForKey(displayTimeKey) {
                return defaults.boolForKey(displayTimeKey)
            }
            return defaultConfiguration.isDisplayTime
        }
        set {
            defaults.setBool(newValue, forKey: displayTimeKey)
        }
    }

    private let vibrationEnabledKey = "vibrationEnabled"
    var isVibrationEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(vibrationEnabledKey) {
                return defaults.boolForKey(vibrationEnabledKey)
            }
            return defaultConfiguration.isVibrationEnabled
        }
        set {
            defaults.setBool(newValue, forKey: vibrationEnabledKey)
        }
    }
    
    private let audioEnabledKey = "audioEnabled"
    var isAudioEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(audioEnabledKey) {
                return defaults.boolForKey(audioEnabledKey)
            }
            return defaultConfiguration.isAudioEnabled
        }
        set {
            defaults.setBool(newValue, forKey: audioEnabledKey)
        }
    }
    
    private let audioFileKey = "audioFile"
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
    
    
    private let hideControlsKey = "hideControlsInSpeech"
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
    
    private let speechDisplayKey = "speechDisplay"
    var speechDisplay: String {
        get {
            if let display = parameterManager?.speechDisplay {
                return display
            }
            if let output = defaults.stringForKey(speechDisplayKey) {
                return output
            }
            // Default
            return defaultConfiguration.speechDisplay
        }
        set {
            defaults.setObject(newValue, forKey: speechDisplayKey)
        }
    }
    
    private let hideStatusKey = "hideStatus"
    var isHideStatusEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(hideStatusKey) {
                return defaults.boolForKey(hideStatusKey)
            }
            return defaultConfiguration.isHideStatusEnabled
        }
        set {
            defaults.setBool(newValue, forKey: hideStatusKey)
        }
    }
    
    private let alertOvertimeKey = "alertOvertime"
    var isAlertOvertimeEnabled: Bool {
        get {
            if let _ = defaults.objectForKey(alertOvertimeKey) {
                return defaults.boolForKey(alertOvertimeKey)
            }
            return defaultConfiguration.isAlertOvertimeEnabled
        }
        set {
            defaults.setBool(newValue, forKey: alertOvertimeKey)
        }
    }

}
