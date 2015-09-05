//
//  SpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/11/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController, SpeechTimerDelegate {
    
    var speechMan : SpeechManager?
    var configMan : ConfigurationManager?
    
    @IBOutlet weak var hideShowTimeButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    var blinkState : Bool = false
    var blinkOn : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechMan?.addSpeechObserver(self)
        
        if let cm = configMan {
            if cm.isAutoStartEnabled {
                self.resumePressed(self)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setShowTime(configMan!.isDisplayTime)
    }
    
    override func viewWillDisappear(animated: Bool) {
        speechMan?.removeSpeechObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShowTime(isVisible : Bool){
        if let cm = configMan {
            cm.isDisplayTime = isVisible
            if isVisible {
                self.hideShowTimeButton.setTitle("Hide Time", forState: UIControlState.Normal)
            } else {
                self.hideShowTimeButton.setTitle("Show Time", forState: UIControlState.Normal)
            }
            self.elapsedTimeLabel.hidden = !isVisible
        }
    }
    
    @IBAction func hideShowTime(sender: AnyObject) {
        if let cm = configMan {
            self.setShowTime(!cm.isDisplayTime)
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
    
    @IBAction func pausePressed(sender: AnyObject) {
        speechMan?.pause()
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        speechMan?.stop()
        // TODO: show the status bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setTabBarVisible(true, animated: true)
        self.hideShowTimeButton.hidden = false;
    }
    
    @IBAction func resumePressed(sender: AnyObject) {
        speechMan?.start()
        // TODO: hide the status bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTabBarVisible(false, animated: true)
        self.hideShowTimeButton.hidden = true;
    }
    
    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        blinkState = false;
        if(state.phase == SpeechPhase.BELOW_MINIMUM){
            self.view.backgroundColor = UIColor.whiteColor()
        }
        if(state.phase == SpeechPhase.GREEN){
            self.view.backgroundColor = UIColor.greenColor()
        }
        if(state.phase == SpeechPhase.YELLOW){
            self.view.backgroundColor = UIColor.yellowColor()
        }
        if(state.phase == SpeechPhase.RED){
            self.view.backgroundColor = UIColor.redColor()
        }
        if(state.phase == SpeechPhase.OVER_MAXIMUM){
            blinkState = true;
        }
    }
    
    func tick(state: SpeechState, timer: SpeechTimer){
        elapsedTimeLabel.text = TimeUtils.formatStopwatch(state.elapsed)
        
        if(blinkState){
            if(blinkOn){
                self.view.backgroundColor = UIColor.redColor()
            } else {
                self.view.backgroundColor = UIColor.whiteColor()
            }
            blinkOn = !blinkOn
        }
    }
    
    func runningChanged(state: SpeechState, timer: SpeechTimer){
        if(state.running == SpeechRunning.RUNNING){
            self.tick(state, timer: timer)
            self.phaseChanged(state, timer: timer)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
