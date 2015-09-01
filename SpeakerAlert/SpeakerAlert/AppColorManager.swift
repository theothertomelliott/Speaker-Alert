//
//  AppColorManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/30/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

public class AppColorManager: NSObject {

    private var _baseColor : UIColor?
    var baseColor : UIColor? {
        get {
            return _baseColor
        }
        set(newColor) {
            _baseColor = newColor
            self.configureColorsFrom(newColor!)
        }
    }
    
    public func configureColorsFrom(baseColor: UIColor){
        
        let highlight : UIColor = baseColor.twe_tintWithFactor(0.9)
        let shadow : UIColor  = baseColor.twe_shadeWithFactor(0.25)
        
        // Tab bar background
        UITabBar.appearance().barTintColor = baseColor
        // Selected image color
        UITabBar.appearance().tintColor = highlight
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: shadow], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: highlight], forState: UIControlState.Selected)
        
        UINavigationBar.appearance().tintColor = highlight
        UINavigationBar.appearance().barTintColor = baseColor
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: shadow
        ]
        
    }
    
}
