//
//  SpeechViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/11/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController, SpeechTimerDelegate {
    
    var speechMan : SpeechManager?;
    
    @IBAction func pausePressed(sender: AnyObject) {
        speechMan?.pause()
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        speechMan?.stop()
    }
    
    @IBAction func resumePressed(sender: AnyObject) {
        speechMan?.start()
    }
    
    var blinkState : Bool = false
    var blinkOn : Bool = false
    
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
        blinkState = true;
    }
    
    func tick(elapsed : NSTimeInterval){
        elapsedTimeLabel.text = TimeUtils.formatStopwatch(elapsed)
        
        if(blinkState){
            if(blinkOn){
                self.view.backgroundColor = UIColor.redColor()
            } else {
                self.view.backgroundColor = UIColor.whiteColor()
            }
            blinkOn = !blinkOn
        }
    }

    
    @IBOutlet weak var elapsedTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
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
