//
//  ConfigurationManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class ConfigurationManager: NSObject {

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

}
