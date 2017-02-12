//
//  Trip+CoreDataProperties.swift
//  ProDiem
//
//  Created by Henry Jordan III on 6/9/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var alertThreshold: NSNumber?
    @NSManaged var dailyPerDiem: NSNumber?
    @NSManaged var endDate: Date?
    @NSManaged var name: String?
    @NSManaged var startDate: Date?
    @NSManaged var tripTotalPerDiem: NSNumber?
    @NSManaged var tripUsedPerDiem: NSNumber?
    @NSManaged var expenses: NSSet?

}
