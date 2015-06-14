//
//  Timing.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/13/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

public class Timing {
    
    /// Name to identify this timer
    var name : NSString;
    
    /// Interval at which the green signal will be triggered
    var green : NSTimeInterval = 5*60;
    /// Interval at whcih the yellow signal will be triggered
    var yellow : NSTimeInterval = 6*60;
    /// Interval at which the red signal will be triggered
    var red : NSTimeInterval = 7*60;
    /// Interval at which the blinking red signal will be triggered
    var redBlink : NSTimeInterval = 7*60 + 30;
    
    /**
        Initializes a timer with the provider name and intervals
    
        :param: name        Name for this Timing configuration
        :param: green       Interval until the green signal should be triggered
        :param: yellow      Interval until the yellow signal should be triggered
        :param: red         Interval until the red signal should be triggered
        :param: redBlink    Interval until the blinking red signal should be triggered
    
        :return:    A new timer
    */
    init(withName name : NSString, greenInterval green : NSTimeInterval, yellowInterval yellow : NSTimeInterval, redInterval red : NSTimeInterval, redBlinkInterval redBlink : NSTimeInterval){
        self.name = name;
        self.green = green;
        self.yellow = yellow;
        self.red = red;
        self.redBlink = redBlink;
    }
    
    /**
        Initializer with a name and default intervals
    
        :param: name Name for this Timing configuration
     */
    init(withName name : NSString){
        self.name = name;
    }
    
}