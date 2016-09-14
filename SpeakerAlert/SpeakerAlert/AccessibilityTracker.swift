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
    
    // Observers who receive state updates
    private var observers = [AccessibilityObserver]()
    
    init(parameterManager: ParameterManager) {
        self.parameterManager = parameterManager
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            UIAccessibilityVoiceOverStatusChanged,
            object: nil,
            queue: nil) { (notification: NSNotification) in
                for observer in self.observers {
                    observer.accessibilityUpdated()
                }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(
            UIAccessibilityGrayscaleStatusDidChangeNotification,
            object: nil,
            queue: nil) { (notification: NSNotification) in
                for observer in self.observers {
                    observer.accessibilityUpdated()
                }
        }
    }

    // Should enable accessibility settings
    var accessibilityMode: Bool {
        get {
            return
                UIAccessibilityIsGrayscaleEnabled() ||
                UIAccessibilityIsVoiceOverRunning() ||
                parameterManager.forceAccessibility
        }
    }
    
    func addAccessibilityObserver(observer: AccessibilityObserver) {
        observers.append(observer)
    }
    
    func removeAccessibilityObserver(observer: AccessibilityObserver) {
        var index: Int? = nil
        for i in 0...(observers.count-1) {
            if let obs: NSObject = observer as? NSObject,
                let obs_i: NSObject = observers[i] as? NSObject {
                if obs === obs_i {
                    index = i
                }
            }
        }
        
        if let ix = index {
            observers.removeAtIndex(ix)
        }
        
    }
    
}

protocol AccessibilityObserver {
    
    func accessibilityUpdated()
    
}
