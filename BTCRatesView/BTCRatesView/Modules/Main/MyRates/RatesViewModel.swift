//
//  CurrenciesViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class RatesViewModel: ViewModel {
  let profileManager: ProfileManager
  
  let df: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .medium
    df.locale = .current
    return df
  }()
  //MARK: - Lifeycle
  
  init(profileManager: ProfileManager) {
    self.profileManager = profileManager
    
    profileManager.onSelectedUpdate = { [weak self] updates in
      guard let self = self else { return }
      updates.deleted.forEach { self.rateItems.remove(at: $0) }
      updates.inserted.forEach {
        let vm = RateItemViewModel(profileManager.selectedCurrencies[$0])
        self.rateItems.insert(vm, at: $0)
      }
      self.onUpdateSelected?(updates)
    }
    
  }
  
  var onError: ((String) -> Void)?
  var onUpdating: ((Bool) -> Void)?
  var onUpdateSelected: ((ProfileManager.Updates) -> Void)? = nil
  
  //MARK: - Properties
  
  var lastUpdated: Date?
  var rateItems: [RateItemViewModel] = []
  
  var title: String {
    return df.string(from: Date())
  }
  
  //MARK: - Actions
  
  func reloadData() {
    rateItems = profileManager.selectedCurrencies.map { RateItemViewModel($0) }
    onUpdating?(false)
  }
  
  func remove(at index: Int) {
    rateItems[index].currency.isSelected = false
  }
  
}
