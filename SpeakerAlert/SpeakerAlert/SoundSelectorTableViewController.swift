//
//  SoundSelectorTableViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/6/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class SoundSelectorTableViewController: UITableViewController,
                                        ConfigurationManagerDependency,
                                        AudioAlertManagerDependency {

    var configManager: ConfigurationManager
    var audioAlertManager: AudioAlertManager
    
    // Initializers for the app, using property injection
    required init?(coder aDecoder: NSCoder) {
        configManager = SoundSelectorTableViewController._configurationManager()
        audioAlertManager = SoundSelectorTableViewController._audioAlertManager()
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        configManager = SoundSelectorTableViewController._configurationManager()
        audioAlertManager = SoundSelectorTableViewController._audioAlertManager()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Initializer for testing, using initializer injection
    init(configurationManager: ConfigurationManager, audioAlertManager: AudioAlertManager) {
        self.configManager = configurationManager
        self.audioAlertManager = audioAlertManager
        super.init(nibName: nil, bundle: nil)
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SoundSelectorTableViewController.soundFiles.keys.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        var titles = Array(SoundSelectorTableViewController.soundFiles.keys)
        let title = titles[indexPath.row]
        cell.textLabel?.text = title
        if let fileName = SoundSelectorTableViewController.soundFiles[title], fileName == configManager.audioFile {
            tableView.selectRow(
                at: indexPath,
                animated: false,
                scrollPosition: UITableViewScrollPosition.middle
            )
        }
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
        ) {
        let cell = tableView.cellForRow(at: indexPath)
        if let text = cell?.textLabel?.text {
            if let fileName = SoundSelectorTableViewController.soundFiles[text] {
                configManager.audioFile = fileName
                audioAlertManager.playSound()
            }
        }
    }
    
    
}
