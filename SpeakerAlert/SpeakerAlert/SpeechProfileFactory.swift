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
        let green: TimeInterval = TimeInterval(truncating: profile.green!)
        let yellow: TimeInterval = TimeInterval(truncating: profile.yellow!)
        let red: TimeInterval = TimeInterval(truncating:profile.red!)
        let redBlink: TimeInterval = TimeInterval(truncating:profile.redBlink!)

        return SpeechProfile(green: green, yellow: yellow, red: red, redBlink: redBlink)
    }

}
