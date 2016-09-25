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


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var watchSession: WCSession?
    var tickTimer: NSTimer = NSTimer()
    var speechState: SpeechState?
    var vibration: NSNumber = 0

    @IBOutlet var speechNameLabel: WKInterfaceLabel!

    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var timeElapsedLabel: WKInterfaceLabel!
    @IBOutlet var startStopButton: WKInterfaceButton!

    var phaseColor: UIColor = UIColor.whiteColor()

    var blinkState: Bool = false
    var blinkOn: Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 1/0.2
    // Position in blink cycle
    var blinkCycleIndex = 0

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Configure interface objects here.
        // Set up initial state
        self.startStopButton.setTitle("Start")
        self.startStopButton.setEnabled(false)
        self.startStopButton.setBackgroundColor(UIColor.lightGrayColor())

        if WCSession.isSupported() {
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

        if self.tickTimer.valid {
            self.tickTimer.invalidate()
        }
        self.tickTimer = NSTimer.scheduledTimerWithTimeInterval(
            0.2,
            target: self,
            selector: #selector(InterfaceController.tick(_:)),
            userInfo: nil,
            repeats: true)
        self.tickTimer.tolerance = 0.1

        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        NSLog("didDeactivate")

        if self.tickTimer.valid {
            self.tickTimer.invalidate()
        }

        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updatePause(state: SpeechState) {
        // Only allow pausing if the speech is currently running

        if state.running == SpeechRunning.RUNNING || state.running == SpeechRunning.PAUSED {
            self.startStopButton.setTitle("Stop")
            self.startStopButton.setBackgroundColor(
                UIColor(
                    red: 229/255,
                    green: 0/255,
                    blue: 15/255,
                    alpha: 1.0))
            self.startStopButton.setEnabled(true)
        } else {
            // Stopped
            self.startStopButton.setTitle("Start")
            self.startStopButton.setBackgroundColor(
                UIColor(
                    red: 83/255,
                    green: 215/255,
                    blue: 106/255,
                    alpha: 1.0))
            self.startStopButton.setEnabled(true)
        }
    }

    func setPhaseColor(state: SpeechState) {
        var newPhaseColor = self.phaseColor
        if state.phase == SpeechPhase.BELOW_MINIMUM {
            newPhaseColor = (UIColor.whiteColor())
        }
        if state.phase == SpeechPhase.GREEN {
            newPhaseColor = (UIColor(red: 83/255, green: 215/255, blue: 106/255, alpha: 1.0))
        }
        if state.phase == SpeechPhase.YELLOW {
            newPhaseColor = (UIColor(red: 221/255, green: 170/255, blue: 59/255, alpha: 1.0))
        }
        if state.phase == SpeechPhase.RED {
            newPhaseColor = (UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0))
        }
        if state.phase == SpeechPhase.OVER_MAXIMUM {
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
    }

    func updateUI() {
        if let s = self.speechState {
            self.timeElapsedLabel.setText(TimeUtils.formatStopwatch(s.elapsed))

            self.updatePause(s)

            self.setPhaseColor(s)

            if self.blinkState {
                if Double(self.blinkCycleIndex) >= self.blinkCycle {
                    self.blinkCycleIndex = 0
                }
                if self.blinkCycleIndex == 0 {
                    if self.blinkOn {
                        self.mainGroup.setBackgroundColor(self.phaseColor)
                    } else {
                        self.mainGroup.setBackgroundColor(UIColor.whiteColor())
                    }
                    self.blinkOn = !self.blinkOn
                }
                self.blinkCycleIndex += 1
            } else {
                self.mainGroup.setBackgroundColor(self.phaseColor)
            }
        } else {
            self.startStopButton.setEnabled(false)
            self.startStopButton.setBackgroundColor(UIColor.lightGrayColor())
            self.speechNameLabel.setText("< No Speech >")
            self.timeElapsedLabel.setText("-- : --")
            self.phaseColor = UIColor.whiteColor()
            self.mainGroup.setBackgroundColor(self.phaseColor)
        }
    }

    @objc
    func tick(timer: NSTimer!) {
        self.updateUI()
    }

    func session(
        session: WCSession,
        didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let n = applicationContext["speechName"] as? String {
            self.speechNameLabel.setText(n)
        }
        if let v = applicationContext["vibration"] as? NSNumber {
            self.vibration = v
        }
        if let state = applicationContext["state"] as? [String : AnyObject] {
            self.speechState = SpeechState.fromDictionary(state)
        }
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        replyHandler([:])
        NSLog("Message = \(message)")

        if let messageName: String = message["messageName"] as? String,
            let stateDict = message["state"] as? [String : AnyObject],
            let speechState = SpeechState.fromDictionary(stateDict)
            where messageName == "speechComplete" {
                self.pushControllerWithName("SpeechComplete", context: speechState)
        }


    }

    @IBAction func stopStartPressed() {
        watchSession?.sendMessage(
            ["messageName" : "startStop"],
            replyHandler: { (reply: [String : AnyObject]) -> Void in
            NSLog("Reply received")
            }, errorHandler: { (error: NSError) -> Void in
            NSLog("Error received: \(error.description)")
        })
    }
    
    @available(watchOSApplicationExtension 2.2, *)
    func session(
        session: WCSession,
        activationDidCompleteWithState activationState: WCSessionActivationState,
                                       error: NSError?
        ) {}
    
    
}
