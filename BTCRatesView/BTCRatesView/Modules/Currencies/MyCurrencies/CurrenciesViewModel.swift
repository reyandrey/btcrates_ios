//
//  CurrenciesViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class CurrenciesViewModel {
    //MARK: - Initial Values, Dependencies
    
    let profileManager: ProfileManager
    
    //MARK: - Lifeycle
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((CurrenciesViewModel) -> Void)?
    
    private(set) var isUpdating: Bool = false { didSet { self.didUpdate?(self) } }
    
    //MARK: - Properties
   
    // ViewModels, CellRepresentable
    var currencies: [Currency] = []
    
    
    //MARK: - Actions
    func reloadData() {
        self.isUpdating = true
        currencies = profileManager.getCurrencies()
        self.isUpdating = false
    }
    
    func removeCurrency(at indexPath: IndexPath) {
        currencies.remove(at: indexPath.row)
        profileManager.setCurrencies(currencies)
    }
 
}
