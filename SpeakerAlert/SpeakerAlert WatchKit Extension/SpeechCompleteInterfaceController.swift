//
//  SpeechCompleteInterfaceController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/9/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import WatchKit
import Foundation


class SpeechCompleteInterfaceController: WKInterfaceController {

    @IBOutlet var elapsedTimeLabel: WKInterfaceLabel!

    @IBAction func okPressed() {
        self.pop()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if let speechState: SpeechState = context as? SpeechState {
            elapsedTimeLabel.setText(TimeUtils.formatStopwatch(NSNumber(floatLiteral: speechState.elapsed)))
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
