//
//  Expense+CoreDataProperties.swift
//  ProDiem
//
//  Created by Henry Jordan III on 2/25/17.
//  Copyright © 2017 Henry ACN. All rights reserved.
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense");
    }

    @NSManaged public var amount: NSNumber?
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var trip: Trip?
    @NSManaged public var receipt: FullResReceipt?

}
