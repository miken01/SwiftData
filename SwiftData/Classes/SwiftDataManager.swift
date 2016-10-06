//
//  SwiftDataManager.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData

class SwiftDataManager {
    
    //MARK: - Singleton
    
    static let sharedManager = SwiftDataManager()
    
    //MARK: - Properties
    
    var config: SwiftDataConfiguration?
    
    var managedObjectModel: NSManagedObjectModel { get { return self.getManagedObjectModel() } }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get { return self.getPersistentStoreCoordinator() } }
    var managedObjectContext: NSManagedObjectContext { get { return self.getManagedObjectContext() } }
    
    private var _managedObjectModel: NSManagedObjectModel?
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var _managedObjectContext: NSManagedObjectContext?
    
    //MARK: - Initialization
    
    required init() {
        // init stuff
    }
    
    class func initialize(config: SwiftDataConfiguration) {
        sharedManager.config = config
        let _ = sharedManager.getManagedObjectContext()
    }
    
    //MARK: - CoreData Stack Setup
    
    private func getManagedObjectModel() -> NSManagedObjectModel {
        
        if let mom = _managedObjectModel {
            return mom
        }
        
        _managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        return _managedObjectModel!
    }
    
    private func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        if let store = _persistentStoreCoordinator {
            return store
        }
        
        if let cfg = self.config {
            
            let storeUrl = SwiftDataUtilities.getApplicationLibraryDirectory()?.appendingPathComponent("\(cfg.databaseFileName).sqlite")
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            
            if let url = storeUrl {
                self.logInfo(method: "getPersistentStoreCoordinator", message: url.absoluteString)
            }
            
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            do {
                try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
            } catch {
                self.logError(method: "getPersistentStoreCoordinator", message: "Error loading persistent store coordinator")
            }
            
            return _persistentStoreCoordinator!
        
        } else {
            assertionFailure("No SwiftDataConfiguration found")
            return _persistentStoreCoordinator! // this will crash, but the assert above should say why
        }
    }
    
    private func getManagedObjectContext() -> NSManagedObjectContext {
        
        if let moc = _managedObjectContext {
            return moc
        }
        
        _managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        _managedObjectContext?.persistentStoreCoordinator = self.persistentStoreCoordinator
        _managedObjectContext?.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return _managedObjectContext!
    }
    
    //MARK: MISC
    
    func logInfo(method: String, message: String) {
        NSLog("[SwiftDataManager][\(method)] Info: \(message)")
    }
    
    func logError(method: String, message: String) {
        NSLog("[SwiftDataManager][\(method)] Error: \(message)")
    }
}
