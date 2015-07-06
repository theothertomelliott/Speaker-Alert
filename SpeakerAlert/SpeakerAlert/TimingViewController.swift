//
//  TimingViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class TimingViewController: UIViewController {

    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var yellowLabel: UILabel!
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var redBlinkLabel: UILabel!
    
    private var _timing : Timing!
    var timing : Timing! {
        get {
            return _timing
        }
        
        set(newTiming) {
            self._timing = newTiming
            // Apply to view
            self.title = newTiming.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.greenLabel.text = "\(self.timing.green!)s"
        self.yellowLabel.text = "\(self.timing.yellow!)s"
        self.redLabel.text = "\(self.timing.red!)s"
        self.redBlinkLabel.text = "\(self.timing.redBlink!)s"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
