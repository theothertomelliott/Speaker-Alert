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
        }
    }
    
    public dynamic func speechManager() -> AnyObject {
        return TyphoonDefinition.withClass(SpeechManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    public dynamic func watchCommsManager() -> AnyObject {
        return TyphoonDefinition.withClass(WatchCommsManager.self){
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty("speechMan", with: self.speechManager())
            definition.injectMethod("activate", parameters: nil)
        }
    }
    
    public dynamic func vibrationAlertManager() -> AnyObject {
        return TyphoonDefinition.withClass(VibrationAlertManager.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
            definition.injectProperty("speechMan", with: self.speechManager())
        }
    }
    
    // MARK: View Controllers
    
    public dynamic func groupTableViewController() -> AnyObject {
        return TyphoonDefinition.withClass(GroupTableViewController.self) {
            (definition) in
        }
    }
    
    public dynamic func timingViewController() -> AnyObject {
        return TyphoonDefinition.withClass(TimingViewController.self) {
            (definition) in
            definition.injectProperty("speechMan", with: self.speechManager())
        }
    }
    
    public dynamic func speechViewController() -> AnyObject {
        return TyphoonDefinition.withClass(SpeechViewController.self) {
            (definition) in
            definition.injectProperty("speechMan", with: self.speechManager())
        }
    }
    
}
