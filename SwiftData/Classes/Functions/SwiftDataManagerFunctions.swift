//
//  SwiftDataManagerFunctions.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData

public func SwiftDataInitialize(config: SwiftDataConfiguration) {
    SwiftDataManager.initialize(config)
}

public func SDExecuteFetchRequest(fetchRequest: NSFetchRequest) -> AnyObject? {
    return SwiftDataManager.sharedManager.executeFetchRequest(fetchRequest)
}

public func SDSaveManagedObjectContext() {
    return SwiftDataManager.sharedManager.saveManagedObjectContext()
}

public func SDDeleteObject(object: NSManagedObject) {
    SwiftDataManager.sharedManager.deleteObject(object);
}