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

    let HOUR_INDEX = 0
    let HOUR_LABEL_INDEX = 1
    let MINUTE_INDEX = 2
    let MINUTE_LABEL_INDEX = 3
    let SECOND_INDEX = 4
    let SECOND_LABEL_INDEX = 5

    let TOTAL_COMPONENTS = 6

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
            picker?.selectRow(12*50 + Int(t.intValue/3600),
                inComponent: HOUR_INDEX,
                animated: false)
            picker?.selectRow(60*50 + Int(t.intValue/60 % 60),
                inComponent: MINUTE_INDEX,
                animated: false)
            picker?.selectRow(60*50 + Int(t.intValue % 60),
                inComponent: SECOND_INDEX,
                animated: false)
        }

        self.colorNameLabel.text = SpeechPhase.name[self.phase]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save() {
        if let p = self.picker {
            self.profileUpdateReceiver?.phaseTimes[phase] =
                NSTimeInterval(
                    p.selectedRowInComponent(HOUR_INDEX)%60 * 3600 +
                    p.selectedRowInComponent(MINUTE_INDEX)%60 * 60 +
                    p.selectedRowInComponent(SECOND_INDEX)%60
            )
        }
        self.profileUpdateReceiver?.phaseUpdated()
        self.dismiss()
    }

    @IBAction func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return TOTAL_COMPONENTS
    }

    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == HOUR_INDEX {
            return 12*100
        } else if component == MINUTE_INDEX || component == SECOND_INDEX {
            return 60*100
        } else {
            return 1
        }
    }

    func pickerView(
        pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int) -> NSAttributedString? {
            let paragraphStyle = NSMutableParagraphStyle()
            if component == HOUR_INDEX || component == MINUTE_INDEX || component == SECOND_INDEX {
                paragraphStyle.alignment = NSTextAlignment.Right
            } else {
                paragraphStyle.alignment = NSTextAlignment.Left
            }

            if let titleData = getPickerTitle(row, forComponent: component) {
                let myTitle = NSAttributedString(string: titleData,
                    attributes: [
                        NSParagraphStyleAttributeName: paragraphStyle
                    ])
                return myTitle
            }
            return nil
    }

    func getPickerTitle(row: Int, forComponent component: Int) -> String? {
        if component == HOUR_INDEX {
            return "\(row%12)"
        } else if component == MINUTE_INDEX || component == SECOND_INDEX {
            return "\(row%60)"
        } else {
            if component == HOUR_LABEL_INDEX {
                return "h"
            }
            if component == MINUTE_LABEL_INDEX {
                return "m"
            }
            if component == SECOND_LABEL_INDEX {
                return "s"
            }
            return nil
        }

    }

}
