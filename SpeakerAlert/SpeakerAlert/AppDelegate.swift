//
//  AppDelegate.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import JVArgumentParser

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let localNotificationManager = Environment.Default.localNotificationManager
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let parameterManager = Environment.Default.parameterManager
        
        // Set up Pyze for analytics
        if _isDebugAssertConfiguration() {
            Pyze.initialize("HkpiF7XpQaqgwGDidBvmzw")
        } else {
            Pyze.initialize("mkneZ7xjSjKM5Mdn0Mra_w")
        }
        
        if parameterManager.isUITesting {
            NSLog("UI Testing!")
            MagicalRecord.setupCoreDataStackWithInMemoryStore()
        } else {
            // Configure core data
            MagicalRecord.setupAutoMigratingCoreDataStack()
        }
        
        let m = AppColorManager()
        m.baseColor = UIColor(
            red: 160/255,
            green: 213/255,
            blue: 227/255,
            alpha: 1.0)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.localNotificationManager.enteredBackground()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NSLog("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSLog("applicationDidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.saveWithBlock { (context: NSManagedObjectContext!) -> Void in
            NSLog("Saving context")
        }

        NSLog("Cleaning up")
        MagicalRecord.cleanUp()
    }

}
