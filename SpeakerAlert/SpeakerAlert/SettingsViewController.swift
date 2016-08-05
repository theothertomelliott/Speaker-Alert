//
//  SettingsViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/3/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import RFAboutView

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    let APP_ID = "488585337"

    var configManager: ConfigurationManager?
    @IBOutlet weak var autoStartSwitch: UISwitch?
    @IBOutlet weak var displayTimeSwitch: UISwitch?
    @IBOutlet weak var vibrationSwitch: UISwitch?
    @IBOutlet weak var hideControlsSwitch: UISwitch?
    @IBOutlet weak var audioAlertSwitch: UISwitch?
    @IBOutlet weak var hideStatusSwitch: UISwitch?
    
    @IBOutlet weak var audioTitleLabel: UILabel?

    override func viewWillAppear(animated: Bool) {
        if let cm = configManager {
            autoStartSwitch?.setOn(cm.isAutoStartEnabled, animated: false)
            displayTimeSwitch?.setOn(cm.isDisplayTime, animated: false)
            vibrationSwitch?.setOn(cm.isVibrationEnabled, animated: false)
            hideControlsSwitch?.setOn(cm.isHideControlsEnabled, animated: false)
            audioAlertSwitch?.setOn(cm.isAudioEnabled, animated: false)
            hideStatusSwitch?.setOn(cm.isHideStatusEnabled, animated: false)
            
            for (title, fileName) in SoundSelectorTableViewController.soundFiles {
                if fileName == cm.audioFile {
                    audioTitleLabel?.text = title
                }
            }
            
            
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
    
    @IBAction func audioAlertChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            configManager?.isAudioEnabled = sendSwitch.on
        }
    }
    
    @IBAction func hideControlsChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            configManager?.isHideControlsEnabled = sendSwitch.on
        }
    }
    
    @IBAction func hideStatusChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            configManager?.isHideStatusEnabled = sendSwitch.on
        }
    }

    override func tableView(
        tableView: UITableView,
        didHighlightRowAtIndexPath indexPath: NSIndexPath) {

        tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle =
            UITableViewCellSelectionStyle.None

        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.showAbout()
            } else if indexPath.row == 1 {
                self.rateApp()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // email
                contactEmail()
            } else if indexPath.row == 1 {
                // facebook
                contactFacebook()
            } else {
                // twitter
                contactTwitter()
            }
        }
    }

    func contactEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func contactFacebook() {
        UIApplication.sharedApplication().openURL(
            NSURL(
                string : "https://www.facebook.com/speakeralert")!
        )
    }
    
    func contactTwitter() {
        UIApplication.sharedApplication().openURL(
            NSURL(
                string : "https://twitter.com/speakeralertapp")!
        )
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["speakeralert@telliott.io"])
        
        let bundle = NSBundle.mainBundle()
        if let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String {
            mailComposerVC.setSubject("Speaker Alert version " + version)
        } else {
            mailComposerVC.setSubject("Speaker Alert")
        }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(
            title: "Could Not Send Email",
            message: "Your device could not send e-mail." +
                     "Please check e-mail configuration and try again.",
            delegate: self,
            cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(
        controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult,
                            error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rateApp() {
        UIApplication.sharedApplication().openURL(
            NSURL(
                string : "itms-apps://itunes.apple.com/app/id\(APP_ID)")!
        )
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

        aboutView.addAdditionalButtonWithTitle(
            "Audio",
            subtitle: "Content Creators",
            andContent:"Audio clips provided by NotificationSounds\n" +
            "https://notificationsounds.com/\n\n" +
            "Under a Creative Commons Attribution License.\n" +
            "https://creativecommons.org/licenses/by/4.0/legalcode"
        )
        
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
