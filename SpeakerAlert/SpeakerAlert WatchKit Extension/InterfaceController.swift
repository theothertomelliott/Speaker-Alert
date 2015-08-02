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

    @IBOutlet var timeElapsedLabel: WKInterfaceLabel!
    /** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        NSLog("session:didReceiveApplicationContext:")
        let elapsedTime : NSTimeInterval = applicationContext["elapsed"] as! NSTimeInterval
        timeElapsedLabel.setText(TimeUtils.formatStopwatch(elapsedTime))
    }
    
    var watchSession : WCSession?
    
    @IBAction func stopStartPressed() {
        let cancel = WKAlertAction(title: "Cancel", style: WKAlertActionStyle.Cancel, handler: { () -> Void in
            
        })
        
        let action = WKAlertAction(title: "Action", style: WKAlertActionStyle.Default, handler: { () -> Void in
            
        })
        
        self.presentAlertControllerWithTitle("Alert", message: "Example watchOS 2 alert interface", preferredStyle: WKAlertControllerStyle.SideBySideButtonsAlert, actions: [cancel, action])
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
