//
//  TimingViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/5/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord
import TWETimeIntervalField

class TimingViewController: UIViewController {

    var maximumTimeS : NSTimeInterval = 0
    
    private var _timing : Profile!
    var timing : Profile! {
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
    @IBOutlet weak var greenIntervalField: TWETimeIntervalField!
    @IBOutlet weak var yellowIntervalField: TWETimeIntervalField!
    @IBOutlet weak var redIntervalField: TWETimeIntervalField!
    @IBOutlet weak var alertIntervalField: TWETimeIntervalField!
    
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var yellowLabel: UILabel!
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var redBlinkLabel: UILabel!
    
    let MAX_TIMING_FACTOR = 1.1
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBAction func nameLabelChanged(sender: AnyObject) {
        self.timing.name = nameLabel.text
    }
    
    @IBAction func intervalFieldChanged(sender: AnyObject) {
        self.updateTimingFromIntervalFields()
        self.validateAndUpdate()
        self.updateLabels()
    }
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var yellowSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redBlinkSlider: UISlider!
    
    func updateTimingFromIntervalFields(){
        _timing.green = self.greenIntervalField.timeInterval
        _timing.yellow = self.yellowIntervalField.timeInterval
        _timing.red = self.redIntervalField.timeInterval
        _timing.redBlink = self.alertIntervalField.timeInterval
     }
    
    func updateTimingFromSliders(){
        _timing.green = NSTimeInterval(greenSlider.value);
        _timing.yellow = NSTimeInterval(yellowSlider.value);
        _timing.red = NSTimeInterval(redSlider.value);
        _timing.redBlink = NSTimeInterval(redBlinkSlider.value);
    }
    
    func updateLabels(){
        self.nameLabel.text = self.timing.name
        
        self.greenLabel.text = TimeUtils.formatTime(self.timing.green!)
        self.yellowLabel.text = TimeUtils.formatTime(self.timing.yellow!)
        self.redLabel.text = TimeUtils.formatTime(self.timing.red!)
        self.redBlinkLabel.text = TimeUtils.formatTime(self.timing.redBlink!)
        
        self.greenIntervalField.timeInterval = NSTimeInterval(self.timing.green!)
        self.yellowIntervalField.timeInterval = NSTimeInterval(self.timing.yellow!)
        self.redIntervalField.timeInterval = NSTimeInterval(self.timing.red!)
        self.alertIntervalField.timeInterval = NSTimeInterval(self.timing.redBlink!)
        
        greenSlider.maximumValue = Float(maximumTimeS)
        yellowSlider.maximumValue = Float(maximumTimeS)
        redSlider.maximumValue = Float(maximumTimeS)
        redBlinkSlider.maximumValue = Float(maximumTimeS)
        
        self.greenSlider.value = Float(self._timing.green!)
        self.yellowSlider.value = Float(self._timing.yellow!)
        self.redSlider.value = Float(self._timing.red!)
        self.redBlinkSlider.value = Float(self._timing.redBlink!)
        
    }
    
    func validateAndUpdate(){
        // Ensure appropriate ordering of slider values
        if(_timing.redBlink?.integerValue < _timing.red?.integerValue){
            _timing.red = _timing.redBlink
        }
        if(_timing.red?.integerValue < _timing.yellow?.integerValue){
            _timing.yellow = _timing.red
        }
        if(_timing.yellow?.integerValue < _timing.green?.integerValue){
            _timing.green = _timing.yellow
        }
        
        self.maximumTimeS = NSTimeInterval(Double(_timing.redBlink!)*MAX_TIMING_FACTOR)
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        updateTimingFromSliders()
        validateAndUpdate()
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateLabels()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // TODO: Save our timer settings
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
            // This block runs in background thread
            let storedTiming : Profile = self._timing.MR_inContext(localContext)
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

}
