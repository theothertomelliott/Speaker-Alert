//
//  ConfigurationManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class ConfigurationManager: NSObject, AppConfiguration {

    fileprivate var defaults: UserDefaults
    fileprivate var presetModes: [ConfigurationMode]
    fileprivate var parameterManager: ParameterManager?
   
    init(defaults: UserDefaults, parameters: ParameterManager? = nil) {
        self.defaults = defaults
        self.parameterManager = parameters
        presetModes = []
        
        super.init()
        presetModes = defaultPresets()
    }
    
    func allPresets() -> [ConfigurationMode] {
        return presetModes
    }
    
    let defaultConfiguration = ConfigurationMode(
        name: "Meeting",
        timeDisplayMode: TimeDisplay.None,
        isVibrationEnabled: false,
        isAudioEnabled: false,
        isHideStatusEnabled: true,
        isHideControlsEnabled: true,
        isAlertOvertimeEnabled: true,
        areNotificationsEnabled: false
        )
    
    func currentPreset() -> ConfigurationMode? {
        for preset in self.presetModes {
            if self == preset {
                return preset
            }
        }
        return nil
    }
    
    func findPreset(_ name: String) -> ConfigurationMode? {
        for preset in self.presetModes {
            if preset.name == name {
                return preset
            }
        }
        return nil
    }
    
    func applyPreset(_ preset: ConfigurationMode) {
        self.timeDisplayMode = preset.timeDisplayMode
        self.isVibrationEnabled = preset.isVibrationEnabled
        self.isAudioEnabled = preset.isAudioEnabled
        self.isHideStatusEnabled = preset.isHideStatusEnabled
        self.isHideControlsEnabled = preset.isHideControlsEnabled
        self.isAlertOvertimeEnabled = preset.isAlertOvertimeEnabled
        self.areNotificationsEnabled = preset.areNotificationsEnabled
    }

    fileprivate func defaultPresets() -> [ConfigurationMode] {
        return [
            ConfigurationMode(
                name: "Practice",
                timeDisplayMode: TimeDisplay.CountUp,
                isVibrationEnabled: true,
                isAudioEnabled: false,
                isHideStatusEnabled: true,
                isHideControlsEnabled: false,
                isAlertOvertimeEnabled: true,
                areNotificationsEnabled: true
            ),
            ConfigurationMode(
                name: "Contest",
                timeDisplayMode: TimeDisplay.None,
                isVibrationEnabled: false,
                isAudioEnabled: false,
                isHideStatusEnabled: true,
                isHideControlsEnabled: true,
                isAlertOvertimeEnabled: false,
                areNotificationsEnabled: false
            ),
            defaultConfiguration
        ]
    }
    
    fileprivate let autoStartKey = "autoStartEnabled"
    var isAutoStartEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: autoStartKey) {
                return defaults.bool(forKey: autoStartKey)
            }
            // Default
            return false
        }
        set {
           defaults.set(newValue, forKey: autoStartKey)
        }
    }
    
    
    fileprivate let timeDisplayKey = "timeDisplayMode"
    fileprivate let legacyDisplayTimeKey = "displayTimeByDefault"
    var timeDisplayMode: TimeDisplay {
        get {
            if let p = parameterManager, p.forceShowTime {
                return TimeDisplay.CountUp
            }
            if let mode = defaults.object(forKey: timeDisplayKey) as? String {
                return StringToTimeDisplay(mode)
            }
            if let _ = defaults.object(forKey: legacyDisplayTimeKey) {
                return
                    defaults.bool(forKey: legacyDisplayTimeKey)
                        ?
                        TimeDisplay.CountUp
                            :
                        TimeDisplay.CountDown
            }
            return defaultConfiguration.timeDisplayMode
        }
        set {
            defaults.set(newValue.rawValue, forKey: timeDisplayKey)
        }
    }

    fileprivate let vibrationEnabledKey = "vibrationEnabled"
    var isVibrationEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: vibrationEnabledKey) {
                return defaults.bool(forKey: vibrationEnabledKey)
            }
            return defaultConfiguration.isVibrationEnabled
        }
        set {
            defaults.set(newValue, forKey: vibrationEnabledKey)
        }
    }
    
    fileprivate let notificationsEnabledKey = "notificationsEnabled"
    var areNotificationsEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: notificationsEnabledKey) {
                return defaults.bool(forKey: notificationsEnabledKey)
            }
            return defaultConfiguration.isVibrationEnabled
        }
        set {
            defaults.set(newValue, forKey: notificationsEnabledKey)
        }
    }
    
    fileprivate let audioEnabledKey = "audioEnabled"
    var isAudioEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: audioEnabledKey) {
                return defaults.bool(forKey: audioEnabledKey)
            }
            return defaultConfiguration.isAudioEnabled
        }
        set {
            defaults.set(newValue, forKey: audioEnabledKey)
        }
    }
    
    fileprivate let audioFileKey = "audioFile"
    var audioFile: String {
        get {
            if let fileName = defaults.object(forKey: audioFileKey) as? String {
                return fileName
            }
            return "alarm-frenzy"
        }
        set {
            defaults.set(newValue, forKey: audioFileKey)
        }
    }
    
    
    fileprivate let hideControlsKey = "hideControlsInSpeech"
    var isHideControlsEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: hideControlsKey) {
                return defaults.bool(forKey: hideControlsKey)
            }
            return true
        }
        set {
            defaults.set(newValue, forKey: hideControlsKey)
        }
    }
    
    fileprivate let hideStatusKey = "hideStatus"
    var isHideStatusEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: hideStatusKey) {
                return defaults.bool(forKey: hideStatusKey)
            }
            return defaultConfiguration.isHideStatusEnabled
        }
        set {
            defaults.set(newValue, forKey: hideStatusKey)
        }
    }
    
    fileprivate let alertOvertimeKey = "alertOvertime"
    var isAlertOvertimeEnabled: Bool {
        get {
            if let _ = defaults.object(forKey: alertOvertimeKey) {
                return defaults.bool(forKey: alertOvertimeKey)
            }
            return defaultConfiguration.isAlertOvertimeEnabled
        }
        set {
            defaults.set(newValue, forKey: alertOvertimeKey)
        }
    }

}

extension UserDefaults {
    
    func clear() {
        for key in (self.dictionaryRepresentation().keys) {
            self.removeObject(forKey: key)
        }
        self.synchronize()
    }
    
}
