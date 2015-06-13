//
//  Timing.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/13/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class Timing {
    
    var name : NSString;
    
    var green : NSTimeInterval = 5*60;
    var yellow : NSTimeInterval = 6*60;
    var red : NSTimeInterval = 7*60;
    var redBlink : NSTimeInterval = 7*60 + 30;
    
    init(withName name : NSString, greenInterval green : NSTimeInterval, yellowInterval yellow : NSTimeInterval, redInterval red : NSTimeInterval, redBlinkInterval redBlink : NSTimeInterval){
        self.name = name;
        self.green = green;
        self.yellow = yellow;
        self.red = red;
        self.redBlink = redBlink;
    }
    
    /**
     * Initializer with a name and default intervals;
     */
    init(withName name : NSString){
        self.name = name;
    }
    
}