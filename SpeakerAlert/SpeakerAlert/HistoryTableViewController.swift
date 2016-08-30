//
//  HistoryTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/26/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var history: [String:[Speech]] = [:]
    var dates: [String] = []
    
    override func viewWillAppear(animated: Bool) {
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
        
            cell.elapsed?.text = ""
            cell.date?.text = "Start time unknown"
            cell.name?.text = "<Title>"
            if let start = speech.startTime {
                
                let formatter = NSDateFormatter()
                formatter.dateStyle = .NoStyle
                formatter.timeStyle = .MediumStyle
                
                cell.date?.text = formatter.stringFromDate(start)
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
            return cell
        }
        
        return reusedCell
       
    }
    
}

class HistoryItemCell: UITableViewCell {
    
    @IBOutlet var name: UILabel?
    @IBOutlet var date: UILabel?
    @IBOutlet var elapsed: UILabel?
    @IBOutlet var profileInfo: UILabel?
    
}
