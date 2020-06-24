//
//  ManagedSyncable.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedSyncable: class {
  associatedtype IDType: Equatable
  
  var id: IDType { get }
  static var idAttributeName: String { get }
  func update(with object: Self)
  func delete()
}

public extension ManagedSyncable {
  
  static var idAttributeName: String { return "id" }
  
}

public extension ManagedSyncable where Self: NSManagedObject {
  
  //MARK: Static Methods
  
  static func getSyncFetchRequest(for objects: [Self]) -> NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: Self.entity().name!)
    request.predicate = NSPredicate(format: "\(idAttributeName) IN %@", objects.map { $0.id } )
    return request
  }
  
  static func getDropFetchRequest(for objects: [Self]) -> NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: Self.entity().name!)
    request.predicate = NSPredicate(format: "NOT (\(idAttributeName) IN %@)", objects.map { $0.id } )
    return request
  }
  
  static func syncObjects(_ objects: [Self], in context: NSManagedObjectContext) throws {
    let fetchRequest = Self.getSyncFetchRequest(for: objects)
    let originalObjects = (try context.fetch(fetchRequest)).filter { !objects.contains($0) }
    originalObjects.forEach { original in
      if let new = objects.first(where: { original.id == $0.id }) {
        original.update(with: new)
        context.delete(new)
      }
    }
  }
  
  static func dropMissing(_ objects: [Self], in context: NSManagedObjectContext) throws {
    let fetchRequest = getDropFetchRequest(for: objects)
    let removedObjects = try context.fetch(fetchRequest)
    removedObjects.forEach { $0.delete() }
  }
  
  //MARK: Instance Methods
  
  func delete() {
    managedObjectContext?.delete(self)
  }
}


/**
 func syncObjects<ObjectType: NSManagedObject&ManagedSyncable>(_ objects: [ObjectType], dropMissing: Bool = true) {
 syncContext.perform {
 do {
 if dropMissing {
 try ObjectType.dropMissing(objects, in: self.syncContext)
 }
 try ObjectType.syncObjects(objects, in: self.syncContext)
 } catch {
 print("Failed to sync objects of type: " + String(describing: ObjectType.self))
 }
 }
 }
 
 func saveData(onCompletion completionHandler: @escaping ()->()) {
 syncContext.perform {
 if self.syncContext.hasChanges {
 do {
 try self.syncContext.save()
 CoreDataStack.shared.saveChanges()
 completionHandler()
 } catch {
 print("Failed to save context: \(error)")
 completionHandler()
 }
 } else {
 completionHandler()
 }
 }
 }
 */
