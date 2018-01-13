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
    var tickTimer: Timer = Timer()
    var speechState: SpeechState?
    var vibration: NSNumber = 0
    
    var phaseColor: UIColor = UIColor.white
    
    var blinkState: Bool = false
    var blinkOn: Bool = false
    // Number of ticks before changing colour in blink
    let blinkCycle = 1/0.2
    // Position in blink cycle
    var blinkCycleIndex = 0
    
    var stopping: Bool = false

    @IBOutlet var speechNameLabel: WKInterfaceLabel!

    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var timeElapsedLabel: WKInterfaceLabel!
    @IBOutlet var startStopButton: WKInterfaceButton!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        // Set up initial state
        self.startStopButton.setTitle("Start")
        self.startStopButton.setEnabled(false)
        self.startStopButton.setBackgroundColor(UIColor.lightGray)
    }

    override func willActivate() {

        if WCSession.isSupported() {
            NSLog("WCSession supported, initializing")
            watchSession = WCSession.default
            NSLog("Activating WCSession and adding delegate")
            watchSession!.delegate = self
            watchSession!.activate()
        } else {
            NSLog("WCSession is not supported, will not initialize")
        }
        
        if self.tickTimer.isValid {
            self.tickTimer.invalidate()
        }
        self.tickTimer = Timer.scheduledTimer(
            timeInterval: 0.2,
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

        if self.tickTimer.isValid {
            self.tickTimer.invalidate()
        }
        
        watchSession = nil

        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updatePause(_ state: SpeechState) {
        // Only allow pausing if the speech is currently running

        if state.running == SpeechRunning.running {
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

    func setPhaseColor(_ state: SpeechState) {
        var newPhaseColor = self.phaseColor
        if state.phase == SpeechPhase.below_MINIMUM {
            newPhaseColor = (UIColor.white)
        }
        if state.phase == SpeechPhase.green {
            newPhaseColor = (UIColor(red: 83/255, green: 215/255, blue: 106/255, alpha: 1.0))
        }
        if state.phase == SpeechPhase.yellow {
            newPhaseColor = (UIColor(red: 221/255, green: 170/255, blue: 59/255, alpha: 1.0))
        }
        if state.phase == SpeechPhase.red {
            newPhaseColor = (UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0))
        }
        if state.phase == SpeechPhase.over_MAXIMUM {
            newPhaseColor = UIColor(red: 229/255, green: 0/255, blue: 15/255, alpha: 1.0)
            self.blinkState = true
        }

        if newPhaseColor != self.phaseColor {
            if self.vibration != 0 {
                NSLog("Vibrate!")
                WKInterfaceDevice().play(.notification)
            }
        }
        self.phaseColor = newPhaseColor
    }

    func updateUI() {
        if let s = self.speechState {
            self.timeElapsedLabel.setText(TimeUtils.formatStopwatch(Int(s.elapsed)))

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
                        self.mainGroup.setBackgroundColor(UIColor.white)
                    }
                    self.blinkOn = !self.blinkOn
                }
                self.blinkCycleIndex += 1
            } else {
                self.mainGroup.setBackgroundColor(self.phaseColor)
            }
        } else {
            self.startStopButton.setEnabled(false)
            self.startStopButton.setBackgroundColor(UIColor.lightGray)
            self.speechNameLabel.setText("< No Speech >")
            self.timeElapsedLabel.setText("-- : --")
            self.phaseColor = UIColor.white
            self.mainGroup.setBackgroundColor(self.phaseColor)
        }
        
        if stopping {
            self.startStopButton.setEnabled(false)
        }
    }

    @objc
    func tick(_ timer: Timer!) {
        self.updateUI()
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]) {
        if let n = applicationContext["speechName"] as? String {
            self.speechNameLabel.setText(n)
        }
        if let v = applicationContext["vibration"] as? NSNumber {
            self.vibration = v
        }
        if let state = applicationContext["state"] as? [String : AnyObject] {
            self.speechState = SpeechState.fromDictionary(state)
        }
        if applicationContext.count == 0 {
            self.speechState = nil
        }
        self.stopping = false
        self.updateUI()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler([:])
        NSLog("Message = \(message)")

        if let messageName: String = message["messageName"] as? String,
            let stateDict = message["state"] as? [String : AnyObject],
            let speechState = SpeechState.fromDictionary(stateDict), messageName == "speechComplete" {
                self.pushController(withName: "SpeechComplete", context: speechState)
        }


    }

    @IBAction func stopStartPressed() {
        stopping = true
        
        watchSession?.sendMessage(
            ["messageName" : "startStop"],
            replyHandler: { (reply: [String : Any]) -> Void in
                NSLog("Reply received")
        }, errorHandler: { (error: Error) -> Void in
            NSLog("Error received: \(error.localizedDescription)")
        })
    }
    
    @available(watchOSApplicationExtension 2.2, *)
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
                                       error: Error?
        ) {}
    
    
}
