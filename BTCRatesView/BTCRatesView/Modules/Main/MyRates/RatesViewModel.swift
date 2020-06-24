//
//  CurrenciesViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class RatesViewModel: NSObject, ViewModel {
    let profileManager: ProfileManager
    
    private lazy var currenciesFRC: NSFetchedResultsController<CurrencyModel> = {
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: false)
        let fetchRequest = NSFetchRequest<CurrencyModel>(entityName: "CurrencyModel")
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "isSelected == %@", NSNumber(value: true))
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    //MARK: - Lifeycle
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    var onError: ((String) -> Void)?
    var onUpdating: ((Bool) -> Void)?
    
    //MARK: - Properties
    
    var lastUpdated: Date?
    var rateItems: [RateItemViewModel] = []
    
    var title: String {
        return "Dashboard"
    }
    
    //MARK: - Actions
    
    func reloadData() {
        onUpdating?(true)
        do {
            try currenciesFRC.performFetch()
            let currencies = currenciesFRC.fetchedObjects ?? []
            rateItems = currencies.map { RateItemViewModel($0) }
        } catch {
            print("RatesViewModel: \(#function) Error: \(error)")
        }
        onUpdating?(false)
    }
    
//    func removeCurrency(at indexPath: IndexPath) {
//        rateItems.remove(at: indexPath.row)
//        profileManager.userCurrencies = rateItems.map { $0.currency }
//    }
//
//    func reorderCurrencies(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.rateItems[sourceIndexPath.row]
//        rateItems.remove(at: sourceIndexPath.row)
//        rateItems.insert(movedObject, at: destinationIndexPath.row)
//        profileManager.userCurrencies = rateItems.map { $0.currency
//
//        }
//    }
    
}

extension RatesViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reloadData()
    }
}
