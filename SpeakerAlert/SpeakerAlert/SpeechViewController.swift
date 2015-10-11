//
//  SpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/11/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Colours

class DemoSpeechState : SpeechState{
    
    override var running : SpeechRunning {
        get { return SpeechRunning.RUNNING }
        set {}
    }
    
    private var _phase : SpeechPhase
    override var phase : SpeechPhase {
        get { return _phase }
    }
    
    func nextPhase(){
        // Go to the next phase
        switch (self._phase){
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
    
    init(){
        _phase = SpeechPhase.BELOW_MINIMUM
        super.init(profile: SpeechProfile(green: 0, yellow: 0, red: 0, redBlink: 0));
    }
    
    override func toDictionary() -> [String : AnyObject] {
        return [:]
    }
}

class SpeechViewController: UIViewController, SpeechManagerDelegate {
    
    var speechMan : SpeechManager?
    var configMan : ConfigurationManager?
    
    @IBOutlet weak var profileSummaryLabel: UILabel!
    
    @IBOutlet weak var playButton: FontAwesomeButton!
    @IBOutlet weak var stopButton: FontAwesomeButton!
    @IBOutlet weak var pauseButton: FontAwesomeButton!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    var demoMode : Bool = false
    var demoState : DemoSpeechState?
    var blinkState : Bool = false
    var blinkOn : Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 10
    // Position in blink cycle
    var blinkCycleIndex = 0
    
    var tickTimer : NSTimer = NSTimer()
    
    var phaseColor : UIColor = UIColor.whiteColor()
    
    // MARK: Demo mode
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            if self.demoMode && self.demoState?.running == SpeechRunning.RUNNING {
                self.demoState?.nextPhase()
                self.updateDisplay()
            }
        }
    }
    
    // MARK: End demo mode
    
    var state : SpeechState? {
        get {
            if let sm = speechMan, let st = sm.state {
                return st
            }
            if self.demoMode {
                return demoState;
            }
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.demoMode {
            // TODO: Configure demo mode
            profileSummaryLabel?.text = "Demo Mode - Shake to advance"
            self.demoState = DemoSpeechState()
        }
        
        // Configure speech manager if not in demo mode
        if let sm = speechMan, let profile = sm.profile where !self.demoMode {
            sm.addSpeechObserver(self)
            profileSummaryLabel?.attributedText = ProfileTimeRenderer.timesAsAttributedString(profile)
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
        tickTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("doTick:"), userInfo: nil, repeats: true)
        self.updatePhase()
        self.updateDisplay()
    }
    
    override func viewDidAppear(animated: Bool) {
        guard let _ = self.state else {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
    }
    
    func doTick(timer : NSTimer) {
        self.updatePhase();
        self.updateDisplay()
    }
    
    override func viewWillDisappear(animated: Bool) {
        speechMan?.removeSpeechObserver(self)
        if tickTimer.valid {
            tickTimer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShowTime(isVisible : Bool){
        if let cm = configMan {
            cm.isDisplayTime = isVisible
            self.elapsedTimeLabel.hidden = !isVisible
        }
    }
    
    // Code from: http://stackoverflow.com/questions/27008737/how-do-i-hide-show-tabbar-when-tapped-using-swift-in-ios8/27072876#27072876
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    // Call the function from tap gesture recognizer added to your view (or button)
    
    @IBAction func tapped(sender: AnyObject) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    
    func setRunningMode(isRunning : Bool) {
        self.navigationController?.setNavigationBarHidden(isRunning, animated: true)
        self.setTabBarVisible(!isRunning, animated: true)
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
    
    func updatePhase(){
        if let phase = self.state?.phase {
            blinkState = false;
            if(phase == SpeechPhase.BELOW_MINIMUM){
                self.phaseColor = UIColor.whiteColor()
            }
            if(phase == SpeechPhase.GREEN){
                self.phaseColor = UIColor.successColor()
            }
            if(phase == SpeechPhase.YELLOW){
                self.phaseColor = UIColor.warningColor()
            }
            if(phase == SpeechPhase.RED){
                self.phaseColor = UIColor.dangerColor()
            }
            if(phase == SpeechPhase.OVER_MAXIMUM){
                self.phaseColor = UIColor.dangerColor()
                blinkState = true
            }
        }
    }
    
    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        self.updatePhase()
    }
    
    var lastSpeechElapsed : NSTimeInterval?
    func speechComplete(state: SpeechState, timer: SpeechTimer) {
        // Leave this speech
        lastSpeechElapsed = state.elapsed
        self.performSegueWithIdentifier("SpeechComplete", sender: self)
    }
    
    func updateTimeLabel(){
        
        if let state = speechMan?.state {
            
            let running : Bool = state.running == SpeechRunning.RUNNING
            let timeStr = TimeUtils.formatStopwatch(state.elapsed)
            var timeAttr: NSMutableAttributedString = NSMutableAttributedString(string: "\(timeStr)")
            if(!running){
                timeAttr = NSMutableAttributedString(string: "● \(timeStr)")
                if(state.phase == SpeechPhase.OVER_MAXIMUM) {
                    timeAttr = NSMutableAttributedString(string: "◎ \(timeStr)")
                }
                if(state.phase == SpeechPhase.BELOW_MINIMUM) {
                    timeAttr = NSMutableAttributedString(string: "◦ \(timeStr)")
                } else {
                    timeAttr.addAttribute(NSForegroundColorAttributeName, value: self.phaseColor, range: NSMakeRange(0, 1))
                }
            }
            
            elapsedTimeLabel.attributedText = timeAttr
            
        }
    }
    
    func updateControls(){
        if let state = self.state {
            switch state.running {
            case .PAUSED:
                self.playButton.enabled = true
                self.pauseButton.enabled = false
                self.stopButton.enabled = true
            case .RUNNING:
                self.playButton.enabled = false
                self.pauseButton.enabled = true
                self.stopButton.enabled = true
            case .STOPPED:
                self.playButton.enabled = true
                self.pauseButton.enabled = false
                self.stopButton.enabled = false
            }
        }
    }
    
    func updateDisplay() {
        let running : Bool = self.state?.running == SpeechRunning.RUNNING
        self.updateTimeLabel()
        self.updateControls()
        
        if(running){
            if(blinkState){
                if blinkCycleIndex >= blinkCycle {
                    blinkCycleIndex = 0;
                }
                if blinkCycleIndex == 0 {
                    if(blinkOn){
                        self.view.backgroundColor = phaseColor
                    } else {
                        self.view.backgroundColor = UIColor.whiteColor()
                    }
                    blinkOn = !blinkOn
                }
                blinkCycleIndex++
            } else {
                self.view.backgroundColor = phaseColor
            }
        } else {
            self.view.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    func runningChanged(state: SpeechState, timer: SpeechTimer){
        self.setRunningMode(state.running == SpeechRunning.RUNNING)
        if(state.running == SpeechRunning.RUNNING){
            self.phaseChanged(state, timer: timer)
        }
        self.updateDisplay()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let scvc : SpeechCompleteViewController = segue.destinationViewController as! SpeechCompleteViewController
        scvc.timeElapsed = lastSpeechElapsed
    }

}
