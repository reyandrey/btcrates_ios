//
//  AddCurrencyViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class AddCurrencyViewModel {
    //MARK: - Initial Values, Dependencies
    
    let api = BPIService<BTEnvironment>()
    
    //MARK: - Lifeycle
    init() {}
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((AddCurrencyViewModel) -> Void)?
    
    private(set) var isUpdating: Bool = false { didSet { self.didUpdate?(self) } }
    
    //MARK: - Properties
   
    var currencies: [Currency] = []
    var filteredCurrencies: [Currency] = []
    
    
    var title: String {
        return isUpdating ? "Loading.." : "Add Currency"
    }
    
    //MARK: - Actions
    func reloadData() {
        self.isUpdating = true
        api.getSupportedCurrencies { [weak self] result in
            self?.currencies = result ?? []
            self?.isUpdating = false
        }
    }
    
    func filterContent(for searchText: String) {
        filteredCurrencies = currencies.filter( { $0.code.lowercased().contains(searchText.lowercased()) } )
    }
 
}
