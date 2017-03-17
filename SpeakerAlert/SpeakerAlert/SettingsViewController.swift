//
//  SettingsViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/3/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import RFAboutView

class SettingsViewController: UITableViewController,
                                MFMailComposeViewControllerDelegate,
                                ConfigurationManagerDependency {

    let APP_ID = "488585337"

    var configManager: ConfigurationManager
    var tableSections: [SectionDefinition] = []
    
    // Initializers for the app, using property injection
    required init?(coder aDecoder: NSCoder) {
        configManager = SettingsViewController._configurationManager()
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        configManager = SettingsViewController._configurationManager()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Initializer for testing, using initializer injection
    init(configurationManager: ConfigurationManager) {
        self.configManager = configurationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return tableSections[section].cells.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        return tableSections[section].title
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let def = tableSections[indexPath.section].cells[indexPath.row]
        return def.cell(tableView, indexPath: indexPath)
    }

    func generalSection(_ config: ConfigurationManager) -> SectionDefinition {
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
    
    func presetSection(_ config: ConfigurationManager) -> SectionDefinition {
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
    
    func speechDisplaySection(_ config: ConfigurationManager) -> SectionDefinition {
        return SectionDefinition(
            title: "Speech Display",
            cells: [
                SelectionCellDefinition(
                    title: "Time display",
                    initialValue: config.timeDisplayMode.rawValue,
                    options: [
                        TimeDisplay.None.rawValue,
                        TimeDisplay.CountUp.rawValue,
                        TimeDisplay.CountDown.rawValue
                    ],
                    onChange: { (value: String) in
                        config.timeDisplayMode = StringToTimeDisplay(value)
                        self.loadData()
                }),
                BoolCellDefinition(
                    title: "Hide status bar",
                    value: config.isHideStatusEnabled,
                    onChange: { (value: Bool) in
                        config.isHideStatusEnabled = value
                        self.loadData()
                }),
                BoolCellDefinition(
                    title: "Hide controls",
                    value: config.isHideControlsEnabled,
                    onChange: { (value: Bool) in
                        config.isHideControlsEnabled = value
                        self.loadData()
                })
            ])
    }
    
    func alertSection(_ config: ConfigurationManager) -> SectionDefinition {
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
                    title: "Notification Alerts in Background",
                    value: config.areNotificationsEnabled,
                    onChange: { (value: Bool) in
                        config.areNotificationsEnabled = value
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
                        self.performSegue(withIdentifier: "showAudioList", sender: self)
                }),
                BoolCellDefinition(
                    title: "Additional alert when over time",
                    value: config.isAlertOvertimeEnabled,
                    onChange: { (value: Bool) in
                        config.isAlertOvertimeEnabled = value
                        self.loadData()
                }),
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
            tableSections = [
                generalSection(configManager),
                presetSection(configManager),
                speechDisplaySection(configManager),
                alertSection(configManager),
                appSection(),
                contactSection()
            ]
            tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func tableView(
        _ tableView: UITableView,
        didHighlightRowAt indexPath: IndexPath) {
        
        if let def = tableSections[indexPath.section].cells[indexPath.row] as? CellWithAction {
            def.performAction()
        }
        
        tableView.cellForRow(at: indexPath)?.selectionStyle =
            UITableViewCellSelectionStyle.none
    }

    func contactEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func contactFacebook() {
        UIApplication.shared.openURL(
            URL(
                string : "https://www.facebook.com/speakeralert")!
        )
    }
    
    func contactTwitter() {
        UIApplication.shared.openURL(
            URL(
                string : "https://twitter.com/speakeralertapp")!
        )
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["speakeralert@telliott.io"])
        
        let bundle = Bundle.main
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
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
                            error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func rateApp() {
        UIApplication.shared.openURL(
            URL(
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
            websiteURL: URL(string: "http://telliott.io"),
            titleForWebsiteURL: "telliott.io",
            andPublicationYear: nil)
        aboutView.navigationBarBarTintColor = UINavigationBar.appearance().barTintColor
        aboutView.navigationBarTintColor = UINavigationBar.appearance().tintColor
        aboutView.blurStyle = .dark
        aboutView.headerBackgroundImage = UIImage(named: "Icon1024")

        aboutView.addAdditionalButton(
            withTitle: "Audio",
            subtitle: "Content Creators",
            andContent:"Audio clips provided by NotificationSounds\n" +
            "https://notificationsounds.com/\n\n" +
            "Under a Creative Commons Attribution License.\n" +
            "https://creativecommons.org/licenses/by/4.0/legalcode"
        )
        
        self.navigationController?.pushViewController(aboutView, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "demoSegue" {
            if let speechVC: SpeechViewController =
                segue.destination as? SpeechViewController {
                speechVC.demoMode = true
            }
        }
    }

}
