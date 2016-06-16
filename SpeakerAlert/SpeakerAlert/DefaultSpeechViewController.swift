//
//  DefaultSpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/24/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class DefaultSpeechViewController: SpeechViewController {

    @IBOutlet weak var profileSummaryLabel: UILabel!
    
    @IBOutlet weak var playButton: FontAwesomeButton!
    @IBOutlet weak var stopButton: FontAwesomeButton!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    @IBOutlet weak var controls: UIView?
    
    @IBOutlet weak var pausedLabel: UILabel?
    
    var phaseColor: UIColor = UIColor.whiteColor()
    
    var blinkState: Bool = false
    var blinkOn: Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 10
    // Position in blink cycle
    var blinkCycleIndex = 0
    
    @IBAction func tapped(sender: AnyObject) {
        // If a speech is in progress, pause and display the controls
        if let c = controls where c.hidden {
            c.hidden = false
            speechMan?.pause()
        }
        
        self.demoNextPhase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.demoMode {
            profileSummaryLabel?.text = "Demo Mode - Shake or tap to advance"
        }

        // Configure speech manager if not in demo mode
        if let sm = speechMan, let profile = sm.profile where !self.demoMode {
            profileSummaryLabel?.attributedText =
                ProfileTimeRenderer.timesAsAttributedString(profile)
        }
    }
    
    override func setShowTime(isVisible: Bool) {
        self.elapsedTimeLabel.hidden = !isVisible
    }
    
    override func updatePhase() {
        if let phase = self.state?.phase {
            blinkState = false
            if phase == SpeechPhase.BELOW_MINIMUM {
                self.phaseColor = UIColor.whiteColor()
            }
            if phase == SpeechPhase.GREEN {
                self.phaseColor = UIColor.successColor()
            }
            if phase == SpeechPhase.YELLOW {
                self.phaseColor = UIColor.warningColor()
            }
            if phase == SpeechPhase.RED {
                self.phaseColor = UIColor.dangerColor()
            }
            if phase == SpeechPhase.OVER_MAXIMUM {
                self.phaseColor = UIColor.dangerColor()
                blinkState = true
            }
        }
    }
    
    func updateTimeLabel() {
        
        if let state = speechMan?.state {
            
            let running: Bool = state.running == SpeechRunning.RUNNING
            let timeStr = TimeUtils.formatStopwatch(state.elapsed)
            var timeAttr: NSMutableAttributedString =
                NSMutableAttributedString(string: "\(timeStr)")
            if !running {
                timeAttr = NSMutableAttributedString(string: "● \(timeStr)")
                if state.phase == SpeechPhase.OVER_MAXIMUM {
                    timeAttr = NSMutableAttributedString(string: "◎ \(timeStr)")
                }
                if state.phase == SpeechPhase.BELOW_MINIMUM {
                    timeAttr = NSMutableAttributedString(string: "◦ \(timeStr)")
                } else {
                    timeAttr.addAttribute(
                        NSForegroundColorAttributeName,
                        value: self.phaseColor,
                        range: NSRange(location: 0, length: 1))
                }
            }
            
            elapsedTimeLabel.attributedText = timeAttr
            
        }
    }
    
    func updateControls() {
        if let state = self.state {
            switch state.running {
            case .PAUSED:
                self.stopButton.enabled = true
                self.controls?.hidden = false
                self.pausedLabel?.hidden = false
                self.playButton.setIconAndAccessibilityIdentifier("Play")
            case .RUNNING:
                if let hc = configMan?.isHideControlsEnabled where hc {
                    self.controls?.hidden = true
                } else {
                self.playButton.setIconAndAccessibilityIdentifier("Pause")
                    self.stopButton.enabled = true
                }
                self.pausedLabel?.hidden = true
            case .STOPPED:
                self.playButton.setIconAndAccessibilityIdentifier("Play")
                self.stopButton.enabled = false
                self.controls?.hidden = false
                self.pausedLabel?.hidden = true
            }
        }
    }
    
    override func updateDisplay() {
        let running: Bool = self.state?.running == SpeechRunning.RUNNING
        self.updateTimeLabel()
        self.updateControls()
        
        self.profileSummaryLabel?.hidden = running
        
        if running {
            if blinkState {
                if blinkCycleIndex >= blinkCycle {
                    blinkCycleIndex = 0
                }
                if blinkCycleIndex == 0 {
                    if blinkOn {
                        self.view.backgroundColor = phaseColor
                    } else {
                        self.view.backgroundColor = UIColor.whiteColor()
                    }
                    blinkOn = !blinkOn
                }
                blinkCycleIndex += 1
            } else {
                self.view.backgroundColor = phaseColor
            }
        } else {
            self.view.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
}
