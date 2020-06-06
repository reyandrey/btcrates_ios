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
    
    //MARK: - Lifeycle
    init() {}
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((AddCurrencyViewModel) -> Void)?
    
    private(set) var isUpdating: Bool = false { didSet { self.didUpdate?(self) } }
    
    //MARK: - Properties
   
    // ViewModels, CellRepresentable
    
    
    //MARK: - Actions
    func reloadData() {
        self.isUpdating = true
    /*  api.FetchData()
        Success:
            init ViewModels for fetched data
            self.isUpdating = false
         Failure:
            self.didError?(error)
            self.isUpdating = false */
    }
 
}
