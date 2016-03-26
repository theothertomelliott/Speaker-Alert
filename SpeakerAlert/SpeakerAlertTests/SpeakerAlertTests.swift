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

    // TODO: Set up these tests to start with empty database


//    override func setUp() {
//        super.setUp()
//        MagicalRecord.setupCoreDataStackWithInMemoryStore()
//}
//
//    override func tearDown() {
//        super.tearDown()
//
//        MagicalRecord.cleanUp()
//    }
//
//    func testInitialContextIsEmpty() {
//        let timings: NSArray = Profile.MR_findAll()
//        let groups: NSArray = Group.MR_findAll()
//
//        XCTAssertEqual(timings.count, 11)
//        XCTAssertEqual(groups.count, 1)
//    }
//
//    func testTimingsCanBeGroupChildren() {
//        let group: Group = Group.MR_createEntity()
//        group.name = "Group1"
//
//        let timer: Profile = Profile.MR_createEntity()
//        timer.name = "Timer1"
//
//        timer.parent = group
//
//        if let ct = group.childTimings {
//            XCTAssert(ct.containsObject(timer))
//        } else {
//            XCTFail("Expected a set of children in the group")
//        }
//
//        let timings: NSArray = Profile.MR_findAll()
//        let groups: NSArray = Group.MR_findAll()
//
//        XCTAssert(timings.count == 1)
//        XCTAssert(groups.count == 1)
//    }

}
