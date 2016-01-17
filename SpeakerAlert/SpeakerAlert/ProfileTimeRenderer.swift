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
