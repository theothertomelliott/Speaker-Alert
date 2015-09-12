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
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeIntervalField: TWETimeIntervalField!
    
    private var profileUpdateReceiver : ProfileTableViewController?
    private var phase : SpeechPhase?
    private var previousPhase : SpeechPhase?
    private var nextPhase : SpeechPhase?
    
    func updateValue(value : NSTimeInterval){
        if let phase = self.phase {
            self.profileUpdateReceiver?.phaseTimes[phase] = value
        }
        self.validateValues()
        self.updateValues()
        self.profileUpdateReceiver?.phaseUpdated()
    }
    
    @IBAction func sliderUpdated(sender: AnyObject) {
        self.updateValue(NSTimeInterval(self.timeSlider.value))
    }
    
    @IBAction func timeIntervalFieldUpdated(sender: AnyObject) {
        self.updateValue(self.timeIntervalField.timeInterval)
    }
    
    func validateValues(){
        if let phase = self.phase {
            if let receiver = self.profileUpdateReceiver {
            let phaseValue = receiver.phaseTimes[phase]
            if let nextPhase = self.nextPhase {
                if receiver.phaseTimes[nextPhase] < phaseValue {
                    receiver.phaseTimes[nextPhase] = phaseValue
                }
            }
            if let previousPhase = self.previousPhase {
                if receiver.phaseTimes[previousPhase] > phaseValue {
                    receiver.phaseTimes[previousPhase] = phaseValue
                }
            }
        }
    }
    }
    
    func setProfileUpdateReceiver(profileUpdateReceiver : ProfileTableViewController, phase : SpeechPhase, nextPhase : SpeechPhase?, previousPhase : SpeechPhase?){
        self.profileUpdateReceiver = profileUpdateReceiver
        self.phase = phase
        self.nextPhase = nextPhase
        self.previousPhase = previousPhase
        
        switch (phase) {
        case .GREEN:
            colorNameLabel.text = "Green"
            timeSlider.maximumTrackTintColor = UIColor.successColor()
        case .YELLOW:
            colorNameLabel.text = "Yellow"
            timeSlider.maximumTrackTintColor = UIColor.warningColor()
        case.RED:
            colorNameLabel.text = "Red"
            timeSlider.maximumTrackTintColor = UIColor.dangerColor()
        case.OVER_MAXIMUM:
            colorNameLabel.text = "Alert!"
            timeSlider.maximumTrackTintColor = UIColor.dangerColor()
        default:
            colorNameLabel.text = "Unknown Phase"
        }
        timeSlider.minimumTrackTintColor = timeSlider.maximumTrackTintColor
        
        if let max = self.profileUpdateReceiver?.phaseTimes[SpeechPhase.OVER_MAXIMUM] {
            timeSlider.maximumValue = Float(max * 1.1)
        }
        
        self.updateValues()
    }
    
    func updateValues(){
        if let phase = self.phase {
            if let max = self.profileUpdateReceiver?.phaseTimes[SpeechPhase.OVER_MAXIMUM] {
                if timeSlider.maximumValue < Float(max * 1.1) {
                    timeSlider.maximumValue = Float(max * 1.1)
                }
            }
            if let interval = self.profileUpdateReceiver?.phaseTimes[phase] {
                timeIntervalField.timeInterval = interval
                timeSlider.value = Float(interval)
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
