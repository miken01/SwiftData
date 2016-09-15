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
    
    func executeFetchRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> AnyObject? {
        
        do {
            
            let results = try self.managedObjectContext.fetch(fetchRequest)
            return results as AnyObject?
        
        } catch let e as NSError {
            self.logError(method: "executeFetchRequest", message: "\(e)")
            return nil
        }
    }
    
    func saveManagedObjectContext() {
        
        do {
            try self.managedObjectContext.save()
            
        } catch let e as NSError {
            self.logError(method: "executeFetchRequest", message: "\(e)")
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
}
