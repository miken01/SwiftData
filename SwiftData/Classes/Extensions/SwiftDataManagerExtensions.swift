    //
//  SwiftDataManager+NSManagedObjectContext.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData
import os

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
        
        guard managedObjectContext.hasChanges else { return }
        
        do {
            try managedObjectContext.save()
        } catch let nserror as NSError {
            os_log("[SwiftDataManager][saveManagedObjectContext] Unable to save MOC")
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveManagedObjectContextAndWait() {
        
        guard managedObjectContext.hasChanges else { return }

        managedObjectContext.performAndWait {
            
            do {
              try managedObjectContext.save()
                
            } catch let nserror as NSError {
                os_log("[SwiftDataManager][saveManagedObjectContextAndWait] Unable to save MOC")
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(managedObjectContext moc: NSManagedObjectContext) {
        
        guard moc.hasChanges else { return }
        
        do {
            try moc.save()
        } catch let nserror as NSError {
            os_log("[SwiftDataManager][save:managedObjectContext] Unable to save MOC")
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func save(managedObjectContextAndWait moc: NSManagedObjectContext) {
        
        guard moc.hasChanges else { return }

        moc.performAndWait {
            
            do {
              try moc.save()
                
            } catch let nserror as NSError {
                os_log("[SwiftDataManager][save:managedObjectContext] Unable to save MOC")
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
}
