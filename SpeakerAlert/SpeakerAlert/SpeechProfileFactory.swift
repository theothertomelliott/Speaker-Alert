//
//  SpeechProfileFactory.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/16/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class SpeechProfileFactory: NSObject {

    static func SpeechProfileWithProfile(profile: Profile) -> SpeechProfile {
        let green : NSTimeInterval = NSTimeInterval(profile.green!)
        let yellow : NSTimeInterval = NSTimeInterval(profile.yellow!)
        let red : NSTimeInterval = NSTimeInterval(profile.red!)
        let redBlink : NSTimeInterval = NSTimeInterval(profile.redBlink!)
        
        return SpeechProfile(green: green, yellow: yellow, red: red, redBlink: redBlink)
    }
    
}
