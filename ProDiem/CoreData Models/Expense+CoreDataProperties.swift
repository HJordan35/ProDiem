//
//  Expense+CoreDataProperties.swift
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

extension Expense {

    @NSManaged var name: String?
    @NSManaged var amount: NSNumber?
    @NSManaged var date: Date?
    @NSManaged var trip: Trip?

}
