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

    let APP_ID = "488585337"

    var configManager: ConfigurationManager?
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
        if let sendSwitch: UISwitch = sender as? UISwitch {
            configManager?.isAutoStartEnabled = sendSwitch.on
        }
    }

    @IBAction func displayTimeChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            configManager?.isDisplayTime = sendSwitch.on
        }
    }

    @IBAction func vibrationChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            configManager?.isVibrationEnabled = sendSwitch.on
        }
    }

    override func tableView(
        tableView: UITableView,
        didHighlightRowAtIndexPath indexPath: NSIndexPath) {

        tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle =
            UITableViewCellSelectionStyle.None

        if indexPath.section == 1 && indexPath.row == 0 {
            self.showAbout()
        } else if indexPath.section == 1 && indexPath.row == 1 {
            self.rateApp()
        } else {
        }
    }

    func rateApp() {
        UIApplication.sharedApplication().openURL(
            NSURL(
                string : "itms-apps://itunes.apple.com/"
                + "WebObjects/MZStore.woa/wa/"
                + "viewContentsUserReviews?id=\(APP_ID)"
                + "&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!)
    }

    func showAbout() {
        let aboutView: RFAboutViewController = RFAboutViewController(
            appName: "Speaker Alert",
            appVersion: nil,
            appBuild: nil,
            copyrightHolderName: "Tom Elliott",
            contactEmail: "tom.w.elliott@gmail.com",
            titleForEmail: "Tom Elliott",
            websiteURL: NSURL(string: "http://telliott.io"),
            titleForWebsiteURL: "telliott.io",
            andPublicationYear: nil)
        aboutView.navigationBarBarTintColor = UINavigationBar.appearance().barTintColor
        aboutView.navigationBarTintColor = UINavigationBar.appearance().tintColor
        aboutView.blurStyle = .Dark
        aboutView.headerBackgroundImage = UIImage(named: "Icon1024")

        self.navigationController?.pushViewController(aboutView, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "demoSegue" {
            if let speechVC: SpeechViewController =
                segue.destinationViewController as? SpeechViewController {
                speechVC.demoMode = true
            }
        }
    }

}
