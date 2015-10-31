//
//  CoreDataStackManager.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/14/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "PropPHL.sqlite"

class CoreDataStackManager {
    
    // MARK: - Make Singleton
    
    static let sharedInstance = CoreDataStackManager()
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("PropPHL", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PropPHL.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // TODO: - Proper CoreData Error Handling
            // Currently dealt with by sending an error message from the PHLOPClient to be shown as an alert in the ViewController.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            //abort() // possibly not necessary anymore
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // TODO: - Proper CoreData Error Handling
                // Currently dealt with by sending an error message from the PHLOPClient to be shown as an alert in the ViewController.
                // managedObjectContext.rollback() hmmmm
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                //abort() // possibly not necessary anymore?
            }
        }
    }
    
}
