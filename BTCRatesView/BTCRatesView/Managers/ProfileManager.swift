//
//  ProfileManager.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class ProfileManager: NSObject {
  
  struct Updates {
    let inserted: [Int]
    let deleted: [Int]
  }
  
  static let shared: ProfileManager = ProfileManager()
  
  private override init() {
    super.init()
    do {
      try self.currencies.performFetch()
      updateFilteredData()
    } catch {
      print("[!] ProfileManager: failed to fetch currencies, error: \(error)")
    }
  }
  
  private lazy var currencies: NSFetchedResultsController<CurrencyModel> = {
    let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
    let fetchRequest = NSFetchRequest<CurrencyModel>(entityName: "CurrencyModel")
    fetchRequest.sortDescriptors = [sortDescriptor]
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    return frc
  }()
  
  var onSelectedUpdate: ((Updates) -> Void)? = nil
  var selectedCurrencies: [CurrencyModel] = [] {
    didSet {
      didUpdateSelected(oldValue)
    }
  }
  
  var onUnselectedUpdate: ((Updates) -> Void)? = nil
  var unselectedCurrencies: [CurrencyModel] = [] {
    didSet {
      didUpdateUnselected(oldValue)
    }
  }
  
}


// MARK: NSFetchedResultsControllerDelegate

extension ProfileManager: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    updateFilteredData()
    CoreDataStack.shared.saveChanges()
    print("ProfileManager: did \(type) \(anObject) at \(indexPath?.row ?? -1)")
  }
}

// MARK: Currency updating

private extension ProfileManager {
  private func updateFilteredData() {
    selectedCurrencies = (currencies.fetchedObjects ?? []).filter { $0.isSelected }
    unselectedCurrencies = (currencies.fetchedObjects ?? []).filter { !$0.isSelected }
  }
  
  private func didUpdateSelected(_ oldValue: [CurrencyModel]) {
    guard oldValue != selectedCurrencies else { return }
    var inserted = [Int]()
    var deleted = [Int]()
    
    selectedCurrencies.enumerated().forEach {
      if !oldValue.contains($0.element) { inserted.append($0.offset) }
    }
    oldValue.enumerated().forEach {
      if !selectedCurrencies.contains($0.element) { deleted.append($0.offset) }
    }
    onSelectedUpdate?(Updates(inserted: inserted, deleted: deleted))
  }
  
  private func didUpdateUnselected(_ oldValue: [CurrencyModel]) {
    guard oldValue != unselectedCurrencies else { return }
    var inserted = [Int]()
    var deleted = [Int]()
    
    unselectedCurrencies.enumerated().forEach {
      if !oldValue.contains($0.element) { inserted.append($0.offset) }
    }
    oldValue.enumerated().forEach {
      if !unselectedCurrencies.contains($0.element) { deleted.append($0.offset) }
    }
    onUnselectedUpdate?(Updates(inserted: inserted, deleted: deleted))
  }
}
