//
//  SwiftDataManager+NSManagedObjectContext.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData

extension SwiftDataManager {
    
    //MARK: - NSManagedObjectContext
    
    func executeFetchRequest(fetchRequest: NSFetchRequest) -> AnyObject? {
        
        do {
            
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            return results
        
        } catch let e as NSError {
            self.logError("executeFetchRequest", message: "\(e)")
            return nil
        }
    }
    
    func saveManagedObjectContext() {
        
        do {
            try self.managedObjectContext.save()
            
        } catch let e as NSError {
            self.logError("executeFetchRequest", message: "\(e)")
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        self.managedObjectContext.deleteObject(object)
    }
}