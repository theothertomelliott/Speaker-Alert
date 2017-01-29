//
//  SpeechProfile.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/16/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class SpeechProfile: NSObject {

    init(green: TimeInterval,
        yellow: TimeInterval,
        red: TimeInterval,
        redBlink: TimeInterval) {
        self.green = green
        self.yellow = yellow
        self.red = red
        self.redBlink = redBlink
    }

    var green: TimeInterval
    var red: TimeInterval
    var redBlink: TimeInterval
    var yellow: TimeInterval

}
