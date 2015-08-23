//
//  DataSeeder.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/21/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation
import MagicalRecord

class DataSeeder: NSObject {
    
    private let seedVersion = 1
    private let seedVersionKey = "seedVersion"

    private func doSeeding(){
        NSLog("Seeding data")
        
        // Toastmasters speech timings
        
        MagicalRecord.saveWithBlock { (localContext: NSManagedObjectContext!) -> Void in
            // This block runs in background thread
            
            let group : Group = Group.MR_createEntityInContext(localContext)
            group.name = "Toastmasters"

            let tableTopic : Profile = Profile.MR_createEntityInContext(localContext)
            tableTopic.name = "Table Topic"
            tableTopic.green = 1*60
            tableTopic.yellow = 1*60 + 30
            tableTopic.red = 2*60
            tableTopic.redBlink = 2*60 + 30
            
            let speechEvaluation : Profile = Profile.MR_createEntityInContext(localContext)
            speechEvaluation.name = "Speech Evaluation"
            speechEvaluation.green = 2*60
            speechEvaluation.yellow = 2*60 + 30
            speechEvaluation.red = 3*60
            speechEvaluation.redBlink = 3*60 + 30
            
            let fourToSix : Profile = Profile.MR_createEntityInContext(localContext)
            fourToSix.name = "Speech: Four to Six Minutes"
            fourToSix.green = 4*60
            fourToSix.yellow = 5*60
            fourToSix.red = 6*60
            fourToSix.redBlink = 6*60 + 30
            
            let fiveToSeven : Profile = Profile.MR_createEntityInContext(localContext)
            fiveToSeven.name = "Speech: Five to Seven Minutes"
            fiveToSeven.green = 5*60
            fiveToSeven.yellow = 6*60
            fiveToSeven.red = 7*60
            fiveToSeven.redBlink = 7*60 + 30
            
            let eightToTen : Profile = Profile.MR_createEntityInContext(localContext)
            eightToTen.name = "Speech: Eight to Ten Minutes"
            eightToTen.green = 8*60
            eightToTen.yellow = 9*60
            eightToTen.red = 10*60
            eightToTen.redBlink = 10*60 + 30
            
            let generalEval : Profile = Profile.MR_createEntityInContext(localContext)
            generalEval.name = "General Evaluation"
            generalEval.green = 8*60
            generalEval.yellow = 9*60
            generalEval.red = 10*60
            generalEval.redBlink = 10*60 + 30
            
            group.childTimings = [tableTopic, speechEvaluation, fourToSix, fiveToSeven, eightToTen, generalEval]
            
        }
    }
    
    func seedAsRequired(){
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var shouldSeed : Bool = true;
        
        if let seedVersion : Int = defaults.integerForKey(seedVersionKey)
        {
            if seedVersion >= self.seedVersion {
                shouldSeed = false
            }
        }
        
        if shouldSeed {
            self.doSeeding()
            defaults.setInteger(self.seedVersion, forKey: self.seedVersionKey)
        }
    
    }
    
    
}
