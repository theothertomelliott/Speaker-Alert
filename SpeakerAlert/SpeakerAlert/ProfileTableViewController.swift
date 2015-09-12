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

    private var _profile : Profile?
    var profile : Profile {
        get {
            if let p = _profile {
                return p
            } else {
                return Profile()
            }
        }
        set {
            _profile = newValue
            
            // Populate internal values
            self.name = newValue.name
            self.phaseTimes[SpeechPhase.GREEN] = NSTimeInterval(newValue.green!)
            self.phaseTimes[SpeechPhase.YELLOW] = NSTimeInterval(newValue.yellow!)
            self.phaseTimes[SpeechPhase.RED] = NSTimeInterval(newValue.red!)
            self.phaseTimes[SpeechPhase.OVER_MAXIMUM] = NSTimeInterval(newValue.redBlink!)
        }
    }
    
    private var nameLabel : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ProfileUpdateReceiver
    
    var name : String?
    var phaseTimes : [SpeechPhase : NSTimeInterval ] = [ : ]
    
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


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? "NameCell" : "TimeCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        // Configure the cell...
        if indexPath.row == 0 {
            if let nameCell : ProfileNameTableViewCell = cell as? ProfileNameTableViewCell {
                self.nameLabel = nameCell.profileName
                nameCell.profileName.text = self.profile.name
            }
        }
        
        if indexPath.row == 1 {
            if let timeCell : ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
                timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.GREEN, nextPhase: SpeechPhase.YELLOW, previousPhase: nil)
            }
        }
        
        if indexPath.row == 2 {
            if let timeCell : ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
                timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.YELLOW, nextPhase: SpeechPhase.RED, previousPhase: SpeechPhase.GREEN)
            }
        }
        
        if indexPath.row == 3 {
            if let timeCell : ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.RED, nextPhase: SpeechPhase.OVER_MAXIMUM, previousPhase: SpeechPhase.YELLOW)
            }
        }
        
        if indexPath.row == 4 {
            if let timeCell : ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.OVER_MAXIMUM, nextPhase: nil, previousPhase: SpeechPhase.RED)
            }
        }
        
        
        return cell
    }

    override func viewWillDisappear(animated: Bool) {
        // TODO: Save our timer settings
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
            // This block runs in background thread
            let storedTiming : Profile = self.profile.MR_inContext(localContext)
            storedTiming.green = self.phaseTimes[SpeechPhase.GREEN]
            storedTiming.yellow = self.phaseTimes[SpeechPhase.YELLOW]
            storedTiming.red = self.phaseTimes[SpeechPhase.RED]
            storedTiming.redBlink = self.phaseTimes[SpeechPhase.OVER_MAXIMUM]
            storedTiming.name = self.nameLabel?.text
        })
        
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
