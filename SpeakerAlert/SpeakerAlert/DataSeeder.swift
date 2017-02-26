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

    fileprivate let seedVersion = 1
    fileprivate let seedVersionKey = "seedVersion"

    let defaults: UserDefaults
    
    var parameterManager: ParameterManager
    
    init(defaults: UserDefaults, parameters: ParameterManager) {
        self.defaults = defaults
        self.parameterManager = parameters
        super.init()
    }
    
    fileprivate var fourToSix: Profile?
    fileprivate var fiveToSeven: Profile?
    fileprivate var speechEvaluation: Profile?
    fileprivate var tableTopic: Profile?
    fileprivate var generalEvaluation: Profile?
    
    fileprivate func doSeeding() {
        NSLog("Seeding data")
        
        // Toastmasters speech timings
        
        MagicalRecord.save({(localContext: NSManagedObjectContext?) -> Void in
            // This block runs in background thread
            if let l = localContext {
                self.configureToastmastersTimings(l)
                self.configureGeneralTimings(l)
                
                if self.parameterManager.populateMeeting {
                    self.createDemoMeeting(l)
                }
            }
        })
    }
    
    fileprivate func createDate(_ dateAsString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.date(from: dateAsString)!
    }

    func createDemoMeeting(_ localContext: NSManagedObjectContext) {
        let speech1: Speech = Speech.mr_createEntity(in: localContext)
        speech1.comments = "Alice - Icebreaker"
        speech1.duration = 3*60 + 42 as NSNumber
        speech1.profile = fourToSix
        speech1.startTime = createDate("30-09-2016 19:07")

        let eval1: Speech = Speech.mr_createEntity(in: localContext)
        eval1.comments = "Bob - Evaluation"
        eval1.duration = 2*60 + 11 as NSNumber
        eval1.profile = speechEvaluation
        eval1.startTime = createDate("30-09-2016 19:12")

        let speech2: Speech = Speech.mr_createEntity(in: localContext)
        speech2.comments = "Chris - Speech 3"
        speech2.duration = 5*60 + 10 as NSNumber
        speech2.profile = fiveToSeven
        speech2.startTime = createDate("30-09-2016 19:16")
        
        let eval2: Speech = Speech.mr_createEntity(in: localContext)
        eval2.comments = "Diane - Evaluation"
        eval2.duration = 3*60 + 1 as NSNumber
        eval2.profile = speechEvaluation
        eval2.startTime = createDate("30-09-2016 19:23")
        
        let tableTopic1: Speech = Speech.mr_createEntity(in: localContext)
        tableTopic1.comments = "Eric - Table Topic"
        tableTopic1.duration = 1*60 + 12 as NSNumber
        tableTopic1.profile = speechEvaluation
        tableTopic1.startTime = createDate("30-09-2016 19:27")
        
        let tableTopic2: Speech = Speech.mr_createEntity(in: localContext)
        tableTopic2.comments = "Faith - Table Topic"
        tableTopic2.duration = 2*60 + 31 as NSNumber
        tableTopic2.profile = speechEvaluation
        tableTopic2.startTime = createDate("30-09-2016 19:30")
        
        let tableTopic3: Speech = Speech.mr_createEntity(in: localContext)
        tableTopic3.comments = "Georgia - Table Topic"
        tableTopic3.duration = 1*60 + 59 as NSNumber
        tableTopic3.profile = speechEvaluation
        tableTopic3.startTime = createDate("30-09-2016 19:35")
        
        let ge: Speech = Speech.mr_createEntity(in: localContext)
        ge.comments = "Harry - General Evaluation"
        ge.duration = 8*60 + 17 as NSNumber
        ge.profile = generalEvaluation
        ge.startTime = createDate("30-09-2016 19:40")
    }
    
    func configureGeneralTimings(_ localContext: NSManagedObjectContext) {
        // General timings

        let fiveMinutes: Profile = Profile.mr_createEntity(in: localContext)
        fiveMinutes.name = "Five Minutes"
        fiveMinutes.green = 4*60 as NSNumber
        fiveMinutes.yellow = 4*60 + 30 as NSNumber
        fiveMinutes.red = 5*60 as NSNumber
        fiveMinutes.redBlink = 5*60 + 30 as NSNumber

        let tenMinutes: Profile = Profile.mr_createEntity(in: localContext)
        tenMinutes.name = "Ten Minutes"
        tenMinutes.green = 8*60 as NSNumber
        tenMinutes.yellow = 9*60 as NSNumber
        tenMinutes.red = 10*60 as NSNumber
        tenMinutes.redBlink = 10*60 + 30 as NSNumber

        let twentyMinutes: Profile = Profile.mr_createEntity(in: localContext)
        twentyMinutes.name = "Twenty Minutes"
        twentyMinutes.green = 18*60 as NSNumber
        twentyMinutes.yellow = 19*60 as NSNumber
        twentyMinutes.red = 20*60 as NSNumber
        twentyMinutes.redBlink = 20*60 + 30 as NSNumber

        let thirtyMinutes: Profile = Profile.mr_createEntity(in: localContext)
        thirtyMinutes.name = "Thirty Minutes"
        thirtyMinutes.green = 25*60 as NSNumber
        thirtyMinutes.yellow = 27*60 + 30 as NSNumber
        thirtyMinutes.red = 30*60 as NSNumber
        thirtyMinutes.redBlink = 30*60 + 30 as NSNumber

        let oneHour: Profile = Profile.mr_createEntity(in: localContext)
        oneHour.name = "One Hour"
        oneHour.green = 50*60 as NSNumber
        oneHour.yellow = 55*60 as NSNumber
        oneHour.red = 60*60 as NSNumber
        oneHour.redBlink = 60*60 + 30 as NSNumber
    }

    func tableTopicTiming(_ localContext: NSManagedObjectContext) -> Profile {
        let tableTopic: Profile =
Profile.mr_createEntity(in: localContext)
        tableTopic.name = "Table Topic"
        tableTopic.green = 1*60 as NSNumber
        tableTopic.yellow = 1*60 + 30 as NSNumber
        tableTopic.red = 2*60 as NSNumber
        tableTopic.redBlink = 2*60 + 30 as NSNumber
        return tableTopic
    }

    func speechEvaluationTiming(_ localContext: NSManagedObjectContext) -> Profile {
        let speechEvaluation: Profile = Profile.mr_createEntity(in: localContext)
        speechEvaluation.name = "Speech Evaluation"
        speechEvaluation.green = 2*60 as NSNumber
        speechEvaluation.yellow = 2*60 + 30 as NSNumber
        speechEvaluation.red = 3*60 as NSNumber
        speechEvaluation.redBlink = 3*60 + 30 as NSNumber
        return speechEvaluation
    }

    func fourToSixTiming(_ localContext: NSManagedObjectContext) -> Profile {
    let fourToSix: Profile = Profile.mr_createEntity(in: localContext)
    fourToSix.name = "Speech: Four to Six Minutes"
    fourToSix.green = 4*60 as NSNumber
    fourToSix.yellow = 5*60 as NSNumber
    fourToSix.red = 6*60 as NSNumber
    fourToSix.redBlink = 6*60 + 30 as NSNumber
        return fourToSix
    }

    func fiveToSevenTiming(_ localContext: NSManagedObjectContext) -> Profile {
    let fiveToSeven: Profile = Profile.mr_createEntity(in: localContext)
    fiveToSeven.name = "Speech: Five to Seven Minutes"
    fiveToSeven.green = 5*60 as NSNumber
    fiveToSeven.yellow = 6*60 as NSNumber
    fiveToSeven.red = 7*60 as NSNumber
    fiveToSeven.redBlink = 7*60 + 30 as NSNumber
        return fiveToSeven
    }

    func eightToTenTiming(_ localContext: NSManagedObjectContext) -> Profile {
    let eightToTen: Profile = Profile.mr_createEntity(in: localContext)
    eightToTen.name = "Speech: Eight to Ten Minutes"
    eightToTen.green = 8*60 as NSNumber
    eightToTen.yellow = 9*60 as NSNumber
    eightToTen.red = 10*60 as NSNumber
    eightToTen.redBlink = 10*60 + 30 as NSNumber
        return eightToTen
    }

    func generalEvalTiming(_ localContext: NSManagedObjectContext) -> Profile {
    let generalEval: Profile = Profile.mr_createEntity(in: localContext)
    generalEval.name = "General Evaluation"
    generalEval.green = 8*60 as NSNumber
    generalEval.yellow = 9*60 as NSNumber
    generalEval.red = 10*60 as NSNumber
    generalEval.redBlink = 10*60 + 30 as NSNumber
        return generalEval
    }

    func configureToastmastersTimings(_ localContext: NSManagedObjectContext) {
        let groupToastmasters: Group = Group.mr_createEntity(in: localContext)
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

        let seedVersion: Int = defaults.integer(forKey: seedVersionKey)
        if seedVersion >= self.seedVersion {
            shouldSeed = false
        }

        if shouldSeed {
            self.doSeeding()
            defaults.set(self.seedVersion, forKey: self.seedVersionKey)
        }

    }


}
