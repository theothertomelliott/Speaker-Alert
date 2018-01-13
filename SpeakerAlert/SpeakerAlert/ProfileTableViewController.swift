//
//  ProfileTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/12/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ProfileTableViewController: UITableViewController {

	var parentGroup: Group?
	var profile: Profile? {
		didSet {
			if let v = self.profile {
				// Populate internal values
				self.name = v.name
				self.phaseTimes[SpeechPhase.green] = TimeInterval(v.green!)
				self.phaseTimes[SpeechPhase.yellow] = TimeInterval(v.yellow!)
				self.phaseTimes[SpeechPhase.red] = TimeInterval(v.red!)
				self.phaseTimes[SpeechPhase.over_MAXIMUM] = TimeInterval(v.redBlink!)
			} else {
				self.name = ""
				self.phaseTimes[SpeechPhase.green] = 0
				self.phaseTimes[SpeechPhase.yellow] = 0
				self.phaseTimes[SpeechPhase.red] = 0
				self.phaseTimes[SpeechPhase.over_MAXIMUM] = 0
			}
		}
	}

	fileprivate var nameLabel: UITextField?

	override func viewDidLoad() {
		super.viewDidLoad()
	}

    override func viewWillAppear(_ animated: Bool) {
        self.setTabBarVisible(false, animated: animated)
        if let _ = self.profile {
            self.title = "Edit Profile"
        } else {
            self.title = "New Profile"
        }
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if let destination: ProfileTimeSelectorViewController =
			segue.destination as? ProfileTimeSelectorViewController {

				if let timeCell: ProfileTimeTableViewCell = sender as? ProfileTimeTableViewCell {
					destination.colorName = timeCell.colorNameLabel.text

					if let phase = timeCell.phase {
						destination.phase = phase
					}
					destination.profileUpdateReceiver = self
					destination.profile = self.profile
				}
		}
	}

	// MARK: ProfileUpdateReceiver

	var name: String?
	var phaseTimes: [SpeechPhase: TimeInterval] = [:]

	func phaseUpdated() {
		self.tableView.reloadData()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			var identifier = indexPath.row == 0 ? "NameCell" : "TimeCell"
			if indexPath.row == 5 {
				identifier = "OkCancelCell"
			}

			let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

			if let nameCell: ProfileNameTableViewCell = cell as? ProfileNameTableViewCell {
				// Configure the cell...
				if indexPath.row == 0 {
					self.nameLabel = nameCell.profileName
					nameCell.profileName.text = self.name
				}
			}

			if let timeCell: ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
				if indexPath.row == 1 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.green)
				}
				if indexPath.row == 2 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.yellow)
				}
				if indexPath.row == 3 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.red)
				}
				if indexPath.row == 4 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.over_MAXIMUM)
				}
			}

			return cell
	}

	@IBAction func nameLabelFinishedEditing(_ sender: UITextView) {
		self.name = sender.text
	}
    
    func phasesInOrder() -> Bool {
        if self.phaseTimes[SpeechPhase.green] > self.phaseTimes[SpeechPhase.yellow] {
            return false
        }
        if self.phaseTimes[SpeechPhase.yellow] > self.phaseTimes[SpeechPhase.red] {
            return false
        }
        if self.phaseTimes[SpeechPhase.red] > self.phaseTimes[SpeechPhase.over_MAXIMUM] {
            return false
        }
        return true
    }
    
    func saveError(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        )
        
        self.present(alertController, animated: true, completion: nil)

    }

	@IBAction func save() {
		if self.name == "" {
			saveError("Name required", message:
					"Please enter a name for your Speech Profile")
			return
		}
        if !phasesInOrder() {
            saveError("Out of order",
                message: "For best effect, alert timings must be in ascending order, or equal.")
            return
        }

        
        DispatchQueue.main.async {
            let name = self.nameLabel?.text
            MagicalRecord.save({ (localContext: NSManagedObjectContext?) in
                // This block runs in background thread
                if let p = self.profile {
                    let storedTiming: Profile = p.mr_(in: localContext)
                    storedTiming.green = self.phaseTimes[SpeechPhase.green]! as NSNumber
                    storedTiming.yellow = self.phaseTimes[SpeechPhase.yellow]! as NSNumber
                    storedTiming.red = self.phaseTimes[SpeechPhase.red]! as NSNumber
                    storedTiming.redBlink = self.phaseTimes[SpeechPhase.over_MAXIMUM]! as NSNumber
                    storedTiming.name = name
                } else {
                    let newProfile: Profile = Profile.mr_createEntity(in: localContext)
                    newProfile.name = "New Speech Profile"
                    newProfile.green = self.phaseTimes[SpeechPhase.green]! as NSNumber
                    newProfile.yellow = self.phaseTimes[SpeechPhase.yellow]! as NSNumber
                    newProfile.red = self.phaseTimes[SpeechPhase.red]! as NSNumber
                    newProfile.redBlink = self.phaseTimes[SpeechPhase.over_MAXIMUM]! as NSNumber
                    newProfile.name = name
                    if let pg: Group = self.parentGroup {
                        newProfile.parent = pg.mr_(in: localContext)
                    }
                }
            })
        }
		self.dismiss()
	}

	@IBAction func dismiss() {
		self.navigationController?.popViewController(animated: true)
	}
}
