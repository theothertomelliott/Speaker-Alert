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

    var speechMan: SpeechManager?
    var groups: [Group] = []
    var timings: [Profile] = []
    var parentGroup: Group? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: #selector(GroupTableViewController.addItem(_:)))
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem()]
    }

    override func viewWillAppear(animated: Bool) {
            self.setTabBarVisible(true, animated: animated)
    }

    override func viewDidAppear(animated: Bool) {
        self.reloadData()
    }

    func setParent(grp: Group) {
        parentGroup = grp
        groups = []
        timings = []
        self.title = grp.name
        self.reloadData()
    }

    func createGroupWithName(name: String) {

        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
            let group: Group = Group.MR_createEntityInContext(localContext)
            group.name = name
        }) { (success: Bool, error: NSError!) -> Void in
            self.reloadData()
        }

    }

    func createTiming() {
        self.performSegueWithIdentifier("newProfileSegue", sender: self)
    }

    func reloadData() {

        if let pg = parentGroup {
            // TODO: Reload the parent group
            if let t = pg.childTimings?.allObjects as? [Profile] {
                timings = t
            }
        } else {
            if let g = Group.MR_findAll() as? [Group] {
                groups = g
            }
            let predicate = NSPredicate(format: "parent = nil")
            if let t = Profile.MR_findAllWithPredicate(predicate) as? [Profile] {
                timings = t
            }
        }
        groups = groups.sort({ $0.name < $1.name })
        timings = timings.sort({ $0.name < $1.name })
        self.tableView.reloadData()
    }

    func createGroup() {
        let alertController = UIAlertController(
            title: "Create Group",
            message: "Please name your new group",
            preferredStyle: .Alert)
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

    func renameGroup(group: Group) {
        let alertController = UIAlertController(
            title: "Rename Group",
            message: "Please enter a new name for your group",
            preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Update", style: .Default) { (_) in
            let groupNameField = alertController.textFields![0] as UITextField
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                let localGroup: Group = group.MR_inContext(localContext)
                localGroup.name = groupNameField.text
                }) { (success: Bool, error: NSError!) -> Void in
                    self.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = group.name
        }
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }

    @objc
    func addItem(sender: AnyObject) {
        if parentGroup != nil {
            self.createTiming()
            return
        }
        let alertController = UIAlertController(
            title: "Add",
            message: "What would you like to create?",
            preferredStyle: .Alert)
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count + timings.count
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        if indexPath.row < groups.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                "GroupCell",
                forIndexPath: indexPath)
            let group = groups[indexPath.row]

            if let nameCell: NamedTableViewCell = cell as? NamedTableViewCell {
                nameCell.nameLabel!.text = group.name
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                "TimingCell",
                forIndexPath: indexPath)

            if let timing: Profile = timings[indexPath.row - groups.count],
                let tn: String = timing.name,
                let profileCell: ProfileTableViewCell = cell as? ProfileTableViewCell {
                profileCell.nameLabel!.text = tn
                profileCell.profileTimesLabel!.attributedText =
                    ProfileTimeRenderer.timesAsAttributedString(timing)
            }

            return cell
        }

    }


    // Override to support conditional editing of the table view.
    override func tableView(
        tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func deleteItemAtIndexPath(indexPath: NSIndexPath) {
        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) in
            // Delete the appropriate object
            if indexPath.row < self.groups.count {
                let group = self.groups[indexPath.row]
                group.MR_deleteEntityInContext(localContext)
            } else {
                let timing = self.timings[indexPath.row - self.groups.count]
                timing.MR_deleteEntityInContext(localContext)
            }

            }) { (success: Bool, error: NSError!) -> Void in
                self.reloadData()
        }
    }

    // Override to support editing the table view.
    override func tableView(
        tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            NSLog("Deleting row at \(indexPath.row)")
            self.deleteItemAtIndexPath(indexPath)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(
        tableView: UITableView,
        editActionsForRowAtIndexPath indexPath: NSIndexPath)
        -> [UITableViewRowAction]? {
        let moreRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.Default,
            title: "Edit",
            handler: {action, indexpath in

            if indexPath.row < Int(Group.MR_countOfEntities()) {
                self.renameGroup(self.groups[indexPath.row])
            } else {
                self.performSegueWithIdentifier(
                    "timingEditSegue",
                    sender: tableView.cellForRowAtIndexPath(indexPath))
            }
        })
        // TODO: Change this color
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)

        let deleteRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.Default,
            title: "Delete",
            handler: {action, indexpath in
            self.deleteItemAtIndexPath(indexPath)
        })

        return [deleteRowAction, moreRowAction]
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if "newProfileSegue" == segue.identifier {
            if let destination = segue.destinationViewController as? ProfileTableViewController {
                destination.profile = nil // Creates an empty profile
                destination.parentGroup = self.parentGroup
            }
            return
        }

        let indexPath: NSIndexPath = self.tableView.indexPathForCell((sender as? UITableViewCell)!)!

        if "groupSegue" == segue.identifier {
            let g: Group = self.groups[indexPath.row]

            if let destination: GroupTableViewController =
                segue.destinationViewController as? GroupTableViewController {
                destination.setParent(g)
            }
        }

        if "timingEditSegue" == segue.identifier, let destination: ProfileTableViewController =
            segue.destinationViewController as? ProfileTableViewController {
            destination.profile = self.timings[indexPath.row - self.groups.count]
        }

        if "timingSegue" == segue.identifier {
            speechMan?.profile = self.timings[indexPath.row - self.groups.count]
        }

    }

}
