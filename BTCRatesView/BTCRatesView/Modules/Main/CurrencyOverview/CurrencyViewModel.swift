//
//  CurrencyViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 01.07.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class CurrencyViewModel: ViewModel {
  enum Sections: Int, CaseIterable {
    case periodSelector
    case historicalData
  }
  //MARK: - Lifeycle
  
  init() {
  }
  
  var onError: ((String) -> Void)?
  var onUpdating: ((Bool) -> Void)?

  //MARK: - Properties
  
  //MARK: - Actions
  func reloadData() {
    onUpdating?(true)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      self.onUpdating?(false)
    }
  }
  
}
