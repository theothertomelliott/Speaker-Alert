//
//  ViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer : SpeechTimer?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let timings : Timing = Timing(withName: "Test", greenInterval: 1, yellowInterval: 20, redInterval: 30, redBlinkInterval: 35);
        timer = SpeechTimer(withTimings: timings);
        
    }
    
    @IBAction func start(sender : UIButton){
        timer?.start();
    }
    
    @IBAction func pause(sender : UIButton){
        timer?.pause();
    }
    
    @IBAction func stop(sender : UIButton){
        timer?.stop();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

