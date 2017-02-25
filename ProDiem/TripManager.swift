//
//  TripManager.swift
//  ProDiem
//
//  Created by Henry Jordan III on 5/16/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//

import UIKit
import CoreData

class TripManager {
    
    static let sharedManager: TripManager = {
        let manager = TripManager()
        
        return manager
    }()
    
    func createNewTrip(_ name: String?, dailyPerDiem: Double?, totalPerDiem: Double?, tripStart: Date?, tripEnd: Date?) -> Trip {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Trip", in: context)
        let newTrip = Trip(entity: entityDescription!, insertInto: context)
        
        
        newTrip.name = name
        newTrip.dailyPerDiem = dailyPerDiem as NSNumber?
        newTrip.tripTotalPerDiem = totalPerDiem as NSNumber?
        newTrip.startDate = tripStart as NSDate?
        newTrip.endDate = tripEnd as NSDate?
        
        do {
            try newTrip.managedObjectContext?.save()
        } catch {
            print(error)
        }
        
        return newTrip
    }
    
    func fetchAllTrips() -> [Trip] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        var results: [Trip] = []

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Trip", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            results = try context.fetch(fetchRequest) as! [Trip]
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return results
    }
    
    func deleteTrip(_ tripForDelete: Trip) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        var result: NSPersistentStoreResult
        
        // Initialize Fetch Request for Deletes
        let deleteRequest = NSBatchDeleteRequest(objectIDs: [tripForDelete.objectID])
        
        do {
            result = try context.execute(deleteRequest)
            print(result)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
}
