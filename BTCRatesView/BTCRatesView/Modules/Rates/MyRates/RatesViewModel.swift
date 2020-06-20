//
//  CurrenciesViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class RatesViewModel {
    let profileManager: ProfileManager
    
    //MARK: - Lifeycle
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    var onError: ((String) -> Void)?
    var onUpdating: ((Bool) -> Void)?
    
    //MARK: - Properties
    var lastUpdated: Date?
    var rateItems: [RateItemViewModel] = []
    var filteredrateItems: [RateItemViewModel] = []
    
    var title: String {
        return "BTC Rates"
    }
    
    //MARK: - Actions
    func reloadData() {
        onUpdating?(true)
        rateItems = profileManager.userCurrencies.map { RateItemViewModel($0) }
        self.lastUpdated = Date()
        onUpdating?(false)
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
