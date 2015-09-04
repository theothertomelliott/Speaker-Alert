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

    @IBAction func autoStartChanged(sender: AnyObject) {
        // TODO: Update autostart setting
    }
    
    @IBAction func displayTimeChanged(sender: AnyObject) {
        // TODO: Update display time by default setting
    }
    
    @IBAction func vibrationChanged(sender: AnyObject) {
        // TODO: Update vibration alert setting
    }
    
    override func viewDidLoad() {
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
        aboutView.headerBackgroundColor = .blackColor()
        aboutView.headerTextColor = .whiteColor()
        aboutView.blurStyle = .Dark
        aboutView.headerBackgroundImage = UIImage(named: "Icon1024")
        
        self.navigationController?.pushViewController(aboutView, animated: true)
    }
    
    
}
