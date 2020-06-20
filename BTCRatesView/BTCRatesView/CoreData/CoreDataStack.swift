//
//  CoreDataStack.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    //MARK: Constants
    
    let kBundleId = "com.andreyfokin.BTCRatesView"
    let kModelName = "Model"
    
    //MARK: Static Properties
    
    public static let shared = CoreDataStack()
    
    //MARK: Public Properties
    
    public private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writeContext
        return context
    }()
    
    //MARK: Private Properties
    
    private lazy var model: NSManagedObjectModel = {
        let bundle = Bundle(identifier: kBundleId)!
        let url = bundle.url(forResource: kModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(kModelName + ".sqlite")
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = url
        description.type = NSSQLiteStoreType
        description.shouldAddStoreAsynchronously = false
        psc.addPersistentStore(with: description) { description, error in
            if let error = error {
                assertionFailure("Failed to add persistent store: \(error)")
            }
        }
        return psc
    }()
    
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.psc
        return context
    }()
    
    //MARK: Constructors
    
    private init() {}
    
}

//MARK: Public Methods
public extension CoreDataStack {
    
    func getPrivateContext(automaticallyMergesChangesFromParent: Bool) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = automaticallyMergesChangesFromParent
        return context
    }
    
    func saveChanges() {
        saveContext(mainContext) {
            self.saveContext(self.writeContext)
        }
    }
    
}

//MARK: Private Methods
private extension CoreDataStack {
    
    func saveContext(_ context: NSManagedObjectContext, onCompletion completionHandler: (() -> ())? = nil) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                    completionHandler?()
                } catch {
                    print("Failed to save context \(context): \(error)")
                }
            }
        }
    }
    
}
