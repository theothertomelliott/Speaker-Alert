//
//  ConfigurationMode.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/6/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation

struct ConfigurationMode: ModeConfiguration {
    
    var name: String = ""
    
    var timeDisplayMode: TimeDisplay
    var isVibrationEnabled: Bool = false
    var isAudioEnabled: Bool = false
    var isHideStatusEnabled: Bool = false
    var isAlertOvertimeEnabled: Bool = false
    
}
