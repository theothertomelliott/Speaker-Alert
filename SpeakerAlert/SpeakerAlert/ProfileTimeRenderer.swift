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

    class func timeAsHMS(timeOptional: NSNumber?) -> String {
        if let time = timeOptional {
            let componentFormatter: NSDateComponentsFormatter = NSDateComponentsFormatter()
            let interval = NSTimeInterval(time.floatValue)

            return componentFormatter.stringFromTimeInterval(interval)!
        }
        return ""
    }

    class func phaseColor(phase: SpeechPhase) -> UIColor {
        var color: UIColor = UIColor.successColor()
        switch phase {
        case SpeechPhase.BELOW_MINIMUM:
            color = UIColor.blackColor()
        case SpeechPhase.GREEN:
            color = UIColor.successColor()
        case SpeechPhase.YELLOW:
            color = UIColor.warningColor()
        case SpeechPhase.RED:
            color = UIColor.dangerColor()
        case SpeechPhase.OVER_MAXIMUM:
            color = UIColor.dangerColor()
        }
        return color
    }

    class func phaseAsAttributedString(phase: SpeechPhase) -> NSAttributedString {
        var str = ""
        if let phaseName = SpeechPhase.name[phase] {
            str = "● \(phaseName)"
            if phase == SpeechPhase.OVER_MAXIMUM {
                str = "○ \(phaseName)"
            }
        }
        let outStr: NSMutableAttributedString = NSMutableAttributedString(
            string: str)

        let color = phaseColor(phase)
        outStr.addAttribute(
            NSForegroundColorAttributeName,
            value: color,
            range: NSRange(location: 0, length: 1))
        return outStr
    }

    class func timesAsAttributedString(profile: Profile) -> NSAttributedString {

        let greenStr: String = ProfileTimeRenderer.timeAsHMS(profile.green)
        let yellowStr: String = ProfileTimeRenderer.timeAsHMS(profile.yellow)
        let redStr: String = ProfileTimeRenderer.timeAsHMS(profile.red)
        let alertString: String = ProfileTimeRenderer.timeAsHMS(profile.redBlink)

        let outStr: NSMutableAttributedString = NSMutableAttributedString(
            string: "● \(greenStr) ● \(yellowStr) ● \(redStr) ○ \(alertString)")
        var index = 0

        outStr.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.successColor(),
            range: NSRange(location: index, length: 1))
        index += 1 + greenStr.characters.count + 2
        outStr.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.warningColor(),
            range: NSRange(location: index, length: 1))
        index += 1 + yellowStr.characters.count + 2
        outStr.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.dangerColor(),
            range: NSRange(location: index, length: 1))
        index += 1 + redStr.characters.count + 2
        outStr.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.dangerColor(),
            range: NSRange(location: index, length: 1))

        return outStr
    }

}
