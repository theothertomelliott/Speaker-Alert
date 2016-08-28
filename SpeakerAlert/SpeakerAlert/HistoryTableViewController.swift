//
//  HistoryTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/26/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var history: [Speech] = []
    
    override func viewWillAppear(animated: Bool) {
        if let h = Speech.MR_findAll() as? [Speech] {
            history = h
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let speech = history[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
                "LogItem",
                forIndexPath: indexPath)
        
        var s: String = "Unknown"
        var d: String = "Unknown"
        var c: String = "<Title>"
        if let start = speech.startTime {
            s = start.description
        }
        if let duration = speech.duration {
            d = duration.description
        }
        if let name = speech.profile?.name {
            c = name
        }
        if let comment = speech.comments {
            c = comment
        }
        
        cell.textLabel?.text = "\(c): \(s) - \(d)"
        return cell
       
    }
    
}
