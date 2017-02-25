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
    
    let convertQueue = DispatchQueue(label: "com.prodiem.convertqueue")
    let saveQueue = DispatchQueue(label: "com.prodiem.savequeue")

    
    static let sharedManager: ExpenseManager = {
        let manager = ExpenseManager()
        return manager
    }()


    func createNewExpense(_ name: String, amount: Double, date: Date, trip: Trip, receipt: UIImage) -> Expense {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let expenseDescription = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        let receiptDescription = NSEntityDescription.entity(forEntityName: "FullResReceipt", in: context)
        
        let newExpense = Expense(entity: expenseDescription!, insertInto: context)
        let newReceipt = FullResReceipt(entity: receiptDescription!, insertInto: context)
        
        let imageData = UIImageJPEGRepresentation(receipt, 1) as NSData!
        
        newReceipt.imageData = imageData
        
        newExpense.name = name
        newExpense.amount = amount as NSNumber?
        newExpense.date = date as NSDate?
        newExpense.trip = trip
        newExpense.receipt = newReceipt
        
        do {
            try newReceipt.managedObjectContext?.save()
            do {
                try newExpense.managedObjectContext?.save()
                print(newExpense)
            } catch {
                print(error)
            }
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

