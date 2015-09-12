//
//  InterfaceController.swift
//  SpeakerAlert WatchKit Extension
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    var watchSession : WCSession?
    var tickTimer : NSTimer = NSTimer()
    var speechState : SpeechState?
    var vibration : NSNumber = 0
    
    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var timeElapsedLabel: WKInterfaceLabel!
    @IBOutlet var startStopButton: WKInterfaceButton!
    @IBOutlet var pauseButton: WKInterfaceButton!
    
    var phaseColor : UIColor = UIColor.whiteColor()
    
    var blinkState : Bool = false
    var blinkOn : Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 10
    // Position in blink cycle
    var blinkCycleIndex = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Configure interface objects here.
        // Set up initial state
        self.startStopButton.setTitle("Start")
        self.pauseButton.setEnabled(false)
        self.pauseButton.setTitle("Pause")
        
        if(WCSession.isSupported()){
            NSLog("WCSession supported, initializing")
            watchSession = WCSession.defaultSession()
            NSLog("Activating WCSession and adding delegate")
            watchSession!.delegate = self
            watchSession!.activateSession()
        } else {
            NSLog("WCSession is not supported, will not initialize")
        }
    }
    
    override func willActivate() {
        NSLog("willActivate")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.tickTimer.valid {
                self.tickTimer.invalidate()
            }
            self.tickTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
        })
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        NSLog("didDeactivate")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.tickTimer.valid {
                self.tickTimer.invalidate()
            }
        })
        
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updateUI(){
        if let s = self.speechState {
            self.timeElapsedLabel.setText(TimeUtils.formatStopwatch(s.elapsed))
            
            // Only allow pausing if the speech is currently running
            
            if(s.running == SpeechRunning.RUNNING){
                self.startStopButton.setTitle("Stop")
                self.pauseButton.setTitle("Pause")
                self.pauseButton.setEnabled(true)
                self.startStopButton.setEnabled(true)
            } else if(s.running == SpeechRunning.PAUSED) {
                self.startStopButton.setTitle("Stop")
                self.pauseButton.setTitle("Resume")
                self.pauseButton.setEnabled(true)
                self.startStopButton.setEnabled(true)
            } else {
                // Stopped
                self.startStopButton.setTitle("Start")
                self.pauseButton.setEnabled(false)
                self.pauseButton.setTitle("Pause")
                self.startStopButton.setEnabled(true)
            }
            
            var newPhaseColor = self.phaseColor
            if(s.phase == SpeechPhase.BELOW_MINIMUM){
                newPhaseColor = (UIColor.whiteColor())
            }
            if(s.phase == SpeechPhase.GREEN){
                newPhaseColor = (UIColor(red: 83/255, green: 215/255, blue: 106/255, alpha: 1.0))
            }
            if(s.phase == SpeechPhase.YELLOW){
                newPhaseColor = (UIColor(red: 221/255, green: 170/255, blue: 59/255, alpha: 1.0))
            }
            if(s.phase == SpeechPhase.RED){
                newPhaseColor = (UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0))
            }
            if s.phase == SpeechPhase.OVER_MAXIMUM {
                newPhaseColor = UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0)
                self.blinkState = true
            }
            
            if newPhaseColor != self.phaseColor {
                if self.vibration != 0 {
                    NSLog("Vibrate!")
                    WKInterfaceDevice().playHaptic(.Notification)
                }
            }
            self.phaseColor = newPhaseColor
            
            if(self.blinkState){
                if self.blinkCycleIndex >= self.blinkCycle {
                    self.blinkCycleIndex = 0
                    if(self.blinkOn){
                        self.mainGroup.setBackgroundColor(self.phaseColor)
                    } else {
                        self.mainGroup.setBackgroundColor(UIColor.whiteColor())
                    }
                    self.blinkOn = !self.blinkOn
                }
                self.blinkCycleIndex++
            } else {
                self.mainGroup.setBackgroundColor(self.phaseColor)
            }
        } else {
            self.startStopButton.setEnabled(false)
            self.pauseButton.setEnabled(false)
            self.timeElapsedLabel.setText("-- : --")
            self.phaseColor = UIColor.whiteColor()
            self.mainGroup.setBackgroundColor(self.phaseColor)
        }
    }
    
    @objc
    func tick(timer: NSTimer!){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.updateUI()
        })
    }
    
    /** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        if let v = applicationContext["vibration"] as? NSNumber {
            self.vibration = v
        }
        if let state = applicationContext["state"] as? [String : AnyObject] {
            self.speechState = SpeechState.fromDictionary(state)
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]){
        
        NSLog("Message = \(message)")
        
        if let messageName : String = message["messageName"] as? String {
            if messageName == "speechComplete" {
                if let stateDict = message["state"] as? [String : AnyObject] {
                    if let speechState = SpeechState.fromDictionary(stateDict) {
                        self.pushControllerWithName("SpeechComplete", context: speechState)
                    }
                }
            }
        }

        
    }
    
    @IBAction func stopStartPressed() {
        watchSession?.sendMessage(["messageName" : "startStop"], replyHandler: { (reply : [String : AnyObject]) -> Void in
            NSLog("Reply received")
            }, errorHandler: { (error : NSError) -> Void in
            NSLog("Error received")
        })
    }
    
    @IBAction func pausePressed() {
        watchSession?.sendMessage(["messageName" : "pauseResume"], replyHandler: { (reply : [String : AnyObject]) -> Void in
            NSLog("Reply received")
            }, errorHandler: { (error : NSError) -> Void in
                NSLog("Error received")
        })
    }
    
}
