//
//  HistoryTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/26/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit
import MagicalRecord

class HistoryTableViewController: UITableViewController {

    var history: [String:[Speech]] = [:]
    var dates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.editButtonItem()]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadData()
    }
    
    func reloadData() {
        history = [:]
        dates = []
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        if let h = Speech.MR_findAllSortedBy("startTime", ascending: true) as? [Speech] {
            for speech: Speech in h {
                if let s = speech.startTime {
                    let dateStr = formatter.stringFromDate(s)
                    if let _ = history[dateStr] {
                        history[dateStr]?.append(speech)
                    } else {
                        history[dateStr] = [speech]
                        dates.append(dateStr)
                    }
                }
            }
        }
        dates = dates.reverse()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    
    override func tableView(
        tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        return dates[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history[dates[section]]!.count
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let speech = history[dates[indexPath.section]]![indexPath.row]
        
        let reusedCell = tableView.dequeueReusableCellWithIdentifier(
                "LogItem",
                forIndexPath: indexPath)
        
        if let cell = reusedCell as? HistoryItemCell {
            return configureCell(speech, cell: cell)
        }
        
        return reusedCell
       
    }
    
    func formatDateForCell(start: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .MediumStyle
        return formatter.stringFromDate(start)
    }
    
    func configureCell(speech: Speech, cell: HistoryItemCell) -> HistoryItemCell {
        cell.elapsed?.text = ""
        cell.date?.text = "Start time unknown"
        cell.name?.text = "<Title>"
        if let start = speech.startTime {
            cell.date?.text = formatDateForCell(start)
        }
        if let duration = speech.duration {
            cell.elapsed?.text = TimeUtils.formatStopwatch(duration)
        }
        if let name = speech.profile?.name {
            cell.name?.text = name
        }
        if let comment = speech.comments {
            cell.name?.text = comment
        }
        if let profile = speech.profile {
            cell.profileInfo?.attributedText =
                ProfileTimeRenderer.timesAsAttributedString(profile)
        }
        
        setPhaseIndicator(speech, cell: cell)
        
        return cell
    }
    
    func setPhaseIndicator(speech: Speech, cell: HistoryItemCell) {
        if let d = speech.duration, let p = speech.profile {
            // Set the background for the cell as appropriate
            if  let c = p.green
                where d.intValue >= c.intValue {
                cell.phaseIndicator?.textColor = UIColor.successColor()
                cell.phaseIndicator?.text = "●"
            }
            if  let c = p.yellow
                where d.intValue >= c.intValue {
                cell.phaseIndicator?.textColor = UIColor.warningColor()
                cell.phaseIndicator?.text = "●"
            }
            if  let c = p.red
                where d.intValue >= c.intValue {
                cell.phaseIndicator?.textColor = UIColor.dangerColor()
                cell.phaseIndicator?.text = "●"
            }
            if  let c = p.redBlink
                where d.intValue >= c.intValue {
                cell.phaseIndicator?.textColor = UIColor.dangerColor()
                cell.phaseIndicator?.text = "▾"
            }
        }
    }
    
    
    func changeComment(speech: Speech) {
        let alertController = UIAlertController(
            title: "Change Description",
            message: "Please enter a new description for this speech",
            preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Update", style: .Default) { (_) in
            let commentField = alertController.textFields![0] as UITextField
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                let localSpeech: Speech = speech.MR_inContext(localContext)
                localSpeech.comments = commentField.text
            }) { (success: Bool, error: NSError!) -> Void in
                self.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = speech.profile?.name
            textField.text = speech.comments
        }
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    // Handle selection for segue to speeches and demo mode
    override func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.editing {
            let speech = self.history[self.dates[indexPath.section]]![indexPath.row]
            changeComment(speech)
            return
        }
    }
    
    // Override to support editing the table view.
    override func tableView(
        tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                           forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItemAtIndexPath(indexPath)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteItemAtIndexPath(indexPath: NSIndexPath) {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) in
                // Delete the appropriate object
                let speech = self.history[self.dates[indexPath.section]]![indexPath.row]
                speech.MR_deleteEntityInContext(localContext)
            }) { (success: Bool, error: NSError!) -> Void in
                self.reloadData()
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
                    let speech = self.history[self.dates[indexPath.section]]![indexPath.row]
                    self.changeComment(speech)
            })
            
            moreRowAction.backgroundColor = UIColor(
                red: 0.298,
                green: 0.851,
                blue: 0.3922,
                alpha: 1.0)
            
            let deleteRowAction = UITableViewRowAction(
                style: UITableViewRowActionStyle.Default,
                title: "Delete",
                handler: {action, indexpath in
                    self.deleteItemAtIndexPath(indexPath)
            })
            
            return [deleteRowAction, moreRowAction]
    }
    
}

class HistoryItemCell: UITableViewCell {
    
    @IBOutlet var name: UILabel?
    @IBOutlet var date: UILabel?
    @IBOutlet var elapsed: UILabel?
    @IBOutlet var phaseIndicator: UILabel?
    @IBOutlet var profileInfo: UILabel?
    
}
