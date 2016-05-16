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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var localNotificationManager: LocalNotificationManager?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if NSProcessInfo.processInfo().arguments.contains("isUITesting") {
            NSLog("UI Testing!")
            MagicalRecord.setupCoreDataStackWithInMemoryStore()

            let appDomain = NSBundle.mainBundle().bundleIdentifier!
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        } else {
            // Configure core data
            MagicalRecord.setupCoreDataStack()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.localNotificationManager?.enteredBackground()
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
