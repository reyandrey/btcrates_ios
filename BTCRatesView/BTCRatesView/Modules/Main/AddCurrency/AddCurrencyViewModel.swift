//
//  AddCurrencyViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class AddCurrencyViewModel: ViewModel {
  
  let profileManager: ProfileManager
  
  //MARK: - Lifeycle
  
  init(profileManager: ProfileManager) {
    self.profileManager = profileManager
  }
  
  var onError: ((String) -> Void)?
  var onUpdating: ((Bool) -> Void)?

  //MARK: - Properties
  
  var currencies: [CurrencyModel] {
    return profileManager.unselectedCurrencies
  }
  var filteredCurrencies: [CurrencyModel] = []
  
  
  var title: String {
    return "Supported currencies (\(currencies.count))"
  }
  
  //MARK: - Actions
  func reloadData() {
    onUpdating?(false)
  }
  
  func filterContent(for searchText: String) {
    filteredCurrencies = currencies.filter( { $0.code.lowercased().contains(searchText.lowercased()) } )
  }
  
}
