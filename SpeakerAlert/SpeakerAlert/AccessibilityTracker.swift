//
//  AccessibilityTracker.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/13/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class AccessibilityTracker: NSObject {

    var parameterManager: ParameterManager
    
    init(parameterManager: ParameterManager){
        self.parameterManager = parameterManager
        super.init()
    }

    // Should enable accessibility settings
    var accessibilityMode: Bool {
        get {
            return
                UIAccessibilityIsGrayscaleEnabled() ||
                UIAccessibilityIsVoiceOverRunning() ||
                UIAccessibilityIsSpeakScreenEnabled() ||
                parameterManager.forceAccessibility
        }
    }
    
    // TODO: Allow observation on changes
    
    
}
