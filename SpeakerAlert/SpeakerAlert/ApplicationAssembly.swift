//
//  ApplicationAssembly.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/26/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Typhoon

public class ApplicationAssembly: TyphoonAssembly {

    /*
    * This is the definition for our AppDelegate. Typhoon will inject the specified properties
    * at application startup.
    */
    public dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) {
            (definition) in
            definition.injectProperty(#selector(ApplicationAssembly.localNotificationManager),
                with: self.localNotificationManager())
            definition.injectProperty(#selector(ApplicationAssembly.parameterManager),
                                      with: self.parameterManager())
        }
    }
    
    public dynamic func parameterManager() -> AnyObject {
        return TyphoonDefinition.withClass(ParameterManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    public dynamic func configurationManager() -> AnyObject {
        return TyphoonDefinition.withClass(ConfigurationManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty(#selector(ApplicationAssembly.parameterManager),
                                      with: self.parameterManager())
        }
    }

    public dynamic func appColorManager() -> AnyObject {
        return TyphoonDefinition.withClass(AppColorManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty(Selector("baseColor"),
                with: UIColor(
                    red: 160/255,
                    green: 213/255,
                    blue: 227/255,
                    alpha: 1.0))
        }
    }

    public dynamic func dataSeeder() -> AnyObject {
        return TyphoonDefinition.withClass(DataSeeder.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    public dynamic func speechManager() -> AnyObject {
        return TyphoonDefinition.withClass(SpeechManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty(#selector(ApplicationAssembly.parameterManager),
                                      with: self.parameterManager())
        }
    }

    public dynamic func localNotificationManager() -> AnyObject {
        return TyphoonDefinition.withClass(LocalNotificationManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty("speechMan", with: self.speechManager())
        }
    }

    @available(iOS 9, *)
    public dynamic func watchCommsManager() -> AnyObject {
        return TyphoonDefinition.withClass(WatchCommsManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty("configMan", with: self.configurationManager())
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectMethod(#selector(TyphoonAssembly.activate), parameters: nil)
        }
    }

    public dynamic func vibrationAlertManager() -> AnyObject {
        return TyphoonDefinition.withClass(VibrationAlertManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectProperty("configMan", with: self.configurationManager())
        }
    }
    
    public dynamic func audioAlertManager() -> AnyObject {
        return TyphoonDefinition.withClass(AudioAlertManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectProperty("configMan", with: self.configurationManager())
        }
    }

    // MARK: View Controllers

    public dynamic func loadingViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoadingViewController.self) {
            (definition) in
            definition.injectProperty(
                #selector(ApplicationAssembly.dataSeeder),
                with: self.dataSeeder())
        }
    }

    public dynamic func groupTableViewController() -> AnyObject {
        return TyphoonDefinition.withClass(GroupTableViewController.self) {
            (definition) in
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectProperty("configMan", with: self.configurationManager())
        }
    }

    public dynamic func speechViewController() -> AnyObject {
        return TyphoonDefinition.withClass(SpeechViewController.self) {
            (definition) in
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectProperty("configMan", with: self.configurationManager())
        }
    }
    
    public dynamic func defaultSpeechViewController() -> AnyObject {
        return TyphoonDefinition.withClass(DefaultSpeechViewController.self) {
            (definition) in
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectProperty("configMan", with: self.configurationManager())
        }
    }
    
    public dynamic func testSpeechViewController() -> AnyObject {
        return TyphoonDefinition.withClass(UITestSpeechViewController.self) {
            (definition) in
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectProperty("configMan", with: self.configurationManager())
        }
    }

    public dynamic func settingsViewController() -> AnyObject {
        return TyphoonDefinition.withClass(SettingsViewController.self) {
            (definition) in
            definition.injectProperty("configManager", with: self.configurationManager())
        }
    }
    
    public dynamic func soundSelectorTableViewController() -> AnyObject {
        return TyphoonDefinition.withClass(SoundSelectorTableViewController.self) {
            (definition) in
            definition.injectProperty("configManager", with: self.configurationManager())
            definition.injectProperty("audioAlertManager", with: self.audioAlertManager())
        }
    }

}
