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
                self.name = "New Profile"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: Pass the color info to the time picker

        if let destination: ProfileTimeSelectorViewController =
            segue.destinationViewController as?ProfileTimeSelectorViewController {
            destination.profile = self.profile

            if let timeCell: ProfileTimeTableViewCell = sender as? ProfileTimeTableViewCell {
                NSLog("\(timeCell.colorNameLabel.text)")
                destination.colorName = timeCell.colorNameLabel.text
            }

            // TODO: Pick up current color

        }
    }

    // MARK: ProfileUpdateReceiver

    var name: String?
    var phaseTimes: [SpeechPhase : NSTimeInterval ] = [ : ]

    func phaseUpdated() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? "NameCell" : "TimeCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        if let nameCell: ProfileNameTableViewCell = cell as? ProfileNameTableViewCell {

                // Configure the cell...
                if indexPath.row == 0 {
                    self.nameLabel = nameCell.profileName
                    if let profile = self.profile {
                        nameCell.profileName.text = profile.name
                    } else {
                        nameCell.profileName.text = "New Profile"
                    }
                }

        }

        if let timeCell: ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {

                if indexPath.row == 1 {
                    timeCell.setProfileUpdateReceiver(
                        self,
                        phase: SpeechPhase.GREEN,
                        nextPhase: SpeechPhase.YELLOW,
                        previousPhase: nil)
                }

                if indexPath.row == 2 {
                    timeCell.setProfileUpdateReceiver(
                        self,
                        phase: SpeechPhase.YELLOW,
                        nextPhase: SpeechPhase.RED,
                        previousPhase: SpeechPhase.GREEN)
                }

                if indexPath.row == 3 {
                    timeCell.setProfileUpdateReceiver(
                        self, phase:
                        SpeechPhase.RED,
                        nextPhase: SpeechPhase.OVER_MAXIMUM,
                        previousPhase: SpeechPhase.YELLOW)
                }

                if indexPath.row == 4 {
                    timeCell.setProfileUpdateReceiver(self,
                        phase: SpeechPhase.OVER_MAXIMUM,
                        nextPhase: nil,
                        previousPhase: SpeechPhase.RED)
                }

        }

        return cell
    }

    override func viewWillDisappear(animated: Bool) {
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
                MagicalRecord.saveWithBlockAndWait({(localContext: NSManagedObjectContext!) ->
                    Void in
                    // This block runs in background thread

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
                })
            }
        })


    }

}
