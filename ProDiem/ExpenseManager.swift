//
//  ExpenseManager.swift
//  ProDiem
//
//  Created by Henry Jordan III on 6/9/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//

import UIKit
import CoreData

class ExpenseManager {
    
    static let sharedManager: ExpenseManager = {
        let manager = ExpenseManager()
        return manager
    }()


    func createNewExpense(_ name: String?, amount: Double?, date: Date?, trip: Trip?) -> Expense {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        let newExpense = Expense(entity: entityDescription!, insertInto: context)
        
        newExpense.name = name
        newExpense.amount = amount as NSNumber?
        newExpense.date = date
        newExpense.trip = trip
        
        do {
            try newExpense.managedObjectContext?.save()
            print(newExpense)
        } catch {
            print(error)
        }
        
        return newExpense
    }

    func fetchAllTripExpenses(_ currentTrip: Trip) -> [Expense] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        var results: [Expense] = []
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        
        // criteria
        let predicate = NSPredicate(format: "trip = %@", currentTrip)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = predicate
        
        do {
            results = try context.fetch(fetchRequest) as! [Expense]            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return results
    }

}

