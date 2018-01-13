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

    let TOTAL_REPETITIONS = 4

	var profile: Profile? {
		didSet {
		}
	}
	var phase: SpeechPhase = SpeechPhase.below_MINIMUM
	var profileUpdateReceiver: ProfileTableViewController?

	@IBOutlet var picker: UIPickerView?
	@IBOutlet weak var colorNameLabel: UILabel!

	var colorName: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(_ animated: Bool) {
		var time: NSNumber?

		switch self.phase {
		case .below_MINIMUM: break
		case .over_MAXIMUM: time = self.profile?.redBlink
		case .green: time = self.profile?.green
		case .yellow: time = self.profile?.yellow
		case .red: time = self.profile?.red
		}

		var workingTime: NSNumber = 0
		if let t = time {
			workingTime = t
		}
		picker?.selectRow(12 * TOTAL_REPETITIONS/2 + Int(workingTime.int32Value / 3600),
			inComponent: HOUR_INDEX,
			animated: false)
		picker?.selectRow(60 * TOTAL_REPETITIONS/2 + Int(workingTime.int32Value / 60 % 60),
			inComponent: MINUTE_INDEX,
			animated: false)
		picker?.selectRow(60 * TOTAL_REPETITIONS/2 + Int(workingTime.int32Value % 60),
			inComponent: SECOND_INDEX,
			animated: false)

		self.colorNameLabel.attributedText = ProfileTimeRenderer.phaseAsAttributedString(self.phase)
		if let name = SpeechPhase.name[self.phase] {
			self.colorNameLabel.isAccessibilityElement = true
			self.colorNameLabel.accessibilityLabel = name
			self.colorNameLabel.accessibilityIdentifier = "Speech Phase"
		}

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTabBarVisible(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func save() {
		if let p = self.picker {
			self.profileUpdateReceiver?.phaseTimes[phase] =
				TimeInterval(
					p.selectedRow(inComponent: HOUR_INDEX) % 12 * 3600 +
						p.selectedRow(inComponent: MINUTE_INDEX) % 60 * 60 +
						p.selectedRow(inComponent: SECOND_INDEX) % 60
			)
		}
		self.profileUpdateReceiver?.phaseUpdated()
		self.dismiss()
	}

	@IBAction func dismiss() {
		self.navigationController?.popViewController(animated: true)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return TOTAL_COMPONENTS
	}

	// returns the # of rows in each component..
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == HOUR_INDEX {
			return 12 * TOTAL_REPETITIONS
		} else if component == MINUTE_INDEX || component == SECOND_INDEX {
			return 60 * TOTAL_REPETITIONS
		} else {
			return 1
		}
	}

	func pickerView(
		_ pickerView: UIPickerView,
		attributedTitleForRow row: Int,
		forComponent component: Int) -> NSAttributedString? {
			let paragraphStyle = NSMutableParagraphStyle()
			if component == HOUR_INDEX || component == MINUTE_INDEX || component == SECOND_INDEX {
				paragraphStyle.alignment = NSTextAlignment.right
			} else {
				paragraphStyle.alignment = NSTextAlignment.left
			}

			if let titleData = getPickerTitle(row, forComponent: component) {
				let myTitle = NSAttributedString(string: titleData,
					attributes: [
						NSAttributedStringKey.paragraphStyle: paragraphStyle
				])
				return myTitle
			}
			return nil
	}

	func getPickerTitle(_ row: Int, forComponent component: Int) -> String? {
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
