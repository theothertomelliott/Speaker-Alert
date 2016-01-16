//
//  ProfileTimeSelectorViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 12/31/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class ProfileTimeSelectorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // TODO: Accept a phase identifier to modify

    var profile: Profile? {
        didSet {
        }
    }
    var phase: SpeechPhase?

    @IBOutlet var picker: UIPickerView?
    @IBOutlet weak var colorNameLabel: UILabel!

    var colorName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        colorNameLabel.text = colorName
        picker?.selectRow(12*50, inComponent: 0, animated: false)
        picker?.selectRow(60*50, inComponent: 1, animated: false)
        picker?.selectRow(60*50, inComponent: 2, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save() {
        // TODO: Update the profile
    }

    @IBAction func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return 12*100
        } else {
            return 60*100
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return "\(row%12)"
        } else {
            return "\(row%60)"
        }
    }
}
