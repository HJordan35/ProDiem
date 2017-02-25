//
//  FullResReceipt+CoreDataProperties.swift
//  ProDiem
//
//  Created by Henry Jordan III on 2/25/17.
//  Copyright © 2017 Henry ACN. All rights reserved.
//

import Foundation
import CoreData


extension FullResReceipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullResReceipt> {
        return NSFetchRequest<FullResReceipt>(entityName: "FullResReceipt");
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var expense: Expense?

}
