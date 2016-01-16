//
//  SpeechProfile.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/16/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class SpeechProfile: NSObject {

    init(green: NSTimeInterval, yellow: NSTimeInterval, red: NSTimeInterval, redBlink: NSTimeInterval) {
        self.green = green
        self.yellow = yellow
        self.red = red
        self.redBlink = redBlink
    }

    var green: NSTimeInterval
    var red: NSTimeInterval
    var redBlink: NSTimeInterval
    var yellow: NSTimeInterval

}
