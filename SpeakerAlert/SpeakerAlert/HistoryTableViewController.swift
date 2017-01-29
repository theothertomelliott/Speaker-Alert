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
        self.navigationItem.rightBarButtonItems = [self.editButtonItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    func reloadData() {
        history = [:]
        dates = []
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        if let h = Speech.mr_findAllSorted(by: "startTime", ascending: true) as? [Speech] {
            for speech: Speech in h {
                if let s = speech.startTime {
                    let dateStr = formatter.string(from: s)
                    if let _ = history[dateStr] {
                        history[dateStr]?.append(speech)
                    } else {
                        history[dateStr] = [speech]
                        dates.append(dateStr)
                    }
                }
            }
        }
        dates = dates.reversed()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        return dates[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history[dates[section]]!.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let speech = history[dates[indexPath.section]]![indexPath.row]
        
        let reusedCell = tableView.dequeueReusableCell(
                withIdentifier: "LogItem",
                for: indexPath)
        
        if let cell = reusedCell as? HistoryItemCell {
            return configureCell(speech, cell: cell)
        }
        
        return reusedCell
       
    }
    
    func formatDateForCell(_ start: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: start)
    }
    
    func configureCell(_ speech: Speech, cell: HistoryItemCell) -> HistoryItemCell {
        cell.elapsed?.text = ""
        cell.date?.text = "Start time unknown"
        cell.name?.text = "<Title>"
        if let start = speech.startTime {
            cell.date?.text = formatDateForCell(start)
        }
        if let duration = speech.duration {
            cell.elapsed?.text = TimeUtils.formatStopwatch(Int(duration))
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
    
    func setPhaseIndicator(_ speech: Speech, cell: HistoryItemCell) {
        if let d = speech.duration, let p = speech.profile {
            // Set the background for the cell as appropriate
            cell.phaseIndicator?.textColor = UIColor.black
            cell.phaseIndicator?.text = "●"
            if  let c = p.green, d.int32Value >= c.int32Value {
                cell.phaseIndicator?.textColor = UIColor.success()
            }
            if  let c = p.yellow, d.int32Value >= c.int32Value {
                cell.phaseIndicator?.textColor = UIColor.warning()
            }
            if  let c = p.red, d.int32Value >= c.int32Value {
                cell.phaseIndicator?.textColor = UIColor.danger()
            }
            if  let c = p.redBlink, d.int32Value >= c.int32Value {
                cell.phaseIndicator?.textColor = UIColor.danger()
                cell.phaseIndicator?.text = "▾"
            }
        }
    }
    
    
    func changeComment(_ speech: Speech) {
        let alertController = UIAlertController(
            title: "Change Description",
            message: "Please enter a new description for this speech",
            preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let commentField = alertController.textFields![0] as UITextField
            MagicalRecord.save({ (localContext: NSManagedObjectContext?) -> Void in
                let localSpeech: Speech = speech.mr_(in: localContext)
                localSpeech.comments = commentField.text
            }) { (success: Bool, error: Error?) -> Void in
                self.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.placeholder = speech.profile?.name
            textField.text = speech.comments
        }
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    // Handle selection for segue to speeches and demo mode
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        if self.isEditing {
            let speech = self.history[self.dates[indexPath.section]]![indexPath.row]
            changeComment(speech)
            return
        }
    }
    
    // Override to support editing the table view.
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
                           forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteItemAtIndexPath(indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteItemAtIndexPath(_ indexPath: IndexPath) {
            MagicalRecord.save({ (localContext: NSManagedObjectContext?) in
                // Delete the appropriate object
                let speech = self.history[self.dates[indexPath.section]]![indexPath.row]
                speech.mr_deleteEntity(in: localContext)
            }) { (success: Bool, error: Error?) -> Void in
                self.reloadData()
            }
    }
    
    override func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            let moreRowAction = UITableViewRowAction(
                style: UITableViewRowActionStyle.default,
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
                style: UITableViewRowActionStyle.default,
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
