//
//  ViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var timer : SpeechTimer?;
    
    class TD : NSObject, SpeechTimerDelegate {
        
        func green(timer : SpeechTimer) { NSLog("Delegate Green"); }
        func yellow(timer : SpeechTimer) { NSLog("Delegate Yellow"); }
        func red(timer : SpeechTimer) { NSLog("Delegate Red"); }
        func redBlink(timer : SpeechTimer) { NSLog("Delegate Red Blink"); }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Timing",
            inManagedObjectContext:
            managedContext)!
        
        let timings = Timing(entity: entity, insertIntoManagedObjectContext: managedContext)
        timings.name = "Test"
        timings.green = 1
        timings.yellow = 20
        timings.red = 30
        timings.redBlink = 35
        
        timer = SpeechTimer(withTimings: timings);
        
        timer?.delegate = TD();
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

