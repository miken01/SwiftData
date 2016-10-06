//
//  NSManagedObjectExtensions.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    public class func entityName() -> String? {
        assertionFailure("NSManagedObject.entityName() must be implemented")
        return nil
    }
    
    public class func newEntity() -> AnyObject? {
        
        if let name = self.entityName() {
            let entity = NSEntityDescription.insertNewObject(forEntityName: name, into: SwiftDataManager.sharedManager.managedObjectContext)
            return entity
        }
        
        return nil
    }
}
