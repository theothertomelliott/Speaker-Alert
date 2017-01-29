//
//  Speech+CoreDataProperties.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/27/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Speech {

    @NSManaged var comments: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var title: String?
    @NSManaged var startTime: Date?
    @NSManaged var profile: Profile?

}
