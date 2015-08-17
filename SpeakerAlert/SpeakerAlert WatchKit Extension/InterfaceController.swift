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

    @IBOutlet var mainGroup: WKInterfaceGroup!
    
    @IBOutlet var timeElapsedLabel: WKInterfaceLabel!
    /** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        NSLog("session:didReceiveApplicationContext:")
        let speechState : SpeechState = SpeechState.fromDictionary(applicationContext)
        timeElapsedLabel.setText(TimeUtils.formatStopwatch(speechState.elapsed))
        
        if(speechState.phase == SpeechPhase.GREEN){
            mainGroup.setBackgroundColor(UIColor.greenColor())
        }
        if(speechState.phase == SpeechPhase.YELLOW){
            mainGroup.setBackgroundColor(UIColor.yellowColor())
        }
        if(speechState.phase == SpeechPhase.RED){
            mainGroup.setBackgroundColor(UIColor.redColor())
        }
    }
    
    var watchSession : WCSession?
    
    @IBAction func stopStartPressed() {
        watchSession?.sendMessage(["messageName" : "startStop"], replyHandler: { (reply : [String : AnyObject]) -> Void in
            NSLog("Reply received")
            }, errorHandler: { (error : NSError) -> Void in
            NSLog("Error received")
        })
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
