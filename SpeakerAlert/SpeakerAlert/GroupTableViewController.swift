//
//  GroupTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/4/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

import MagicalRecord

class GroupTableViewController: UITableViewController {

    func createGroupWithName(name : String){
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
            // This block runs in background thread
            
            let group : Group = Group.MR_createEntityInContext(localContext)
            group.name = name
            
            }, completion: { (success : Bool, error : NSError!) in
                // This block runs in main thread
                self.tableView.reloadData()
        })
    }
    
    func createGroup(){
        let alertController = UIAlertController(title: "Create Group", message: "Please name your new group", preferredStyle: .Alert)
        
        let createAction = UIAlertAction(title: "Create", style: .Default) { (_) in
            let groupNameField = alertController.textFields![0] as UITextField
            self.createGroupWithName(groupNameField.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    func createTiming(){
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
            // This block runs in background thread
            
            let timing : Timing = Timing.MR_createEntityInContext(localContext)
            timing.name = "New Timing"
            
            }, completion: { (success : Bool, error : NSError!) in
                // This block runs in main thread
                self.tableView.reloadData()
        })
    }
    
    @IBAction func addGroup(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add", message: "What would you like to create?", preferredStyle: .Alert)
        
        let oneAction = UIAlertAction(title: "New Group", style: .Default) { (_) in
            self.createGroup()
        }
        let twoAction = UIAlertAction(title: "New Timing", style: .Default) { (_) in
            self.createTiming()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("GroupTableView didLoad")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count : UInt = Group.MR_countOfEntities() + Timing.MR_countOfEntities()
        return Int(count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        if(indexPath.row < Int(Group.MR_countOfEntities())){
            let groups : NSArray = Group.MR_findAll()
            let group = groups.objectAtIndex(indexPath.row)
            cell.textLabel!.text = group.name
        } else {
            let timings : NSArray = Timing.MR_findAll()
            let timing = timings.objectAtIndex(indexPath.row - Int(Group.MR_countOfEntities()))
            cell.textLabel!.text = timing.name
        }
        
        return cell
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
        // Return NO if you do not want the item to be re-orderable.
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
