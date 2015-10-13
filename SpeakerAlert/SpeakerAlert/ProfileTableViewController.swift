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
    var profile : Profile? {
        get { return _profile }
        set {
            _profile = newValue
            if let v = newValue {
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

        if let nameCell : ProfileNameTableViewCell = cell as? ProfileNameTableViewCell {
                
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
        
        if let timeCell : ProfileTimeTableViewCell = cell as? ProfileTimeTableViewCell {
        
                if indexPath.row == 1 {
                    timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.GREEN, nextPhase: SpeechPhase.YELLOW, previousPhase: nil)
                }
                
                if indexPath.row == 2 {
                    timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.YELLOW, nextPhase: SpeechPhase.RED, previousPhase: SpeechPhase.GREEN)
                }
                
                if indexPath.row == 3 {
                    timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.RED, nextPhase: SpeechPhase.OVER_MAXIMUM, previousPhase: SpeechPhase.YELLOW)
                }
                
                if indexPath.row == 4 {
                    timeCell.setProfileUpdateReceiver(self, phase: SpeechPhase.OVER_MAXIMUM, nextPhase: nil, previousPhase: SpeechPhase.RED)
                }
                
        }
        
        return cell
    }

    override func viewWillDisappear(animated: Bool) {
        // TODO: Save our timer settings
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
            // This block runs in background thread

            // TODO: Fix this for a new profile
            if let p = self.profile {
                let storedTiming : Profile = p.MR_inContext(localContext)
                storedTiming.green = self.phaseTimes[SpeechPhase.GREEN]
                storedTiming.yellow = self.phaseTimes[SpeechPhase.YELLOW]
                storedTiming.red = self.phaseTimes[SpeechPhase.RED]
                storedTiming.redBlink = self.phaseTimes[SpeechPhase.OVER_MAXIMUM]
                storedTiming.name = self.nameLabel?.text
            } else {
                // TODO: Create new profile
                MagicalRecord.saveWithBlockAndWait({ (localContext : NSManagedObjectContext!) -> Void in
                    // This block runs in background thread
                    
                    let newProfile : Profile = Profile.MR_createEntityInContext(localContext)
                     newProfile.name = "New Speech Profile"
                     newProfile.green = self.phaseTimes[SpeechPhase.GREEN]
                     newProfile.yellow = self.phaseTimes[SpeechPhase.YELLOW]
                     newProfile.red = self.phaseTimes[SpeechPhase.RED]
                     newProfile.redBlink = self.phaseTimes[SpeechPhase.OVER_MAXIMUM]
                     newProfile.name = self.nameLabel?.text
                    // TODO: Store the group appropriately
                    
//                    if let pg : Group = self.parentGroup {
//                        let cpg : Group = pg.MR_inContext(localContext)
//                        timing.parent = cpg
//                        
//                        NSLog("Speech profile parent name = \(timing.parent?.name)")
//                    } else {
//                        NSLog("No profile parent")
//                    }
//                    }) { (success: Bool, error: NSError!) -> Void in
//                        self.reloadData();
                })
            }
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
