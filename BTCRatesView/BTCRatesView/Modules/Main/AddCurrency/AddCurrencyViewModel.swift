//
//  AddCurrencyViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class AddCurrencyViewModel: NSObject {
  //MARK: - Initial Values, Dependencies
  private lazy var currenciesFRC: NSFetchedResultsController<CurrencyModel> = {
    let sortDescriptor = NSSortDescriptor(key: "code", ascending: false)
    let fetchRequest = NSFetchRequest<CurrencyModel>(entityName: "CurrencyModel")
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.predicate = NSPredicate(format: "isSelected == %@", NSNumber(value: false))
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    return frc
  }()
  
  var didError: ((Error) -> Void)?
  var didUpdate: ((AddCurrencyViewModel) -> Void)?
  
  private(set) var isUpdating: Bool = false { didSet { self.didUpdate?(self) } }
  
  //MARK: - Properties
  
  var currencies: [CurrencyModel] = []
  var filteredCurrencies: [CurrencyModel] = []
  
  
  var title: String {
    return isUpdating ? "Loading.." : "Add Currency"
  }
  
  //MARK: - Actions
  func reloadData() {
    do {
      try currenciesFRC.performFetch()
      currencies = currenciesFRC.fetchedObjects ?? []
    } catch {
      print("AddCurrencyViewModel: \(#function) Error: \(error)")
    }
    didUpdate?(self)
  }
  
  func filterContent(for searchText: String) {
    filteredCurrencies = currencies.filter( { $0.code.lowercased().contains(searchText.lowercased()) } )
  }
  
}

extension AddCurrencyViewModel: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    reloadData()
  }
}
