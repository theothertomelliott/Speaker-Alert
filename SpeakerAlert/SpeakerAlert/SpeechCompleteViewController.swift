//
//  SpeechCompleteViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/9/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord

class SpeechCompleteViewController: UITableViewController {

    var speechRecord: Speech?
    @IBOutlet weak var timeElapsedLabel: UILabel?
    @IBOutlet weak var commentField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sr = self.speechRecord, let tel = self.timeElapsedLabel, let d = sr.duration {
            tel.text = TimeUtils.formatStopwatch(d)
        }
        if let p = self.speechRecord?.profile {
            commentField?.placeholder = p.name
        }
    }

    @IBAction func commentUpdated(sender: AnyObject) {
        if let tf = sender as? UITextField {
            NSLog("Updated comment to \(tf.text)")
            if let speech = self.speechRecord {
                MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                    let s: Speech = speech.MR_inContext(localContext)
                    s.comments = tf.text
                }) { (success: Bool, error: NSError!) -> Void in
                    // TODO: handle failure
                    if !success {
                        NSLog("Failure saving speech record with comment: \(error.description)")
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
