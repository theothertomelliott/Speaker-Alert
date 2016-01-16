//
//  SpeechCompleteViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/9/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class SpeechCompleteViewController: UIViewController {

    var timeElapsed: NSTimeInterval?

    @IBOutlet weak var timeElapsedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let te = self.timeElapsed {
            self.timeElapsedLabel.text = TimeUtils.formatStopwatch(te)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func okButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
