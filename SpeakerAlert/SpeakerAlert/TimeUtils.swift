//
//  TimeUtils.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/19/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class TimeUtils: NSObject {

    static func formatTime(interval: NSNumber) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Abbreviated

        let components = NSDateComponents()
        components.minute = Int(interval)/60
        components.second = Int(interval)%60

        return formatter.stringFromDateComponents(components)!
    }

    static func formatStopwatch(interval: NSNumber) -> String {
        let components = NSDateComponents()
        components.minute = Int(interval)/60
        components.second = Int(interval)%60

        let secondStr: String = String(format: "%02d", components.second)

        return "\(components.minute):\(secondStr)"
    }

}
