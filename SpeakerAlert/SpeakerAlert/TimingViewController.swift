//
//  TimingViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord

class TimingViewController: UIViewController {

    var maximumTimeS : NSTimeInterval = 0
    
    private var _timing : Timing!
    var timing : Timing! {
        get {
            return _timing
        }
        
        set(newTiming) {
            self._timing = newTiming
            // Apply to view
            self.title = newTiming.name
            
            self.maximumTimeS = NSTimeInterval(Double(_timing.redBlink!)*MAX_TIMING_FACTOR)
        }
    }
    
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var yellowLabel: UILabel!
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var redBlinkLabel: UILabel!
    
    @IBOutlet weak var maxTimeTextField: UITextField!
    
    let MAX_TIMING_FACTOR = 1.1
    
    @IBAction func maxTimeAltered(sender: AnyObject) {
        
        NSLog("Max time is now: %@", maxTimeTextField.text!)
        
        if let num : NSNumber = Int(maxTimeTextField.text!) {
            maximumTimeS = NSTimeInterval(num)
            if(num != Double(_timing.redBlink!)*MAX_TIMING_FACTOR){
                // Set new values
                _timing.redBlink = maximumTimeS
                // Fixed values for now
                _timing.red = maximumTimeS - 30
                _timing.yellow = maximumTimeS - 60
                _timing.green = maximumTimeS - 90
            }
            updateLabels()
        }
        
        
    }
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBAction func nameLabelChanged(sender: AnyObject) {
        self.timing.name = nameLabel.text
    }
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var yellowSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redBlinkSlider: UISlider!
    
    func updateTimingFromSliders(){

        // Ensure appropriate ordering of slider values
        if(redBlinkSlider.value < redSlider.value){
            redSlider.value = redBlinkSlider.value
        }
        if(redSlider.value < yellowSlider.value){
            yellowSlider.value = redSlider.value
        }
        if(yellowSlider.value < greenSlider.value){
            greenSlider.value = yellowSlider.value
        }
        
        _timing.green = NSTimeInterval(greenSlider.value);
        _timing.yellow = NSTimeInterval(yellowSlider.value);
        _timing.red = NSTimeInterval(redSlider.value);
        _timing.redBlink = NSTimeInterval(redBlinkSlider.value);
    }
    
    func formatTime(interval: NSNumber) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Abbreviated
        
        let components = NSDateComponents()
        components.minute = Int(interval)/60
        components.second = Int(interval)%60

        return formatter.stringFromDateComponents(components)!
    }
    
    func updateLabels(){
        self.nameLabel.text = self.timing.name
        
        self.greenLabel.text = self.formatTime(self.timing.green!)
        self.yellowLabel.text = self.formatTime(self.timing.yellow!)
        self.redLabel.text = self.formatTime(self.timing.red!)
        self.redBlinkLabel.text = self.formatTime(self.timing.redBlink!)
        
        greenSlider.maximumValue = Float(maximumTimeS)
        yellowSlider.maximumValue = Float(maximumTimeS)
        redSlider.maximumValue = Float(maximumTimeS)
        redBlinkSlider.maximumValue = Float(maximumTimeS)
        
        self.greenSlider.value = Float(self._timing.green!)
        self.yellowSlider.value = Float(self._timing.yellow!)
        self.redSlider.value = Float(self._timing.red!)
        self.redBlinkSlider.value = Float(self._timing.redBlink!)
        
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        updateTimingFromSliders()
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateLabels()
        self.maxTimeTextField.text = "\(self.maximumTimeS)"
    }
    
    override func viewWillDisappear(animated: Bool) {
        // TODO: Save our timer settings
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
            // This block runs in background thread
            let storedTiming : Timing = self._timing.MR_inContext(localContext)
            storedTiming.green = self._timing.green
            storedTiming.yellow = self._timing.yellow
            storedTiming.red = self._timing.red
            storedTiming.redBlink = self._timing.redBlink
            storedTiming.name = self._timing.name
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass along our timimg to start the timer
        if("startSegue" == segue.identifier){
            let svc : SpeechViewController = segue.destinationViewController as! SpeechViewController
            svc.timing = _timing
        }
    }
    

}
