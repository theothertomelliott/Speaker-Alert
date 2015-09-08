//
//  Speech+CoreDataProperties.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/7/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Speech {

    @NSManaged var title: String?
    @NSManaged var time: NSNumber?
    @NSManaged var comments: String?
    @NSManaged var profile: Profile?

}
