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

    @objc
    func tick(timer: NSTimer!){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let s = self.speechState {
                self.timeElapsedLabel.setText(TimeUtils.formatStopwatch(s.elapsed))
                
                if(s.phase == SpeechPhase.BELOW_MINIMUM){
                    self.phaseColor = (UIColor.whiteColor())
                }
                if(s.phase == SpeechPhase.GREEN){
                    self.phaseColor = (UIColor(red: 83/255, green: 215/255, blue: 106/255, alpha: 1.0))
                }
                if(s.phase == SpeechPhase.YELLOW){
                    self.phaseColor = (UIColor(red: 221/255, green: 170/255, blue: 59/255, alpha: 1.0))
                }
                if(s.phase == SpeechPhase.RED){
                    self.phaseColor = (UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0))
                }
                if s.phase == SpeechPhase.OVER_MAXIMUM {
                    self.phaseColor = UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0)
                    self.blinkState = true
                }
                
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
            }
        })
    }
    
    /** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        NSLog("session:didReceiveApplicationContext:")
        
        speechState = SpeechState.fromDictionary(applicationContext)
        
        // Only allow pausing if the speech is currently running
        
        if(speechState!.running == SpeechRunning.RUNNING){
            self.startStopButton.setTitle("Stop")
            self.pauseButton.setTitle("Pause")
            self.pauseButton.setEnabled(true)
        } else if(speechState!.running == SpeechRunning.PAUSED) {
            self.startStopButton.setTitle("Stop")
            self.pauseButton.setTitle("Resume")
            self.pauseButton.setEnabled(true)
        } else {
            // Stopped
            self.startStopButton.setTitle("Start")
            self.pauseButton.setEnabled(false)
            self.pauseButton.setTitle("Pause")
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
