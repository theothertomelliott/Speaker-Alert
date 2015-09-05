//
//  SettingsViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/3/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import RFAboutView

class SettingsViewController: UITableViewController {

    var configManager : ConfigurationManager?
    @IBOutlet weak var autoStartSwitch: UISwitch!
    @IBOutlet weak var displayTimeSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    
    override func viewWillAppear(animated: Bool) {
        if let cm = configManager {
            autoStartSwitch.setOn(cm.isAutoStartEnabled, animated: false)
            displayTimeSwitch.setOn(cm.isDisplayTime, animated: false)
            vibrationSwitch.setOn(cm.isVibrationEnabled, animated: false)
        }
    }
    
    @IBAction func autoStartChanged(sender: AnyObject) {
        configManager?.isAutoStartEnabled = (sender as! UISwitch).on
    }
    
    @IBAction func displayTimeChanged(sender: AnyObject) {
        configManager?.isDisplayTime = (sender as! UISwitch).on
    }
    
    @IBAction func vibrationChanged(sender: AnyObject) {
        configManager?.isVibrationEnabled = (sender as! UISwitch).on
    }

    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(indexPath.section == 1 && indexPath.row == 0){
            self.showAbout()
        } else {
        }
    }
    
    func showAbout(){
        let aboutView : RFAboutViewController = RFAboutViewController(appName: "Speaker Alert", appVersion: "2.0.0", appBuild: "1", copyrightHolderName: "Tom Elliott", contactEmail: "tom.w.elliott@gmail.com", titleForEmail: "Tom Elliott", websiteURL: NSURL(string: "http://telliott.io"), titleForWebsiteURL: "telliott.io", andPublicationYear: "2015")

        // TODO: Figure out how to use default colors
        //        aboutView.headerBackgroundColor = .blackColor()
        //        aboutView.headerTextColor = .whiteColor()
        //        aboutView.blurStyle = .Dark
        aboutView.headerBackgroundImage = UIImage(named: "Icon1024")
        
        self.navigationController?.pushViewController(aboutView, animated: true)
    }
    
    
}
