//
//  SwiftDataManager.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData
import os

class SwiftDataManager {
    
    //MARK: - Singleton
    
    static let sharedManager = SwiftDataManager()
    
    //MARK: - Properties
    
    var config: SwiftDataConfiguration?
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    var modelName: String {
        get {
            if let v = config?.databaseFileName {
                return v
            }
            
            return "SwiftData"
        }
    }
    
    var libraryDirectory: URL {
         
        guard let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last else {
            os_log("[SwiftDataManager][databaseDirectory] databaseDirectory")
            fatalError("Unable to obtain database directory URL")
        }
        
        return URL(fileURLWithPath: path)
    }
    
    var databaseUrl: URL {
        return libraryDirectory.appendingPathComponent(modelName + ".sqlite")
    }
    
    var hasExistingDatabase: Bool {
        let v = FileManager.default.fileExists(atPath: databaseUrl.absoluteString)
        return v
    }
    
    //MARK: - Initialization
    
    required init() {
        // init stuff
    }
    
    class func initialize(config: SwiftDataConfiguration) {
        sharedManager.config = config
    }
    
    //MARK: - CoreData Stack Setup
    
    lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        
        let storeDescription = NSPersistentStoreDescription(url: databaseUrl)
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }

        return container
    }()
    
    //MARK: Multiple MOCs
    
    func registerBackgroundContext() -> NSManagedObjectContext {
        return storeContainer.newBackgroundContext()
    }
    
    //MARK: MISC
    
    func logInfo(method: String, message: String) {
        NSLog("[SwiftDataManager][\(method)] Info: \(message)")
    }
    
    func logError(method: String, message: String) {
        NSLog("[SwiftDataManager][\(method)] Error: \(message)")
    }
}
