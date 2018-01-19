//
//  ProfileTimeRenderer.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/6/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import Colours

class ProfileTimeRenderer: NSObject {

    class func timeAsHMS(_ timeOptional: NSNumber?) -> String {
        if let time = timeOptional {
            let componentFormatter: DateComponentsFormatter = DateComponentsFormatter()
            let interval = TimeInterval(time.floatValue)

            if let result = componentFormatter.string(from: interval) {
                return result
            }
        }
        return ""
    }

    class func phaseColor(_ phase: SpeechPhase) -> UIColor {
        var color: UIColor = UIColor.success()
        switch phase {
        case SpeechPhase.below_MINIMUM:
            color = UIColor.black
        case SpeechPhase.green:
            color = UIColor.success()
        case SpeechPhase.yellow:
            color = UIColor.warning()
        case SpeechPhase.red:
            color = UIColor.danger()
        case SpeechPhase.over_MAXIMUM:
            color = UIColor.danger()
        }
        return color
    }

    class func phaseAsAttributedString(_ phase: SpeechPhase) -> NSAttributedString {
        var str = ""
        if let phaseName = SpeechPhase.name[phase] {
            str = "● \(phaseName)"
            if phase == SpeechPhase.over_MAXIMUM {
                str = "○ \(phaseName)"
            }
        }
        let outStr: NSMutableAttributedString = NSMutableAttributedString(
            string: str)

        let color = phaseColor(phase)
        outStr.addAttribute(
            NSAttributedStringKey.foregroundColor,
            value: color,
            range: NSRange(location: 0, length: 1))
        return outStr
    }

    class func timesAsAttributedString(_ profile: Profile) -> NSAttributedString {

        let greenStr: String = ProfileTimeRenderer.timeAsHMS(profile.green)
        let yellowStr: String = ProfileTimeRenderer.timeAsHMS(profile.yellow)
        let redStr: String = ProfileTimeRenderer.timeAsHMS(profile.red)
        let alertString: String = ProfileTimeRenderer.timeAsHMS(profile.redBlink)

        let outStr: NSMutableAttributedString = NSMutableAttributedString(
            string: "● \(greenStr) ● \(yellowStr) ● \(redStr) ▾ \(alertString)")
        var index = 0

        outStr.addAttribute(
            NSAttributedStringKey.foregroundColor,
            value: UIColor.success(),
            range: NSRange(location: index, length: 1))
        index += 1 + greenStr.count + 2
        outStr.addAttribute(
            NSAttributedStringKey.foregroundColor,
            value: UIColor.warning(),
            range: NSRange(location: index, length: 1))
        index += 1 + yellowStr.count + 2
        outStr.addAttribute(NSAttributedStringKey.foregroundColor,
            value: UIColor.danger(),
            range: NSRange(location: index, length: 1))
        index += 1 + redStr.count + 2
        outStr.addAttribute(NSAttributedStringKey.foregroundColor,
            value: UIColor.danger(),
            range: NSRange(location: index, length: 1))

        return outStr
    }

}
