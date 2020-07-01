//
//  CurrencyViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 01.07.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class CurrencyViewModel: ViewModel {
  let currency: CurrencyModel
  
  init(_ currency: CurrencyModel) {
    self.currency = currency
  }
  
  var onError: ((String) -> Void)?
  var onUpdating: ((Bool) -> Void)?
  var onChangePeriod: (() -> Void)?

  private let currencyFormatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.usesGroupingSeparator = true
    fmt.numberStyle = .currency
    fmt.allowsFloats = true
    fmt.currencySymbol = ""
    fmt.currencyGroupingSeparator = " "
    fmt.currencyDecimalSeparator = "."
    return fmt
  }()
  
  private let percentFormatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.numberStyle = .percent
    fmt.minimumFractionDigits = 2
    fmt.maximumFractionDigits = 2
    fmt.allowsFloats = true
    return fmt
  }()
  
  //MARK: - Properties
  
  var historyPeriod: [BPIHistory.Rate] = []
  
  
  private var history: [BPIHistory.Rate] = [] {
    didSet {
      historyPeriod = history.filter({ $0.date >= selectedPeriod.startDate })
    }
  }
  var selectedPeriod: BPIHistory.Period = .week {
    didSet {
      historyPeriod = history.filter({ $0.date >= selectedPeriod.startDate })
      onChangePeriod?()
    }
  }
  
  //MARK: - Actions
  
  func reloadData() {
    onUpdating?(true)
    CoinDeskClient().getYearHistory(currency: currency.code) { history in
      DispatchQueue.main.async {
        if let history = history { self.history = history }
        self.onUpdating?(false)
      }
    }
  }
}

extension CurrencyViewModel {
  var code: String {
    return currency.code
  }
  
  var country: String {
    return currency.country
  }
  
  var rate: (today: String, history: [Double])? {
    guard let today = history.last?.value,
          let todayString = currencyFormatter.string(from: NSNumber(value: today))
          else { return nil }
    
    let _history = history.map { $0.value }
    return (today: todayString, history: _history)
  }
  
  var diff: (percentString: String, color: UIColor) {
    guard let yesterday = history.dropLast().last?.value,
          let today = history.last?.value
          else { return (percentString: "-", color: .lightGray) }
    
    let percent = (today-yesterday)/yesterday
    return (percentString: percentFormatter.string(from: NSNumber(value: percent)) ?? "-", color: percent >= 0 ? .systemGreen : .systemRed)
  }
}

extension CurrencyViewModel {
  enum Sections: Int, CaseIterable {
    case historicalData
  }
}
