//
//  DefaultSpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/24/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class DefaultSpeechViewController: SpeechViewController, AccessibilityObserver {

    @IBOutlet weak var profileSummaryLabel: UILabel!
    
    @IBOutlet weak var playButton: FontAwesomeButton!
    @IBOutlet weak var stopButton: FontAwesomeButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var inSpeechTimeLabel: UILabel!
    
    @IBOutlet weak var controls: UIView?
    
    @IBOutlet weak var pausedLabel: UILabel?
    
    var phaseColor: UIColor = UIColor.white
    
    var blinkState: Bool = false
    var blinkOn: Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 10
    // Position in blink cycle
    var blinkCycleIndex = 0
    
    fileprivate var shouldShowTime: Bool = false
    
    @IBAction func tapped(_ sender: AnyObject) {
        // If a speech is in progress, pause and display the controls
        if let c = controls, c.isHidden {
            c.isHidden = false
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
        if let profile = speechMan.profile, !self.demoMode {
            profileSummaryLabel?.attributedText =
                ProfileTimeRenderer.timesAsAttributedString(profile)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accessibilityTracker.addAccessibilityObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        accessibilityTracker.removeAccessibilityObserver(self)
    }
    
    
    func accessibilityUpdated() {
        self.updateDisplay()
    }
    
    override func setShowTime(_ isVisible: Bool) {
        self.shouldShowTime = isVisible
    }
    
    override func updatePhase() {
        if let phase = self.state?.phase {
            blinkState = false
            if phase == SpeechPhase.below_MINIMUM {
                self.phaseColor = UIColor.white
                self.pausedLabel?.text = "Below minimum"
            }
            if phase == SpeechPhase.green {
                self.phaseColor = UIColor.success()
                self.pausedLabel?.text = "Green"
            }
            if phase == SpeechPhase.yellow {
                self.phaseColor = UIColor.warning()
                self.pausedLabel?.text = "Yellow"
            }
            if phase == SpeechPhase.red {
                self.phaseColor = UIColor.danger()
                self.pausedLabel?.text = "Red"
            }
            if phase == SpeechPhase.over_MAXIMUM {
                self.phaseColor = UIColor.danger()
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
            
            let running: Bool = state.running == SpeechRunning.running
            
            var timeToDisplay: Double = state.elapsed
            if configMan.timeDisplayMode == TimeDisplay.CountDown {
                timeToDisplay = state.timeUntil(SpeechPhase.red)
                if timeToDisplay < 0 {
                    timeToDisplay = 0
                }
            }
            
            let timeStr = TimeUtils.formatStopwatch(Int(timeToDisplay))
            var timeAttr: NSMutableAttributedString =
                NSMutableAttributedString(string: "\(timeStr)")
            if !running {
                timeAttr = NSMutableAttributedString(string: "● \(timeStr)")
                if state.phase == SpeechPhase.over_MAXIMUM {
                    timeAttr = NSMutableAttributedString(string: "▾ \(timeStr)")
                }
                if state.phase == SpeechPhase.below_MINIMUM {
                    timeAttr = NSMutableAttributedString(string: "◦ \(timeStr)")
                } else {
                    timeAttr.addAttribute(
                        NSForegroundColorAttributeName,
                        value: self.phaseColor,
                        range: NSRange(location: 0, length: 1))
                }
            }
            
            timeLabel.attributedText = timeAttr
            inSpeechTimeLabel.attributedText = timeAttr
            
            timeLabel.isHidden = running
            timeLabel.alpha = shouldShowTime ? 1 : 0.3
            inSpeechTimeLabel.isHidden = !shouldShowTime || !running
        }
    }
    
    func shouldHideControls() -> Bool {
        if accessibilityTracker.accessibilityMode {
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
            case .paused:
                self.stopButton.isEnabled = true
                self.controls?.isHidden = false
                self.pausedLabel?.isHidden = false
                self.pausedLabel?.text = "Paused"
                self.playButton.setIconAndAccessibility("Play")
            case .running:
                if shouldHideControls() {
                    self.controls?.isHidden = true
                } else {
                self.playButton.setIconAndAccessibility("Pause")
                    self.stopButton.isEnabled = true
                }
                self.pausedLabel?.isHidden = !accessibilityTracker.accessibilityMode
            case .stopped:
                self.playButton.setIconAndAccessibility("Play")
                self.stopButton.isEnabled = false
                self.controls?.isHidden = false
                self.pausedLabel?.isHidden = true
            }
        }
    }
    
    override func updateDisplay() {
        let running: Bool = self.state?.running == SpeechRunning.running
        self.updateTimeLabel()
        self.updateControls()
        
        self.profileSummaryLabel?.isHidden = running
        
        if running {
            if blinkState {
                if blinkCycleIndex >= blinkCycle {
                    blinkCycleIndex = 0
                }
                if blinkCycleIndex == 0 {
                    if blinkOn {
                        self.view.backgroundColor = phaseColor
                    } else {
                        self.view.backgroundColor = UIColor.white
                    }
                    blinkOn = !blinkOn
                }
                blinkCycleIndex += 1
            } else {
                self.view.backgroundColor = phaseColor
            }
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
    }
    
}
