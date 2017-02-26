//
//  SpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/11/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Colours

class SpeechViewController: UIViewController,
                            SpeechManagerDelegate,
                            SpeechManagerDependency,
                            ConfigurationManagerDependency,
                            ParameterManagerDependency,
                            AccessibilityTrackerDependency {

    var speechMan: SpeechManager
    var configMan: ConfigurationManager
    var accessibilityTracker: AccessibilityTracker

    var demoMode: Bool = false
    var demoState: DemoSpeechState?

    var tickTimer: Timer = Timer()

    // Initializers for the app, using property injection
    required init?(coder aDecoder: NSCoder) {
        speechMan = SpeechViewController._speechManager()
        configMan = SpeechViewController._configurationManager()
        accessibilityTracker = SpeechViewController._accessibilityTracker()
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        speechMan = SpeechViewController._speechManager()
        configMan = SpeechViewController._configurationManager()
        accessibilityTracker = SpeechViewController._accessibilityTracker()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Initializer for testing, using initializer injection
    init(
        speechManager: SpeechManager,
        configurationManager: ConfigurationManager,
        accessibilityTracker: AccessibilityTracker
        ) {
        self.speechMan = speechManager
        self.configMan = configurationManager
        self.accessibilityTracker = accessibilityTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Demo mode

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.demoNextPhase()
        }
    }

    func demoNextPhase() {
        if self.demoMode && self.demoState?.running == SpeechRunning.running {
            self.demoState?.nextPhase()
            self.updateDisplay()
        }
    }

    // MARK: End demo mode

    var state: SpeechState? {
        get {
            if self.demoMode {
                return demoState
            }
            return speechMan.state
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.demoMode {
            self.demoState = DemoSpeechState()
        }

        // Configure speech manager if not in demo mode
        if let profile = speechMan.profile, !self.demoMode {
            speechMan.addSpeechObserver(self)
            self.title = profile.name
        }
        
        if configMan.isAutoStartEnabled {
            self.resumePressed(self)
        }
        
        self.updateDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setShowTime(configMan.timeDisplayMode != TimeDisplay.None)
        if tickTimer.isValid {
            tickTimer.invalidate()
        }
        tickTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(SpeechViewController.doTick(_:)),
            userInfo: nil,
            repeats: true)
        self.updatePhase()
        self.updateDisplay()

        self.setTabBarVisible(false, animated: animated)
    }

    func doTick(_ timer: Timer) {
        self.updatePhase()
        self.updateDisplay()
    }

    override func viewWillDisappear(_ animated: Bool) {
        setNavSatusVisible(true, animated: animated)
        speechMan.removeSpeechObserver(self)
        if tickTimer.isValid {
            tickTimer.invalidate()
        }
    }

    func setNavSatusVisible(_ visible: Bool, animated: Bool) {
        if configMan.isHideStatusEnabled {
            UIApplication.shared.setStatusBarHidden(
                !visible,
                with: animated ? UIStatusBarAnimation.slide : UIStatusBarAnimation.none)
        }
        self.navigationController?.setNavigationBarHidden(!visible, animated: animated)
    }
    
    func setShowTime(_ isVisible: Bool) {
    }

    func setRunningMode(_ isRunning: Bool) {
        self.setNavSatusVisible(false, animated: true)
        self.updateDisplay()

        // Prevent the screen dimming or locking when idle
        UIApplication.shared.isIdleTimerDisabled = isRunning
    }

    @IBAction func pausePressed(_ sender: AnyObject) {
        if self.demoMode {
            return
        }
        speechMan.pause()
    }

    @IBAction func stopPressed(_ sender: AnyObject) {
        if self.demoMode {
            return
        }
        speechMan.stop()
    }

    @IBAction func resetPressed(_ sender: AnyObject) {
        if self.demoMode {
            return
        }
        speechMan.reset()
    }

    
    @IBAction func resumePressed(_ sender: AnyObject) {
        if self.demoMode {
            return
        }
        if self.state?.running == .running {
            speechMan.pause()
        } else {
            speechMan.start()
        }
    }

    func updatePhase() {
    }

    func phaseChanged(_ state: SpeechState, timer: SpeechTimer) {
        self.updatePhase()
    }

    var lastSpeechRecord: Speech?
    func speechComplete(_ state: SpeechState, timer: SpeechTimer, record: Speech) {
        // Leave this speech
        lastSpeechRecord = record
        self.performSegue(withIdentifier: "SpeechComplete", sender: self)
    }

    func updateDisplay() {
    }

    func runningChanged(_ state: SpeechState, timer: SpeechTimer) {
        self.setRunningMode(state.running == SpeechRunning.running)
        if state.running == SpeechRunning.running {
            self.phaseChanged(state, timer: timer)
        }
        self.updateDisplay()
    }

    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?) {
        setNavSatusVisible(true, animated: false)
        self.setTabBarVisible(true, animated: true)
        
        if let scvc: SpeechCompleteViewController =
            segue.destination as? SpeechCompleteViewController {
            scvc.speechRecord = self.lastSpeechRecord
        }
    }

}
