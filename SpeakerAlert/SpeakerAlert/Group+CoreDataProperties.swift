//
//  Group+CoreDataProperties.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/4/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Group {

    @NSManaged var name: String?
    @NSManaged var childTimings: NSSet?

}
