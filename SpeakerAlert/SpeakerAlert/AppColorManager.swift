//
//  AppColorManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/30/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Colours

public class AppColorManager: NSObject {

    private var _baseColor: UIColor?
    var baseColor: UIColor? {
        get {
            return _baseColor
        }
        set(newColor) {
            _baseColor = newColor
            self.configureColorsFrom(newColor!)
        }
    }

    public func configureColorsFrom(base: UIColor) {

        let baseColor = base.darken(0.1)

        let colors = baseColor.colorSchemeOfType(ColorScheme.Monochromatic)

        // Tab bar background
        UITabBar.appearance().barTintColor = baseColor
        // Selected image color
        UITabBar.appearance().tintColor = baseColor.blackOrWhiteContrastingColor()

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSForegroundColorAttributeName: colors[2]], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSForegroundColorAttributeName: baseColor.blackOrWhiteContrastingColor()],
            forState: UIControlState.Selected)

        UINavigationBar.appearance().tintColor = colors[1] as? UIColor
        UINavigationBar.appearance().barTintColor = baseColor
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: baseColor.blackOrWhiteContrastingColor()
        ]

    }

}
