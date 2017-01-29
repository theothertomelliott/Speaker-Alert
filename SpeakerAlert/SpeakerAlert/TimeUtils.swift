//
//  TimeUtils.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/19/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class TimeUtils: NSObject {

    static func formatTime(_ interval: NSNumber) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated

        var components = DateComponents()
        components.minute = Int(interval)/60
        components.second = Int(interval)%60

        return formatter.string(from: components)!
    }

    static func formatStopwatch(_ interval: NSNumber) -> String {
        var components = DateComponents()
        components.minute = Int(interval)/60
        components.second = Int(interval)%60

        let secondStr: String = String(format: "%02d", components.second!)

        return "\(String(describing: components.minute)):\(secondStr)"
    }

}
