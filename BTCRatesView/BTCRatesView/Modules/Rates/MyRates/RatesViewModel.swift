//
//  CurrenciesViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class RatesViewModel {
    //MARK: - Initial Values, Dependencies
    
    let profileManager: ProfileManager
    
    //MARK: - Lifeycle
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((RatesViewModel) -> Void)?
    
    private(set) var isUpdating: Bool = false { didSet { self.didUpdate?(self) } }
    
    //MARK: - Properties
    var lastUpdated: Date?
    var rateItems: [RateItemViewModel] = []
    var filteredrateItems: [RateItemViewModel] = []
    
    var title: String {
        return isUpdating ? "Loading.." : "Rates"
    }
    
    //MARK: - Actions
    func reloadData() {
        self.isUpdating = true
        rateItems = profileManager.userCurrencies.map { getCurrencyItemViewModel($0) }
        self.lastUpdated = Date()
        self.isUpdating = false
    }
    
    func getCurrencyItemViewModel(_ currency: Currency) -> RateItemViewModel {
        return RateItemViewModel(currency)
    }
    
    func removeCurrency(at indexPath: IndexPath) {
        rateItems.remove(at: indexPath.row)
        profileManager.userCurrencies = rateItems.map { $0.currency }
    }
    
    func reorderCurrencies(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.rateItems[sourceIndexPath.row]
        rateItems.remove(at: sourceIndexPath.row)
        rateItems.insert(movedObject, at: destinationIndexPath.row)
        profileManager.userCurrencies = rateItems.map { $0.currency

        }
    }
    
    func filterContent(for searchText: String) {
        filteredrateItems = rateItems.filter( { $0.code.lowercased().contains(searchText.lowercased()) } )
    }
 
}
