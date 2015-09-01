//
//  UIColor+TintAndShade.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/30/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

extension UIColor {
    
    func twe_tintWithFactor(factor: CGFloat) -> UIColor {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha : CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let antiRed = 1.0-red
        let antiGreen = 1.0-green
        let antiBlue = 1.0-blue
        
        return UIColor(red: red+(antiRed*factor), green: green+antiGreen*factor, blue: blue+antiBlue*factor, alpha: 1.0)
    }
    
    func twe_shadeWithFactor(factor: CGFloat) -> UIColor {
        
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha : CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: red*factor, green: green*factor, blue: blue*factor, alpha: 1.0)
    }
    
}