//
//  ProfileTimeTableViewCell.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/12/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import TWETimeIntervalField
import Colours

class ProfileTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var colorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var phase: SpeechPhase?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setControllerAndPhase(
        controller: ProfileTableViewController,
        phase: SpeechPhase) {
            self.phase = phase
            if let phase = self.phase {
                colorNameLabel.text = SpeechPhase.name[phase]
                if let interval = controller.phaseTimes[phase] {
                    timeLabel.text = TimeUtils.formatTime(interval)
                }
            }
    }

}
