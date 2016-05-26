//
//  UITestSpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/26/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class UITestSpeechViewController: DefaultSpeechViewController {

    @IBOutlet var colorLabel: UILabel?
    
    override func updatePhase() {
        super.updatePhase()
        
        if let phase = self.state?.phase {
            if phase == SpeechPhase.BELOW_MINIMUM {
                colorLabel?.text = "Below minimum"
            }
            if phase == SpeechPhase.GREEN {
                colorLabel?.text = "Green"
            }
            if phase == SpeechPhase.YELLOW {
                colorLabel?.text = "Yellow"
            }
            if phase == SpeechPhase.RED {
                colorLabel?.text = "Red"
            }
            if phase == SpeechPhase.OVER_MAXIMUM {
                colorLabel?.text = "Alert"
            }
        }
    }

    
}
