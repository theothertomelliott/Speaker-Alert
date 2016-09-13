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
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var controls: UIView?
    
    @IBOutlet weak var pausedLabel: UILabel?
    
    var phaseColor: UIColor = UIColor.whiteColor()
    
    var blinkState: Bool = false
    var blinkOn: Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 10
    // Position in blink cycle
    var blinkCycleIndex = 0
    
    var voiceOverEnabled: Bool = false
    
    @IBAction func tapped(sender: AnyObject) {
        // If a speech is in progress, pause and display the controls
        if let c = controls where c.hidden {
            c.hidden = false
            speechMan.pause()
        }
        
        self.demoNextPhase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.demoMode {
            profileSummaryLabel?.text = "Demo Mode - Shake or tap to advance"
        }

        // Configure speech manager if not in demo mode
        if let profile = speechMan.profile where !self.demoMode {
            profileSummaryLabel?.attributedText =
                ProfileTimeRenderer.timesAsAttributedString(profile)
        }
        
        voiceOverEnabled = accessibilityTracker.accessibilityMode
        
        NSNotificationCenter.defaultCenter().addObserverForName(
        UIAccessibilityVoiceOverStatusChanged,
        object: nil,
        queue: nil) { (notification: NSNotification) in
            self.voiceOverEnabled = UIAccessibilityIsVoiceOverRunning()
            self.updateDisplay()
        }
    }
    
    override func setShowTime(isVisible: Bool) {
        self.timeLabel.hidden = !isVisible
    }
    
    override func updatePhase() {
        if let phase = self.state?.phase {
            blinkState = false
            if phase == SpeechPhase.BELOW_MINIMUM {
                self.phaseColor = UIColor.whiteColor()
                self.pausedLabel?.text = "Below minimum"
            }
            if phase == SpeechPhase.GREEN {
                self.phaseColor = UIColor.successColor()
                self.pausedLabel?.text = "Green"
            }
            if phase == SpeechPhase.YELLOW {
                self.phaseColor = UIColor.warningColor()
                self.pausedLabel?.text = "Yellow"
            }
            if phase == SpeechPhase.RED {
                self.phaseColor = UIColor.dangerColor()
                self.pausedLabel?.text = "Red"
            }
            if phase == SpeechPhase.OVER_MAXIMUM {
                self.phaseColor = UIColor.dangerColor()
                if configMan.isAlertOvertimeEnabled {
                    self.pausedLabel?.text = "Alert!"
                    blinkState = true
                } else {
                    self.pausedLabel?.text = "Red"
                }
            }
            
        }
    }
    
    func updateTimeLabel() {
        
        if let state = speechMan.state {
            
            let running: Bool = state.running == SpeechRunning.RUNNING
            
            var timeToDisplay: Double = state.elapsed
            if configMan.timeDisplayMode == TimeDisplay.CountDown {
                timeToDisplay = state.timeUntil(SpeechPhase.RED)
                if timeToDisplay < 0 {
                    timeToDisplay = 0
                }
            }
            
            let timeStr = TimeUtils.formatStopwatch(timeToDisplay)
            var timeAttr: NSMutableAttributedString =
                NSMutableAttributedString(string: "\(timeStr)")
            if !running {
                timeAttr = NSMutableAttributedString(string: "● \(timeStr)")
                if state.phase == SpeechPhase.OVER_MAXIMUM {
                    timeAttr = NSMutableAttributedString(string: "▾ \(timeStr)")
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
            
            timeLabel.attributedText = timeAttr
            
        }
    }
    
    func shouldHideControls() -> Bool {
        if voiceOverEnabled {
            return false
        }
        
        if configMan.isHideControlsEnabled {
            return true
        }
        return false
    }
    
    func updateControls() {
        self.stopButton.setIconAndAccessibility("Stop")
        if let state = self.state {
            switch state.running {
            case .PAUSED:
                self.stopButton.enabled = true
                self.controls?.hidden = false
                self.pausedLabel?.hidden = false
                self.pausedLabel?.text = "Paused"
                self.playButton.setIconAndAccessibility("Play")
            case .RUNNING:
                if shouldHideControls() {
                    self.controls?.hidden = true
                } else {
                self.playButton.setIconAndAccessibility("Pause")
                    self.stopButton.enabled = true
                }
                self.pausedLabel?.hidden = !voiceOverEnabled
            case .STOPPED:
                self.playButton.setIconAndAccessibility("Play")
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
