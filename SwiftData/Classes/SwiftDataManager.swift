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
    
    fileprivate let saveQueue = DispatchQueue(label: "SwiftDataManager.saveQueue")
    fileprivate let saveAndWaitQueue = DispatchQueue(label: "SwiftDataManager.saveAndWaitQueue")
    
    private var modelName: String {
        get {
            if let v = config?.databaseFileName {
                return v
            }
            
            return "SwiftData"
        }
    }
    
    private var libraryDirectory: URL {
         
        guard let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last else {
            os_log("[SwiftDataManager][databaseDirectory] databaseDirectory")
            fatalError("Unable to obtain database directory URL")
        }
        
        return URL(fileURLWithPath: path)
    }
    
    private var databaseUrl: URL {
        
        guard let appGroupName = config?.appGroupName else {
            return libraryDirectory.appendingPathComponent(modelName + ".sqlite")
        }
        
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) else {
            fatalError("Unable to get AppGroup URL")
        }
        
        return url.appendingPathComponent(modelName + ".sqlite")
    }
    
    //MARK: - Initialization
    
    required init() {
    }
    
    class func initialize(config: SwiftDataConfiguration) {
        sharedManager.config = config
    }
    
    //MARK: - CoreData Stack Setup
    
    lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        
        let storeDescription = NSPersistentStoreDescription(url: databaseUrl)
        container.persistentStoreDescriptions = [storeDescription]
        
        weak var _container = container
        
        container.loadPersistentStores {(storeDescription, error) in
          
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            } else {
                _container?.viewContext.automaticallyMergesChangesFromParent = true
                _container?.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            }
        }

        return container
    }()
    
    //MARK: Multiple MOCs
    
    func registerBackgroundContext() -> NSManagedObjectContext {
        let ctx = storeContainer.newBackgroundContext()
        ctx.automaticallyMergesChangesFromParent = true
        return ctx
    }
    
    //MARK: MISC
    
    func logInfo(method: String, message: String) {
        NSLog("[SwiftDataManager][\(method)] Info: \(message)")
    }
    
    func logError(method: String, message: String) {
        NSLog("[SwiftDataManager][\(method)] Error: \(message)")
    }
}

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
        
        saveQueue.async {[weak self] in
            
            guard let moc = self?.managedObjectContext else {
                return
            }
            
            guard moc.hasChanges else { return }
            
            print("[SwiftDataManager][saveManagedObjectContext] Start save")
            
            do {
                print("[SwiftDataManager][saveManagedObjectContext] Try save")
                try moc.save()
                print("[SwiftDataManager][saveManagedObjectContext] Save complete")
                
            } catch _ as NSError {
                os_log("[SwiftDataManager][saveManagedObjectContext] Unable to save MOC")
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveManagedObjectContextAndWait() {
        
        saveAndWaitQueue.sync {[weak self] in
            
            guard let moc = self?.managedObjectContext else {
                return
            }
            
            guard moc.hasChanges else { return }

            print("[SwiftDataManager][saveManagedObjectContextAndWait] Start save")
            
            moc.performAndWait {
                
                do {
                    print("[SwiftDataManager][saveManagedObjectContextAndWait] Try save")
                    try moc.save()
                    print("[SwiftDataManager][saveManagedObjectContextAndWait] Save complete")
                    
                } catch _ as NSError {
                    os_log("[SwiftDataManager][saveManagedObjectContextAndWait] Unable to save MOC")
//                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func save(managedObjectContext moc: NSManagedObjectContext) {
        
        saveQueue.async {
        
            print("[SwiftDataManager][save:managedObjectContext] Start save")
            
            guard moc.hasChanges else { return }
            
            do {
                print("[SwiftDataManager][save:managedObjectContext] try save")
                try moc.save()
                print("[SwiftDataManager][save:managedObjectContext] Save complete")
                
            } catch _ as NSError {
                os_log("[SwiftDataManager][save:managedObjectContext] Unable to save MOC")
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(managedObjectContextAndWait moc: NSManagedObjectContext) {
        
        saveAndWaitQueue.sync {
         
            guard moc.hasChanges else { return }
            
            print("[SwiftDataManager][save:managedObjectContext] Start save")
            
            moc.performAndWait {

                do {
                    print("[SwiftDataManager][save:managedObjectContextAndWait] try save")
                  try moc.save()
                    print("[SwiftDataManager][save:managedObjectContextAndWait] Save complete")

                } catch _ as NSError {
                    os_log("[SwiftDataManager][save:managedObjectContextAndWait] Unable to save MOC")
//                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
}
