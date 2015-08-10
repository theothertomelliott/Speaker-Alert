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
    
    func phaseChanged(state: SpeechState, timer: SpeechTimer) {
        if(state.phase == SpeechPhase.GREEN){
            self.view.backgroundColor = UIColor.greenColor()
        }
        if(state.phase == SpeechPhase.YELLOW){
            self.view.backgroundColor = UIColor.yellowColor()
        }
        if(state.phase == SpeechPhase.RED){
            self.view.backgroundColor = UIColor.redColor()
        }
        if(state.phase == SpeechPhase.OVER_MAXIMUM){
            blinkState = true;
        }
    }
    
    func tick(state: SpeechState, timer: SpeechTimer){
        elapsedTimeLabel.text = TimeUtils.formatStopwatch(state.elapsed)
        
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
        speechMan?.addSpeechObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        speechMan?.removeSpeechObserver(self)
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
