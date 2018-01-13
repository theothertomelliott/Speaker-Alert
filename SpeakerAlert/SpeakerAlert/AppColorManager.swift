//
//  AppColorManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/30/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Colours

open class AppColorManager: NSObject {

    fileprivate var _baseColor: UIColor?
    var baseColor: UIColor? {
        get {
            return _baseColor
        }
        set(newColor) {
            _baseColor = newColor
            self.configureColorsFrom(newColor!)
        }
    }

    open func configureColorsFrom(_ base: UIColor) {

        if let baseColor = base.darken(0.1) {
            
            if let colors = baseColor.colorScheme(ofType: ColorScheme.monochromatic) {
                
                // Tab bar background
                UITabBar.appearance().barTintColor = baseColor
                // Selected image color
                UITabBar.appearance().tintColor = baseColor.blackOrWhiteContrasting()
                
                UITabBarItem.appearance().setTitleTextAttributes(
                    [NSAttributedStringKey.foregroundColor: colors[2]], for: UIControlState())
                UITabBarItem.appearance().setTitleTextAttributes(
                    [NSAttributedStringKey.foregroundColor: baseColor.blackOrWhiteContrasting()],
                    for: UIControlState.selected)
                
                UINavigationBar.appearance().tintColor = colors[1] as? UIColor
                UINavigationBar.appearance().barTintColor = baseColor
                UINavigationBar.appearance().isTranslucent = false
                UINavigationBar.appearance().titleTextAttributes = [
                    NSAttributedStringKey.foregroundColor: baseColor.blackOrWhiteContrasting()
                ]
                
            }
            
        }
    }

}
