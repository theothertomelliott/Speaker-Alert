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
    @IBOutlet weak var timeIntervalField: TWETimeIntervalField!

    var phase: SpeechPhase?

    private var profileUpdateReceiver: ProfileTableViewController?

    func updateValue(value: NSTimeInterval) {
        if let phase = self.phase {
            self.profileUpdateReceiver?.phaseTimes[phase] = value
        }
        self.updateValues()
        self.profileUpdateReceiver?.phaseUpdated()
    }

    @IBAction func timeIntervalFieldUpdated(sender: AnyObject) {
        self.updateValue(self.timeIntervalField.timeInterval)
    }

    func setProfileUpdateReceiver(
        profileUpdateReceiver: ProfileTableViewController,
        phase: SpeechPhase) {
        self.profileUpdateReceiver = profileUpdateReceiver
        self.phase = phase
        self.updateValues()
    }

    func updateValues() {
        if let phase = self.phase {
            if let interval = self.profileUpdateReceiver?.phaseTimes[phase] {
                timeIntervalField?.timeInterval = interval
                timeLabel.text = "\(interval)"
            }
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
