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
    fileprivate var observers = [AccessibilityObserver]()
    
    init(parameterManager: ParameterManager) {
        self.parameterManager = parameterManager
        super.init()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged),
            object: nil,
            queue: nil) { (notification: Notification) in
                for observer in self.observers {
                    observer.accessibilityUpdated()
                }
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIAccessibilityGrayscaleStatusDidChange,
            object: nil,
            queue: nil) { (notification: Notification) in
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
    
    func addAccessibilityObserver(_ observer: AccessibilityObserver) {
        observers.append(observer)
    }
    
    func removeAccessibilityObserver(_ observer: AccessibilityObserver) {
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
            observers.remove(at: ix)
        }
        
    }
    
}

protocol AccessibilityObserver {
    
    func accessibilityUpdated()
    
}
