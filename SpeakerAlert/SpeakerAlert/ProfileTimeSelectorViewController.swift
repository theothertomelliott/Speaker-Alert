//
//  ProfileTimeSelectorViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 12/31/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class ProfileTimeSelectorViewController: UIViewController,
    UIPickerViewDelegate,
    UIPickerViewDataSource {

    // TODO: Accept a phase identifier to modify

    var profile: Profile? {
        didSet {
        }
    }
    var phase: SpeechPhase = SpeechPhase.BELOW_MINIMUM
    var profileUpdateReceiver: ProfileTableViewController?
    
    @IBOutlet var picker: UIPickerView?
    @IBOutlet weak var colorNameLabel: UILabel!

    var colorName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        var time: NSNumber?

        switch self.phase {
        case .BELOW_MINIMUM: break
        case .OVER_MAXIMUM: time = self.profile?.redBlink
        case .GREEN: time = self.profile?.green
        case .YELLOW: time = self.profile?.yellow
        case .RED: time = self.profile?.red
        }

        if let t = time {
            picker?.selectRow(12*50 + Int(t.intValue/3600), inComponent: 0, animated: false)
            picker?.selectRow(60*50 + Int(t.intValue/60 % 60), inComponent: 1, animated: false)
            picker?.selectRow(60*50 + Int(t.intValue % 60), inComponent: 2, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save() {
        if let p = self.picker {
            self.profileUpdateReceiver?.phaseTimes[phase] =
                NSTimeInterval(
                    p.selectedRowInComponent(0)%60 * 3600 +
                    p.selectedRowInComponent(1)%60 * 60 +
                    p.selectedRowInComponent(2)%60
            )
        }
        self.profileUpdateReceiver?.phaseUpdated()
        self.dismiss()
    }

    @IBAction func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12*100
        } else {
            return 60*100
        }
    }

    func pickerView(
        pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row%12)"
        } else {
            return "\(row%60)"
        }
    }
}
