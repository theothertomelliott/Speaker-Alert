//
//  ProfileTimeTableViewCell.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/12/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Colours

class ProfileTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var colorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var phase: SpeechPhase?

    func setControllerAndPhase(
        _ controller: ProfileTableViewController,
        phase: SpeechPhase) {
            self.phase = phase
            if let phase = self.phase {
                colorNameLabel.attributedText = ProfileTimeRenderer.phaseAsAttributedString(phase)
                if let interval = controller.phaseTimes[phase] {
                    timeLabel.text = TimeUtils.formatStopwatch(Int(interval))

                    if let name = SpeechPhase.name[phase] {
                        self.isAccessibilityElement = true
                        self.accessibilityIdentifier = name
                        self.accessibilityLabel = "\(name): \(TimeUtils.formatStopwatch(Int(interval)))"
                    }
                }
            }
    }

}
