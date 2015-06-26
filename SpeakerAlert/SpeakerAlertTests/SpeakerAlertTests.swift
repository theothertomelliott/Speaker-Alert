//
//  SpeakerAlertTests.swift
//  SpeakerAlertTests
//
//  Created by Thomas Elliott on 6/10/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import XCTest
import MagicalRecord

class SpeakerAlertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
        
        let timer : Timing = Timing.MR_createEntity();
        timer.green = 1;
        timer.yellow = 2;
        timer.red = 3;
        timer.redBlink = 4;

        // TODO: We need to effectively save the context
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
