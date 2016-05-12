//
//  ProfileTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/12/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord

class ProfileTableViewController: UITableViewController {

	var parentGroup: Group?
	var profile: Profile? {
		didSet {
			if let v = self.profile {
				// Populate internal values
				self.name = v.name
				self.phaseTimes[SpeechPhase.GREEN] = NSTimeInterval(v.green!)
				self.phaseTimes[SpeechPhase.YELLOW] = NSTimeInterval(v.yellow!)
				self.phaseTimes[SpeechPhase.RED] = NSTimeInterval(v.red!)
				self.phaseTimes[SpeechPhase.OVER_MAXIMUM] = NSTimeInterval(v.redBlink!)
			} else {
				self.name = ""
				self.phaseTimes[SpeechPhase.GREEN] = 0
				self.phaseTimes[SpeechPhase.YELLOW] = 0
				self.phaseTimes[SpeechPhase.RED] = 0
				self.phaseTimes[SpeechPhase.OVER_MAXIMUM] = 0
			}
		}
	}

	private var nameLabel: UITextField?

	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    override func viewWillAppear(animated: Bool) {
        self.setTabBarVisible(false, animated: animated)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if let destination: ProfileTimeSelectorViewController =
			segue.destinationViewController as? ProfileTimeSelectorViewController {

				if let timeCell: ProfileTimeTableViewCell = sender as? ProfileTimeTableViewCell {
					NSLog("\(timeCell.colorNameLabel.text)")
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
	var phaseTimes: [SpeechPhase: NSTimeInterval] = [:]

	func phaseUpdated() {
		self.tableView.reloadData()
	}

	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			var identifier = indexPath.row == 0 ? "NameCell" : "TimeCell"
			if indexPath.row == 5 {
				identifier = "OkCancelCell"
			}

			let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

			if let nameCell: ProfileNameTableViewCell = cell as? ProfileNameTableViewCell {
				// Configure the cell...
				if indexPath.row == 0 {
					self.nameLabel = nameCell.profileName
					nameCell.profileName.text = self.name
				}
			}

			if let timeCell: ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
				if indexPath.row == 1 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.GREEN)
				}
				if indexPath.row == 2 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.YELLOW)
				}
				if indexPath.row == 3 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.RED)
				}
				if indexPath.row == 4 {
					timeCell.setControllerAndPhase(self, phase: SpeechPhase.OVER_MAXIMUM)
				}
			}

			return cell
	}

	@IBAction func nameLabelFinishedEditing(sender: UITextView) {
		self.name = sender.text
	}

	@IBAction func save() {
		if self.name == "" {
			let alertController = UIAlertController(title: "Name required", message:
					"Please enter a name for your Speech Profile", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(
                UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            )

			self.presentViewController(alertController, animated: true, completion: nil)
			return
		}

		MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) in
			// This block runs in background thread
			if let p = self.profile {
				let storedTiming: Profile = p.MR_inContext(localContext)
				storedTiming.green = self.phaseTimes[SpeechPhase.GREEN]
				storedTiming.yellow = self.phaseTimes[SpeechPhase.YELLOW]
				storedTiming.red = self.phaseTimes[SpeechPhase.RED]
				storedTiming.redBlink = self.phaseTimes[SpeechPhase.OVER_MAXIMUM]
				storedTiming.name = self.nameLabel?.text
			} else {
                let newProfile: Profile = Profile.MR_createEntityInContext(localContext)
				newProfile.name = "New Speech Profile"
				newProfile.green = self.phaseTimes[SpeechPhase.GREEN]
				newProfile.yellow = self.phaseTimes[SpeechPhase.YELLOW]
				newProfile.red = self.phaseTimes[SpeechPhase.RED]
				newProfile.redBlink = self.phaseTimes[SpeechPhase.OVER_MAXIMUM]
				newProfile.name = self.nameLabel?.text
				if let pg: Group = self.parentGroup {
					newProfile.parent = pg.MR_inContext(localContext)
				}
			}
		})
		self.dismiss()
	}

	@IBAction func dismiss() {
		self.navigationController?.popViewControllerAnimated(true)
	}
}
