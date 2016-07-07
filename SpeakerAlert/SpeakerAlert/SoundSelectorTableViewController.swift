//
//  SoundSelectorTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/6/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class SoundSelectorTableViewController: UITableViewController {

    var configManager: ConfigurationManager?
    var audioAlertManager: AudioAlertManager?
    
    static let soundFiles: [String:String] = [
        "Alarm Frenzy" : "alarm-frenzy",
        "Chafing" : "chafing",
        "Communication Channel" : "communication-channel",
        "Job Done" : "job-done",
        "Just Like Magic" : "just-like-magic",
        "Nice Cut" : "nice-cut",
        "Served" : "served",
        "Solemn" : "solemn",
        "System Fault" : "system-fault",
        "What Friend Are For" : "what-friends-are-for",
        "Demonstrative" : "demonstrative",
        "Jingle Bells SMS" : "jingle-bells-sms"
    ]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SoundSelectorTableViewController.soundFiles.keys.count
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        var titles = Array(SoundSelectorTableViewController.soundFiles.keys)
        let title = titles[indexPath.row]
        cell.textLabel?.text = title
        if let fileName = SoundSelectorTableViewController.soundFiles[title] where fileName == configManager?.audioFile {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let text = cell?.textLabel?.text {
            if let fileName = SoundSelectorTableViewController.soundFiles[text] {
                configManager?.audioFile = fileName
                audioAlertManager?.playSound()
            }
        }
    }
    
    
}
