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
    var tableSections: [SectionDefinition] = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return tableSections[section].cells.count
    }
    
    override func tableView(
        tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        return tableSections[section].title
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let def = tableSections[indexPath.section].cells[indexPath.row]
        return def.cell(tableView, indexPath: indexPath)
    }

    func generalSection(config: ConfigurationManager) -> SectionDefinition {
        return SectionDefinition(
            title: "General",
            cells: [
                BoolCellDefinition(
                    title: "Start speeches on opening",
                    value: config.isAutoStartEnabled,
                    onChange: { (value: Bool) in
                        config.isAutoStartEnabled = value
                        self.loadData()
                })
            ])
    }
    
    func presetSection(config: ConfigurationManager) -> SectionDefinition {
        var presetName = "[Custom]"
        if let ps = config.currentPreset() {
            presetName = ps.name
        }
        
        var options: [String] = []
        for preset in config.allPresets() {
            options.append(preset.name)
        }
        
        return SectionDefinition(
            title: "Presets",
            cells: [
                SelectionCellDefinition(
                    title: "Speech Mode",
                    initialValue: presetName,
                    options: options,
                    onChange: { (value: String) in
                        if let preset = config.findPreset(value) {
                            config.applyPreset(preset)
                        }
                        self.loadData()
                })
            ])
    }
    
    func speechDisplaySection(config: ConfigurationManager) -> SectionDefinition {
        return SectionDefinition(
            title: "Speech Display",
            cells: [
                BoolCellDefinition(
                    title: "Display time elapsed",
                    value: config.isDisplayTime,
                    onChange: { (value: Bool) in
                        config.isDisplayTime = value
                        self.loadData()
                }),
                BoolCellDefinition(
                    title: "Hide status bar",
                    value: config.isHideStatusEnabled,
                    onChange: { (value: Bool) in
                        config.isHideStatusEnabled = value
                        self.loadData()
                })
            ])
    }
    
    func alertSection(config: ConfigurationManager) -> SectionDefinition {
        return SectionDefinition(
            title: "Alerts",
            cells: [
                BoolCellDefinition(
                    title: "Vibration Alerts",
                    value: config.isVibrationEnabled,
                    onChange: { (value: Bool) in
                        config.isVibrationEnabled = value
                        self.loadData()
                }),
                BoolCellDefinition(
                    title: "Audio Alerts",
                    value: config.isAudioEnabled,
                    onChange: { (value: Bool) in
                        config.isAudioEnabled = value
                        self.loadData()
                }),
                ActionCellDefinition(
                    title: "Alert Sound",
                    detail: config.audioFile,
                    hasDisclosure: true,
                    action: {
                        self.performSegueWithIdentifier("showAudioList", sender: self)
                })
                // TODO: Flash when over time
            ])
    }
    
    func appSection() -> SectionDefinition {
        return SectionDefinition(
            title: "App",
            cells: [
                ActionCellDefinition(
                    title: "About Speaker Alert",
                    detail: nil,
                    hasDisclosure: true,
                    action: {
                        self.showAbout()
                }),
                ActionCellDefinition(
                    title: "Rate us in the App Store",
                    detail: nil,
                    hasDisclosure: false,
                    action: {
                        self.rateApp()
                })
            ])
    }
    
    func contactSection() -> SectionDefinition {
        return SectionDefinition(
            title: "Contact",
            cells: [
                ActionCellDefinition(
                    title: "E-mail",
                    detail: "speakeralert@telliott.io",
                    hasDisclosure: false,
                    action: {
                        self.contactEmail()
                }),
                ActionCellDefinition(
                    title: "Facebook",
                    detail: "speakeralert",
                    hasDisclosure: false,
                    action: {
                        self.contactFacebook()
                }),
                ActionCellDefinition(
                    title: "Twitter",
                    detail: "@speakeralertapp",
                    hasDisclosure: false,
                    action: {
                        self.contactTwitter()
                }),
            ])
    }
    
    func loadData() {
        if let cm = configManager {
            tableSections = [
                generalSection(cm),
                presetSection(cm),
                speechDisplaySection(cm),
                alertSection(cm),
                appSection(),
                contactSection()
            ]
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    override func tableView(
        tableView: UITableView,
        didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        if let def = tableSections[indexPath.section].cells[indexPath.row] as? CellWithAction {
            def.performAction()
        }
        
        tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle =
            UITableViewCellSelectionStyle.None
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

protocol CellDefinition {
    var title: String { get set }
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
}

protocol CellWithAction {
    func performAction()
}

struct SectionDefinition {
    var title: String = ""
    var cells: [CellDefinition] = []
}

struct ActionCellDefinition: CellDefinition, CellWithAction {
    var title: String = ""
    var detail: String?
    var hasDisclosure: Bool = false
    var action: () -> () = {_ in}
    
    func performAction() {
        self.action()
    }
    
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "ActionCell",
            forIndexPath: indexPath
        )
        if let c = cell as? ActionCell {
            c.titleLabel?.text = self.title
            c.detailTextLabel?.hidden = true
            if self.hasDisclosure {
                c.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                c.accessoryType = UITableViewCellAccessoryType.None
            }
            if let d = self.detail {
                c.detailTextLabel?.hidden = false
                c.detailTextLabel?.text = d
            }
        }
        return cell
    }
}

class SelectionCellDefinition: CellDefinition, CellWithAction {
    var title: String = ""
    var initialValue: String = ""
    var options: [String] = []
    var onChange: (String) -> () = {_ in}
    
    init(title: String, initialValue: String, options: [String], onChange: (String) -> ()) {
        self.title = title
        self.initialValue = initialValue
        self.options = options
        self.onChange = onChange
    }
    
    private var cell: SelectionCell?
    
    func performAction() {
        if let c = cell {
            c.openPicker()
        }
    }
    
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "SelectionCell",
            forIndexPath: indexPath
        )
        if let c = cell as? SelectionCell {
            c.textLabel?.text = self.title
            c.detailTextLabel?.text = self.initialValue
            c.pickerData = self.options
            c.onChange = self.onChange
            self.cell = c
        }
        return cell
    }
}

struct BoolCellDefinition: CellDefinition {
    var title: String = ""
    var value: Bool = false
    var onChange: (Bool) -> () = {_ in}
    
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCellWithIdentifier("OnOffCell", forIndexPath: indexPath)
        if let cell = c as? OnOffCell {
            cell.titleLabel?.text = self.title
            cell.valueSwitch?.on = self.value
            cell.onChange = self.onChange
            return cell
        }
        return c
    }
}

class OnOffCell: UITableViewCell {

    var onChange: (Bool) -> () = {_ in }
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var valueSwitch: UISwitch?
    @IBAction func valueChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            onChange(sendSwitch.on)
        }
    }
    
}

class ActionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
}

class SelectionCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var picker: UIPickerView = UIPickerView()
    var pickerData: [String] = []
    var actionView: UIView = UIView()
    
    var onChange: (String) -> () = {_ in }
    
    // MARK - Picker delegate
    
    func pickerView(
        _pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func openPicker()
    {
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        
        picker.frame = CGRectMake(0.0, 44.0, kSCREEN_WIDTH, 216.0)
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.backgroundColor = UIColor.whiteColor()
        
        let pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, kSCREEN_WIDTH, 44))
        pickerDateToolbar.barStyle = UIBarStyle.Black
        pickerDateToolbar.barTintColor = UIColor.blackColor()
        pickerDateToolbar.translucent = true
        
        var barItems: [UIBarButtonItem] = []
        
        let labelCancel = UILabel()
        labelCancel.text = "Cancel"
        let titleCancel = UIBarButtonItem(
            title: labelCancel.text,
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(SelectionCell.cancelPickerSelectionButtonClicked(_:)))
        barItems.append(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
            target: self,
            action: nil)
        barItems.append(flexSpace)
        
        picker.selectRow(1, inComponent: 0, animated: false)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                      target: self,
                                      action: #selector(SelectionCell.doneClicked(_:)))
        barItems.append(doneBtn)
        
        pickerDateToolbar.setItems(barItems, animated: true)
        
        actionView.addSubview(pickerDateToolbar)
        actionView.addSubview(picker)
        
        if (window) != nil {
            window!.addSubview(actionView)
        } else {
            self.superview?.addSubview(actionView)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 260.0, UIScreen.mainScreen().bounds.size.width, 260.0)
            
        })
    }
    
    
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func doneClicked(sender: UIBarButtonItem) {
        let myRow = picker.selectedRowInComponent(0)
        self.detailTextLabel?.text = pickerData[myRow]

        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView {
                        view.removeFromSuperview()
                    }
                }
        })
        
        self.onChange(pickerData[myRow])
    }
    
}