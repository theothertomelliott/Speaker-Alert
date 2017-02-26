//
//  GroupTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/4/15.
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


class GroupTableViewController: UITableViewController,
                                SpeechManagerDependency,
                                ConfigurationManagerDependency {

    var speechMan: SpeechManager
    var configMan: ConfigurationManager
    
    var groups: [Group] = []
    var timings: [Profile] = []
    var parentGroup: Group? = nil

    // Initializers for the app, using property injection
    required init?(coder aDecoder: NSCoder) {
        speechMan = GroupTableViewController._speechManager()
        configMan = GroupTableViewController._configurationManager()
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        speechMan = GroupTableViewController._speechManager()
        configMan = GroupTableViewController._configurationManager()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Initializer for testing, using initializer injection
    init(speechManager: SpeechManager, configurationManager: ConfigurationManager) {
        self.speechMan = speechManager
        self.configMan = configurationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(GroupTableViewController.addItem(_:)))
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem]
    }

    override func viewWillAppear(_ animated: Bool) {
            self.setTabBarVisible(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.reloadData()
        
        UIApplication.shared.registerUserNotificationSettings(
            UIUserNotificationSettings(
                types: [.alert, .badge, .sound],
                categories: (NSSet(array: ["MyCategory"])) as? Set<UIUserNotificationCategory>))
    }

    func rowIsGroup(_ row: Int) -> Bool {
        return row < groups.count
    }

    func rowIsProfile(_ row: Int) -> Bool {
        return !rowIsGroup(row) && row < groups.count + timings.count
    }

    func rowIsDemo(_ row: Int) -> Bool {
        return row == groups.count + timings.count
    }

    func setParent(_ grp: Group) {
        parentGroup = grp
        groups = []
        timings = []
        self.title = grp.name
        self.reloadData()
    }

    func createGroupWithName(_ name: String) {

        MagicalRecord.save({ (localContext: NSManagedObjectContext?) -> Void in
            let group: Group = Group.mr_createEntity(in: localContext)
            group.name = name
        }) { (success: Bool, error: Error?) -> Void in
            self.reloadData()
        }

    }

    func createTiming() {
        self.performSegue(withIdentifier: "newProfileSegue", sender: self)
    }

    func reloadData() {

        if let pg = parentGroup {
            // TODO: Reload the parent group
            if let t = pg.childTimings?.allObjects as? [Profile] {
                timings = t
            }
        } else {
            if let g = Group.mr_findAll() as? [Group] {
                groups = g
            }
            let predicate = NSPredicate(format: "parent = nil")
            if let t = Profile.mr_findAll(with: predicate) as? [Profile] {
                timings = t
            }
        }
        groups = groups.sorted(by: { $0.name < $1.name })
        timings = timings.sorted(by: { $0.name < $1.name })
        self.tableView.reloadData()
    }

    func createGroup() {
        let alertController = UIAlertController(
            title: "Create Group",
            message: "Please name your new group",
            preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            let groupNameField = alertController.textFields![0] as UITextField
            self.createGroupWithName(groupNameField.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        self.present(alertController, animated: true) {
            // ...
        }
    }

    func renameGroup(_ group: Group) {
        let alertController = UIAlertController(
            title: "Rename Group",
            message: "Please enter a new name for your group",
            preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let groupNameField = alertController.textFields![0] as UITextField
            MagicalRecord.save({ (localContext: NSManagedObjectContext?) -> Void in
                let localGroup: Group = group.mr_(in: localContext)
                localGroup.name = groupNameField.text
                }) { (success: Bool, error: Error?) -> Void in
                    self.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.placeholder = group.name
        }
        self.present(alertController, animated: true) {
            // ...
        }
    }

    @objc
    func addItem(_ sender: AnyObject) {
        if parentGroup != nil {
            self.createTiming()
            return
        }
        let alertController = UIAlertController(
            title: "Add",
            message: "What would you like to create?",
            preferredStyle: .alert)
        let oneAction = UIAlertAction(title: "New Group", style: .default) { (_) in
            self.createGroup()
        }
        let twoAction = UIAlertAction(title: "New Speech Profile", style: .default) { (_) in
            self.createTiming()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
            // ...
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let demoCount = (parentGroup == nil) ? 1 : 0
        return groups.count + timings.count + demoCount
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        if rowIsGroup(indexPath.row) {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "GroupCell",
                for: indexPath)
            let group = groups[indexPath.row]

            if let nameCell: NamedTableViewCell = cell as? NamedTableViewCell {
                nameCell.nameLabel!.text = group.name
            }

            return cell
        } else if rowIsProfile(indexPath.row) {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TimingCell",
                for: indexPath)
            
            let timing: Profile = timings[indexPath.row - groups.count]
            if let tn: String = timing.name,
                let profileCell: ProfileTableViewCell = cell as? ProfileTableViewCell {
                profileCell.nameLabel!.text = tn
                profileCell.profileTimesLabel!.attributedText =
                    ProfileTimeRenderer.timesAsAttributedString(timing)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DemoCell",
                for: indexPath)
            return cell
        }

    }
    
    // Handle selection for segue to speeches and demo mode
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        if self.isEditing {
            doEdit(indexPath)
            return
        }
        
        if rowIsProfile(indexPath.row) || rowIsDemo(indexPath.row) {
            self.performSegue(
                withIdentifier: "speechDefault",
                sender: tableView.cellForRow(at: indexPath))
        }
    }


    // Override to support conditional editing of the table view.
    override func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func deleteItemAtIndexPath(_ indexPath: IndexPath) {
        if !rowIsDemo(indexPath.row) {
            MagicalRecord.save({ (localContext: NSManagedObjectContext?) in
                // Delete the appropriate object
                if self.rowIsGroup(indexPath.row) {
                    let group = self.groups[indexPath.row]
                    group.mr_deleteEntity(in: localContext)
                } else if self.rowIsProfile(indexPath.row) {
                    let timing = self.timings[indexPath.row - self.groups.count]
                    timing.mr_deleteEntity(in: localContext)
                }

                }) { (success: Bool, error: Error?) -> Void in
                self.reloadData()
            }
        }
    }

    // Override to support editing the table view.
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            NSLog("Deleting row at \(indexPath.row)")
            self.deleteItemAtIndexPath(indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view
        }
    }
    
    func doEdit(_ indexPath: IndexPath) {
        if self.rowIsGroup(indexPath.row) {
            self.renameGroup(self.groups[indexPath.row])
        } else if self.rowIsProfile(indexPath.row) {
            self.performSegue(
                withIdentifier: "timingEditSegue",
                sender: tableView.cellForRow(at: indexPath))
        }
    }

    override func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {

            if rowIsDemo(indexPath.row) {
                // Do nothing for the demo row

                let uneditableAction = UITableViewRowAction(
                    style: UITableViewRowActionStyle.default,
                    title: "Built-in",
                    handler: {action, indexpath in

                })
                uneditableAction.backgroundColor = UIColor(red: 0.5,
                                                           green: 0.5,
                                                           blue: 0.5,
                                                           alpha: 1.0)

                return [uneditableAction]
            }

        let moreRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.default,
            title: "Edit",
            handler: {action, indexpath in
                self.doEdit(indexPath)
        })

        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)

        let deleteRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.default,
            title: "Delete",
            handler: {action, indexpath in
            self.deleteItemAtIndexPath(indexPath)
        })

        return [deleteRowAction, moreRowAction]
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if "groupSegue" == identifier {
            if self.isEditing {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if "newProfileSegue" == segue.identifier {
            if let destination = segue.destination as? ProfileTableViewController {
                destination.profile = nil // Creates an empty profile
                destination.parentGroup = self.parentGroup
            }
            return
        }

        let indexPath: IndexPath = self.tableView.indexPath(for: (sender as? UITableViewCell)!)!

        if "groupSegue" == segue.identifier {
            let g: Group = self.groups[indexPath.row]

            if let destination: GroupTableViewController =
                segue.destination as? GroupTableViewController {
                destination.setParent(g)
            }
        }

        if "timingEditSegue" == segue.identifier, let destination: ProfileTableViewController =
            segue.destination as? ProfileTableViewController {
            destination.profile = self.timings[indexPath.row - self.groups.count]
        }

        if let i = segue.identifier, i.hasPrefix("speech") {
            if rowIsProfile(indexPath.row) {
                speechMan.profile = self.timings[indexPath.row - self.groups.count]
            } else if rowIsDemo(indexPath.row) {
                speechMan.profile = nil
                if let destination = segue.destination as? SpeechViewController {
                    destination.demoMode = true
                }
            }
        }

    }

}
