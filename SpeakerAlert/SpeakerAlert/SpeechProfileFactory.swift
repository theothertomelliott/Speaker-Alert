//
//  SpeechProfileFactory.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/16/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

class SpeechProfileFactory: NSObject {

    static func SpeechProfileWithProfile(_ profile: Profile) -> SpeechProfile {
        let green: TimeInterval = TimeInterval(profile.green!)
        let yellow: TimeInterval = TimeInterval(profile.yellow!)
        let red: TimeInterval = TimeInterval(profile.red!)
        let redBlink: TimeInterval = TimeInterval(profile.redBlink!)

        return SpeechProfile(green: green, yellow: yellow, red: red, redBlink: redBlink)
    }

}
