//
//  SpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/11/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Colours

class SpeechViewController: UIViewController, SpeechManagerDelegate {

    var speechMan: SpeechManager?
    var configMan: ConfigurationManager?

    @IBOutlet weak var profileSummaryLabel: UILabel!

    @IBOutlet weak var playButton: FontAwesomeButton!
    @IBOutlet weak var stopButton: FontAwesomeButton!

    @IBOutlet weak var elapsedTimeLabel: UILabel!

    @IBOutlet weak var controls: UIView?

    var demoMode: Bool = false
    var demoState: DemoSpeechState?
    var blinkState: Bool = false
    var blinkOn: Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 10
    // Position in blink cycle
    var blinkCycleIndex = 0

    var tickTimer: NSTimer = NSTimer()

    var phaseColor: UIColor = UIColor.whiteColor()

    // MARK: Demo mode

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.demoNextPhase()
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.demoNextPhase()
    }

    func demoNextPhase() {
        if self.demoMode && self.demoState?.running == SpeechRunning.RUNNING {
            self.demoState?.nextPhase()
            self.updateDisplay()
        }
    }

    // MARK: End demo mode

    var state: SpeechState? {
        get {
            if let sm = speechMan, let st = sm.state {
                return st
            }
            if self.demoMode {
                return demoState
            }
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.demoMode {
            profileSummaryLabel?.text = "Demo Mode - Shake or tap to advance"
            self.demoState = DemoSpeechState()
        }

        // Configure speech manager if not in demo mode
        if let sm = speechMan, let profile = sm.profile where !self.demoMode {
            sm.addSpeechObserver(self)
            profileSummaryLabel?.attributedText =
                ProfileTimeRenderer.timesAsAttributedString(profile)
            self.title = sm.profile?.name
        }

        if let cm = configMan where cm.isAutoStartEnabled {
            self.resumePressed(self)
        }

        self.updateDisplay()
    }

    override func viewWillAppear(animated: Bool) {
        self.setShowTime(configMan!.isDisplayTime)
        if tickTimer.valid {
            tickTimer.invalidate()
        }
        tickTimer = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: #selector(SpeechViewController.doTick(_:)),
            userInfo: nil,
            repeats: true)
        self.updatePhase()
        self.updateDisplay()

        self.setTabBarVisible(false, animated: animated)
    }

    func doTick(timer: NSTimer) {
        self.updatePhase()
        self.updateDisplay()
    }

    override func viewWillDisappear(animated: Bool) {
        speechMan?.removeSpeechObserver(self)
        if tickTimer.valid {
            tickTimer.invalidate()
        }
    }

    func setShowTime(isVisible: Bool) {
        if let cm = configMan {
            cm.isDisplayTime = isVisible
            self.elapsedTimeLabel.hidden = !isVisible
        }
    }

    @IBAction func tapped(sender: AnyObject) {
        // If a speech is in progress, pause and display the controls
        if let c = controls where c.hidden {
            c.hidden = false
            speechMan?.pause()
        }
    }

    func setRunningMode(isRunning: Bool) {
        self.navigationController?.setNavigationBarHidden(isRunning, animated: true)
        self.profileSummaryLabel?.hidden = isRunning
        self.updateDisplay()

        // Prevent the screen dimming or locking when idle
        UIApplication.sharedApplication().idleTimerDisabled = isRunning
    }

    @IBAction func pausePressed(sender: AnyObject) {
        if self.demoMode {
            return
        }
        speechMan?.pause()
    }

    @IBAction func stopPressed(sender: AnyObject) {
        if self.demoMode {
            return
        }
        speechMan?.stop()
    }

    @IBAction func resumePressed(sender: AnyObject) {
        if self.demoMode {
            return
        }
        speechMan?.start()
    }

    func updatePhase() {
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

    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        self.updatePhase()
    }

    var lastSpeechElapsed: NSTimeInterval?
    func speechComplete(state: SpeechState, timer: SpeechTimer) {
        // Leave this speech
        lastSpeechElapsed = state.elapsed
        self.performSegueWithIdentifier("SpeechComplete", sender: self)
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
                self.playButton.enabled = true
                self.stopButton.enabled = true
                self.controls?.hidden = false
            case .RUNNING:
                self.controls?.hidden = true
            case .STOPPED:
                self.playButton.enabled = true
                self.stopButton.enabled = false
                self.controls?.hidden = false
            }
        }
    }

    func updateDisplay() {
        let running: Bool = self.state?.running == SpeechRunning.RUNNING
        self.updateTimeLabel()
        self.updateControls()

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

    func runningChanged(state: SpeechState, timer: SpeechTimer) {
        self.setRunningMode(state.running == SpeechRunning.RUNNING)
        if state.running == SpeechRunning.RUNNING {
            self.phaseChanged(state, timer: timer)
        }
        self.updateDisplay()
    }

    // MARK: - Navigation
    override func prepareForSegue(
        segue: UIStoryboardSegue,
        sender: AnyObject?) {
        if let scvc: SpeechCompleteViewController =
            segue.destinationViewController as? SpeechCompleteViewController {
            scvc.timeElapsed = lastSpeechElapsed
        }
    }

}

class ReplacementSegue: UIStoryboardSegue {

    override func perform() {
        let destinationController = self.destinationViewController

        if let navigationController = sourceViewController.navigationController {
            navigationController.popViewControllerAnimated(false)
            navigationController.pushViewController(destinationController, animated: false)
        }

    }

}

class DemoSpeechState: SpeechState {

    override var running: SpeechRunning {
        get { return SpeechRunning.RUNNING }
        set {}
    }

    private var _phase: SpeechPhase
    override var phase: SpeechPhase {
        get { return _phase }
    }

    func nextPhase() {
        // Go to the next phase
        switch self._phase {
        case .BELOW_MINIMUM:
            self._phase = .GREEN
        case .GREEN:
            self._phase = .YELLOW
        case .YELLOW:
            self._phase = .RED
        case .RED:
            self._phase = .OVER_MAXIMUM
        case .OVER_MAXIMUM:
            self._phase = .OVER_MAXIMUM
        }
    }

    override func timeUntil(phase: SpeechPhase) -> NSTimeInterval {
        return 0
    }

    init() {
        _phase = SpeechPhase.BELOW_MINIMUM
        super.init(profile: SpeechProfile(green: 0, yellow: 0, red: 0, redBlink: 0))
    }

    override func toDictionary() -> [String : AnyObject] {
        return [:]
    }
}
