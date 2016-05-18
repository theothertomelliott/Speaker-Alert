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

    var testSet: String = "default"
    var isUITesting: Bool = false
    
    override init(){
        super.init()
        parseParams()
    }
    
    func parseParams(){
        let parser = JVArgumentParser()
        
        parser.addOptionWithArgumentWithLongName("testset") { (value: String!) in
            self.testSet = value
        }
        parser.addOptionWithLongName("uitesting") { () in
            self.isUITesting = true
        }
        
        do {
            try parser.parse(NSProcessInfo.processInfo().arguments)
        } catch {
            NSLog("Couldn't parse arguments")
        }
    }
    
}
