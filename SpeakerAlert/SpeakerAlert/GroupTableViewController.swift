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
    
    var groups : [AnyObject] = []
    var timings : [AnyObject] = []
    var parentGroup : Group? = nil
    
    func setParent(g : Group){
        parentGroup = g
        groups = []
        timings = []
        self.title = g.name
        self.reloadData()
    }
    
    func createGroupWithName(name : String){

        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
            let group : Group = Group.MR_createEntityInContext(localContext)
            group.name = name
        }) { (success: Bool, error: NSError!) -> Void in
            self.reloadData();
        }
        
    }
    
    func createTiming(){
        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) -> Void in
            // This block runs in background thread
            
            let timing : Profile = Profile.MR_createEntityInContext(localContext)
            timing.name = "New Speech Profile"
            
            if let pg : Group = self.parentGroup {
                let cpg : Group = pg.MR_inContext(localContext)
                timing.parent = cpg
                
                NSLog("Speech profile parent name = \(timing.parent?.name)")
            } else {
                NSLog("No profile parent")
            }
        }) { (success: Bool, error: NSError!) -> Void in
                self.reloadData();
        }
    }
    
    func reloadData(){
        
        if let pg = parentGroup {
            // TODO: Reload the parent group
            
            timings = (pg.childTimings?.allObjects)!
            
        } else {
            
            groups = Group.MR_findAll()

            let predicate = NSPredicate(format: "parent = nil")
            timings = Profile.MR_findAllWithPredicate(predicate)
        }
        
        self.tableView.reloadData()
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
    
    @IBAction func addGroup(sender: AnyObject) {
        
        if(parentGroup != nil){
            self.createTiming()
            return
        }
        
        let alertController = UIAlertController(title: "Add", message: "What would you like to create?", preferredStyle: .Alert)
        
        let oneAction = UIAlertAction(title: "New Group", style: .Default) { (_) in
            self.createGroup()
        }
        let twoAction = UIAlertAction(title: "New Speech Profile", style: .Default) { (_) in
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func viewDidAppear(animated: Bool) {
        self.reloadData()
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
        return groups.count + timings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        // Configure the cell...
        if(indexPath.row < groups.count){
            let cell : NamedTableViewCell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! NamedTableViewCell
            let group = groups[indexPath.row]

            cell.nameLabel!.text = group.name
        
            return cell
        } else {
            let cell : NamedTableViewCell = tableView.dequeueReusableCellWithIdentifier("TimingCell", forIndexPath: indexPath) as! NamedTableViewCell
            
            let timing = timings[indexPath.row - groups.count]
            
                let tn : String = timing.name!
                cell.nameLabel!.text = tn
            /*
            if(timing.parentGroup != nil){
                if let pg : Group = timing.parentGroup {
                    let pn : String = pg.name!
                    cell.textLabel!.text = "\(tn) - \(pn)"
                } else {
                    cell.textLabel!.text = tn
                }
            }
            */
            return cell
        }

    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            NSLog("Deleting row at \(indexPath.row)")
            
            MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
                // This block runs in background thread
                
                // Configure the cell...
                if(indexPath.row < Int(Group.MR_countOfEntitiesWithContext(localContext))){
                    let groups : NSArray = Group.MR_findAllInContext(localContext)
                    let group = groups.objectAtIndex(indexPath.row)
                    group.MR_deleteEntity()
                } else {
                    let timings : NSArray = Profile.MR_findAllInContext(localContext)
                    let timing = timings.objectAtIndex(indexPath.row - Int(Group.MR_countOfEntities()))
                    timing.MR_deleteEntity()
                }
                
            }) { (success: Bool, error: NSError!) -> Void in
                    self.reloadData();
            }

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath : NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
        
        if("groupSegue" == segue.identifier){
            let g : Group = self.groups[indexPath.row] as! Group
        
            let destination : GroupTableViewController = segue.destinationViewController as! GroupTableViewController
            destination.setParent(g)
        }
        
        if("timingSegue" == segue.identifier){
            // TODO: Populate the destination with this timing object
            let destination : TimingViewController = segue.destinationViewController as! TimingViewController
            destination.timing = self.timings[indexPath.row - self.groups.count] as! Profile
        }
        
    }
    
}
