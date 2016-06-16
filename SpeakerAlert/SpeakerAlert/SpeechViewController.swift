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

    var demoMode: Bool = false
    var demoState: DemoSpeechState?

    var tickTimer: NSTimer = NSTimer()

    // MARK: Demo mode

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.demoNextPhase()
        }
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
            self.demoState = DemoSpeechState()
        }

        // Configure speech manager if not in demo mode
        if let sm = speechMan, let profile = sm.profile where !self.demoMode {
            sm.addSpeechObserver(self)
            self.title = profile.name
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
        setNavSatusVisible(true, animated: animated)
        speechMan?.removeSpeechObserver(self)
        if tickTimer.valid {
            tickTimer.invalidate()
        }
    }

    func setNavSatusVisible(visible: Bool, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(
            !visible,
            withAnimation: animated ? UIStatusBarAnimation.Slide : UIStatusBarAnimation.None)
        self.navigationController?.setNavigationBarHidden(!visible, animated: animated)
    }
    
    func setShowTime(isVisible: Bool) {
    }

    func setRunningMode(isRunning: Bool) {
        self.setNavSatusVisible(!isRunning, animated: true)
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
        if self.state?.running == .RUNNING {
            speechMan?.pause()
        } else {
            speechMan?.start()
        }
    }

    func updatePhase() {
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

    func updateDisplay() {
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
        setNavSatusVisible(true, animated: false)
        if let scvc: SpeechCompleteViewController =
            segue.destinationViewController as? SpeechCompleteViewController {
            scvc.timeElapsed = lastSpeechElapsed
        }
    }

}
