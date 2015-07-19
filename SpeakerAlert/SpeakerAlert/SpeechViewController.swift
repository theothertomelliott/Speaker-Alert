//
//  SpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/11/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController, SpeechTimerDelegate {
    
    var timing : Timing!
    var timer : SpeechTimer!
    
    func green(timer : SpeechTimer) {
        self.view.backgroundColor = UIColor.greenColor()
    }
    func yellow(timer : SpeechTimer) {
        self.view.backgroundColor = UIColor.yellowColor()
    }
    func red(timer : SpeechTimer) {
        self.view.backgroundColor = UIColor.redColor()
    }
    func redBlink(timer : SpeechTimer) {
        // Set up blinking here
    }
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let t : Timing = timing {
            timer = SpeechTimer(withTimings: t)
            timer.delegate = self
            timer.start()
        }
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
