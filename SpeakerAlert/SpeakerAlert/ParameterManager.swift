//
//  ParameterManager.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/18/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation
import JVArgumentParser

class ParameterManager: NSObject {

    // Set of seed data to use if the data store needs populating
    var seedDataSet: String = "default"
    // Indicates we're running UI tests and should not use the normal data store
    var isUITesting: Bool = false
    // Starting time for speeches - for testing purposes
    var starttime: Int = 0
    // Should accessibility mode be forced?
    var forceAccessibility: Bool = false
    // For testing, populate history with a meeting
    var populateMeeting: Bool = false
    
    // Force time display
    var forceShowTime: Bool = false
    
    var speechDisplay: String?
    
    override init() {
        super.init()
        parseParams()
    }
    
    func parseParams() {
        let parser = JVArgumentParser()
        
        parser.addOptionWithArgumentWithLongName("seeddata") { (value: String!) in
            self.seedDataSet = value
        }
        parser.addOptionWithLongName("uitesting") { () in
            self.isUITesting = true
        }
        parser.addOptionWithLongName("populatemeeting") { () in
            self.populateMeeting = true
        }
        parser.addOptionWithLongName("accessibility") { () in
            self.forceAccessibility = true
        }
        parser.addOptionWithLongName("forceshowtime") { () in
            self.forceShowTime = true
        }
        parser.addOptionWithArgumentWithLongName("starttime") { (value: String!) in
            if let st = Int(value) {
                self.starttime = st
            } else {
                NSLog("Invalid starttime value: %@", value)
            }
        }
        
        parser.addOptionWithArgumentWithLongName("speechdisplay") { (value: String!) in
            self.speechDisplay = value
        }
        
        do {
            try parser.parse(NSProcessInfo.processInfo().arguments)
        } catch {
            NSLog("Couldn't parse arguments")
        }
    }
    
}
