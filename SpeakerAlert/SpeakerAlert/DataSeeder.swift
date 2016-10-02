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

    let defaults: NSUserDefaults
    
    var parameterManager: ParameterManager
    
    init(defaults: NSUserDefaults, parameters: ParameterManager) {
        self.defaults = defaults
        self.parameterManager = parameters
        super.init()
    }
    
    private var fourToSix: Profile?
    private var fiveToSeven: Profile?
    private var speechEvaluation: Profile?
    private var tableTopic: Profile?
    private var generalEvaluation: Profile?
    
    private func doSeeding() {
        NSLog("Seeding data")

        // Toastmasters speech timings

        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            // This block runs in background thread
            self.configureToastmastersTimings(localContext)
            self.configureGeneralTimings(localContext)
            
            if self.parameterManager.populateMeeting {
                self.createDemoMeeting(localContext)
            }
        }
    }
    
    private func createDate(dateAsString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.dateFromString(dateAsString)!
    }

    func createDemoMeeting(localContext: NSManagedObjectContext) {
        let speech1: Speech = Speech.MR_createEntityInContext(localContext)
        speech1.comments = "Alice - Icebreaker"
        speech1.duration = 3*60 + 42
        speech1.profile = fourToSix
        speech1.startTime = createDate("30-09-2016 19:07")

        let eval1: Speech = Speech.MR_createEntityInContext(localContext)
        eval1.comments = "Bob - Evaluation"
        eval1.duration = 2*60 + 11
        eval1.profile = speechEvaluation
        eval1.startTime = createDate("30-09-2016 19:12")

        let speech2: Speech = Speech.MR_createEntityInContext(localContext)
        speech2.comments = "Chris - Speech 3"
        speech2.duration = 5*60 + 10
        speech2.profile = fiveToSeven
        speech2.startTime = createDate("30-09-2016 19:16")
        
        let eval2: Speech = Speech.MR_createEntityInContext(localContext)
        eval2.comments = "Diane - Evaluation"
        eval2.duration = 3*60 + 1
        eval2.profile = speechEvaluation
        eval2.startTime = createDate("30-09-2016 19:23")
        
        let tableTopic1: Speech = Speech.MR_createEntityInContext(localContext)
        tableTopic1.comments = "Eric - Table Topic"
        tableTopic1.duration = 1*60 + 12
        tableTopic1.profile = speechEvaluation
        tableTopic1.startTime = createDate("30-09-2016 19:27")
        
        let tableTopic2: Speech = Speech.MR_createEntityInContext(localContext)
        tableTopic2.comments = "Faith - Table Topic"
        tableTopic2.duration = 2*60 + 31
        tableTopic2.profile = speechEvaluation
        tableTopic2.startTime = createDate("30-09-2016 19:30")
        
        let tableTopic3: Speech = Speech.MR_createEntityInContext(localContext)
        tableTopic3.comments = "Georgia - Table Topic"
        tableTopic3.duration = 1*60 + 59
        tableTopic3.profile = speechEvaluation
        tableTopic3.startTime = createDate("30-09-2016 19:35")
        
        let ge: Speech = Speech.MR_createEntityInContext(localContext)
        ge.comments = "Harry - General Evaluation"
        ge.duration = 8*60 + 17
        ge.profile = generalEvaluation
        ge.startTime = createDate("30-09-2016 19:40")
    }
    
    func configureGeneralTimings(localContext: NSManagedObjectContext) {
        // General timings

        let fiveMinutes: Profile = Profile.MR_createEntityInContext(localContext)
        fiveMinutes.name = "Five Minutes"
        fiveMinutes.green = 4*60
        fiveMinutes.yellow = 4*60 + 30
        fiveMinutes.red = 5*60
        fiveMinutes.redBlink = 5*60 + 30

        let tenMinutes: Profile = Profile.MR_createEntityInContext(localContext)
        tenMinutes.name = "Ten Minutes"
        tenMinutes.green = 8*60
        tenMinutes.yellow = 9*60
        tenMinutes.red = 10*60
        tenMinutes.redBlink = 10*60 + 30

        let twentyMinutes: Profile = Profile.MR_createEntityInContext(localContext)
        twentyMinutes.name = "Twenty Minutes"
        twentyMinutes.green = 18*60
        twentyMinutes.yellow = 19*60
        twentyMinutes.red = 20*60
        twentyMinutes.redBlink = 20*60 + 30

        let thirtyMinutes: Profile = Profile.MR_createEntityInContext(localContext)
        thirtyMinutes.name = "Thirty Minutes"
        thirtyMinutes.green = 25*60
        thirtyMinutes.yellow = 27*60 + 30
        thirtyMinutes.red = 30*60
        thirtyMinutes.redBlink = 30*60 + 30

        let oneHour: Profile = Profile.MR_createEntityInContext(localContext)
        oneHour.name = "One Hour"
        oneHour.green = 50*60
        oneHour.yellow = 55*60
        oneHour.red = 60*60
        oneHour.redBlink = 60*60 + 30
    }

    func tableTopicTiming(localContext: NSManagedObjectContext) -> Profile {
        let tableTopic: Profile =
Profile.MR_createEntityInContext(localContext)
        tableTopic.name = "Table Topic"
        tableTopic.green = 1*60
        tableTopic.yellow = 1*60 + 30
        tableTopic.red = 2*60
        tableTopic.redBlink = 2*60 + 30
        return tableTopic
    }

    func speechEvaluationTiming(localContext: NSManagedObjectContext) -> Profile {
        let speechEvaluation: Profile = Profile.MR_createEntityInContext(localContext)
        speechEvaluation.name = "Speech Evaluation"
        speechEvaluation.green = 2*60
        speechEvaluation.yellow = 2*60 + 30
        speechEvaluation.red = 3*60
        speechEvaluation.redBlink = 3*60 + 30
        return speechEvaluation
    }

    func fourToSixTiming(localContext: NSManagedObjectContext) -> Profile {
    let fourToSix: Profile = Profile.MR_createEntityInContext(localContext)
    fourToSix.name = "Speech: Four to Six Minutes"
    fourToSix.green = 4*60
    fourToSix.yellow = 5*60
    fourToSix.red = 6*60
    fourToSix.redBlink = 6*60 + 30
        return fourToSix
    }

    func fiveToSevenTiming(localContext: NSManagedObjectContext) -> Profile {
    let fiveToSeven: Profile = Profile.MR_createEntityInContext(localContext)
    fiveToSeven.name = "Speech: Five to Seven Minutes"
    fiveToSeven.green = 5*60
    fiveToSeven.yellow = 6*60
    fiveToSeven.red = 7*60
    fiveToSeven.redBlink = 7*60 + 30
        return fiveToSeven
    }

    func eightToTenTiming(localContext: NSManagedObjectContext) -> Profile {
    let eightToTen: Profile = Profile.MR_createEntityInContext(localContext)
    eightToTen.name = "Speech: Eight to Ten Minutes"
    eightToTen.green = 8*60
    eightToTen.yellow = 9*60
    eightToTen.red = 10*60
    eightToTen.redBlink = 10*60 + 30
        return eightToTen
    }

    func generalEvalTiming(localContext: NSManagedObjectContext) -> Profile {
    let generalEval: Profile = Profile.MR_createEntityInContext(localContext)
    generalEval.name = "General Evaluation"
    generalEval.green = 8*60
    generalEval.yellow = 9*60
    generalEval.red = 10*60
    generalEval.redBlink = 10*60 + 30
        return generalEval
    }

    func configureToastmastersTimings(localContext: NSManagedObjectContext) {
        let groupToastmasters: Group = Group.MR_createEntityInContext(localContext)
        groupToastmasters.name = "Toastmasters"

        tableTopic = tableTopicTiming(localContext)
        speechEvaluation = speechEvaluationTiming(localContext)
        fourToSix = fourToSixTiming(localContext)
        fiveToSeven = fiveToSevenTiming(localContext)
        let eightToTen: Profile = eightToTenTiming(localContext)
        generalEvaluation = generalEvalTiming(localContext)

        groupToastmasters.childTimings = [
            tableTopic!, speechEvaluation!,
            fourToSix!, fiveToSeven!,
            eightToTen, generalEvaluation!]
    }

    func seedAsRequired() {

        var shouldSeed: Bool = true

        if let seedVersion: Int = defaults.integerForKey(seedVersionKey)
            where seedVersion >= self.seedVersion {
            shouldSeed = false
        }

        if shouldSeed {
            self.doSeeding()
            defaults.setInteger(self.seedVersion, forKey: self.seedVersionKey)
        }

    }


}
