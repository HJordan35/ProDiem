//
//  Trip+CoreDataProperties.swift
//  ProDiem
//
//  Created by Henry Jordan III on 2/25/17.
//  Copyright © 2017 Henry ACN. All rights reserved.
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip");
    }

    @NSManaged public var alertThreshold: NSNumber?
    @NSManaged public var dailyPerDiem: NSNumber?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var tripTotalPerDiem: NSNumber?
    @NSManaged public var tripUsedPerDiem: NSNumber?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension Trip {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}
