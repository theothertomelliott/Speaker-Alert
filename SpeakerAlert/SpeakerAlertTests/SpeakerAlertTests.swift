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
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        MagicalRecord.cleanUp()
    }
    
    func testInitialContextIsEmpty(){
        let timings : NSArray = Profile.MR_findAll()
        let groups : NSArray = Group.MR_findAll()
        
        XCTAssert(timings.count == 0)
        XCTAssert(groups.count == 0)
    }
    
    func testTimingsCanBeGroupChildren(){
        let group : Group = Group.MR_createEntity()
        group.name = "Group1"
        
        let timer : Profile = Profile.MR_createEntity();
        timer.name = "Timer1"
        
        timer.parent = group
        
        if let ct = group.childTimings {
            XCTAssert(ct.containsObject(timer))
        } else {
            XCTFail("Expected a set of children in the group")
        }
        
        let timings : NSArray = Profile.MR_findAll()
        let groups : NSArray = Group.MR_findAll()
        
        XCTAssert(timings.count == 1)
        XCTAssert(groups.count == 1)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let timer : Profile = Profile.MR_createEntity();
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
