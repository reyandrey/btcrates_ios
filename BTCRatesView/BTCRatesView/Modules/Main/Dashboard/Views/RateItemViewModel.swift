//
//  CurrencyItemViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

class RateItemViewModel {
  let currency: CurrencyModel
  
  var cellIndexPath: IndexPath?
  private let apiClient = CoinDeskClient()
  private var ratesHistory: [BPIHistory.Rate] = [] {
    didSet { onUpdating?(self) }
  }
  
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
  
  // Events
  var onUpdating: ((RateItemViewModel) -> ())?
  
  init(_ currency: CurrencyModel) {
    self.currency = currency
  }
  
  func reloadData() {
    apiClient.getWeekHistory(currency: currency.code) { history in
      guard let history = history else { return }
      DispatchQueue.main.async {
        self.ratesHistory = history
      }
    }
  }
}

extension RateItemViewModel {
  
  var code: String {
    return "BTC/" + currency.code
  }
  
  var country: String {
    return currency.country
  }
  
  var rate: (today: String, history: [Double])? {
    guard let today = ratesHistory.last?.value,
          let todayString = currencyFormatter.string(from: NSNumber(value: today))
          else { return nil }
    
    let history = ratesHistory.map { $0.value }
    return (today: todayString, history: history)
  }
  
  var diff: (percentString: String, color: UIColor) {
    guard let yesterday = ratesHistory.dropLast().last?.value,
          let today = ratesHistory.last?.value
          else { return (percentString: "-", color: .lightGray) }
    
    let percent = (today-yesterday)/yesterday
    return (percentString: percentFormatter.string(from: NSNumber(value: percent)) ?? "-", color: percent >= 0 ? .systemGreen : .systemRed)
  }
}

extension RateItemViewModel: CellRepresentable {
  static func registerCell(in tableView: UITableView) {}
  
  func dequeueCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RateCell.reuseId, for: indexPath) as? RateCell else { fatalError() }
    cell.indexPath = indexPath
    cellIndexPath = indexPath
    cell.set(self)
    return cell
  }
  
}
