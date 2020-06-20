//
//  CurrencyItemViewModel.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol CellIdentifiable {
    var indexPath: IndexPath? { get set }
}
protocol CellRepresentable {
    static func registerCell(in tableView: UITableView)
    func dequeueCell(in tableView: UITableView, at indexPath: IndexPath) -> CellIdentifiable
    func isPresenting(by cell: CellIdentifiable) -> Bool
    func didSelectCell()
}

class RateItemViewModel {
    
    let currency: Currency
    private let apiClient = CoinDeskClient()
    private var bpiRealTime: BPIRealTime?
    private var weeklyHistory: [Double]?
    private var presentingIndexPath: IndexPath?
    
    let currencyFormatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.usesGroupingSeparator = true
        fmt.numberStyle = .currency
        fmt.allowsFloats = true
        fmt.currencySymbol = ""
        fmt.currencyGroupingSeparator = " "
        fmt.currencyDecimalSeparator = "."
        return fmt
    }()
    
    let percentFormatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.numberStyle = .percent
        fmt.minimumFractionDigits = 2
        fmt.maximumFractionDigits = 2
        fmt.allowsFloats = true
        return fmt
    }()
    
    // Events
    var onUpdating: ((RateItemViewModel) -> ())?
    
    init(_ currency: Currency) {
        self.currency = currency
    }
   
    func reloadData() {
        apiClient.getCurrentPrice(code: currency.code) { [weak self] bpiRealTimeObject in
            guard let self = self else { return }
            self.bpiRealTime = bpiRealTimeObject
            self.weeklyHistory = [
                648, 654, 658, 659, 656, 652, 650,
                648, 650, 652, 654, 656, 650, 660
            ]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.onUpdating?(self) }
        }
    }
    
    
}

extension RateItemViewModel {
    
    var code: String { currency.code }
    var country: String { currency.country }
    var rate: String? {
        if let r = bpiRealTime?.rateDouble { return currencyFormatter.string(from: NSNumber(value: r)) ?? "" }
        else { return nil }
    }
    var history: [Double]? {
        return self.weeklyHistory
    }
    var diffPercent: Double? {
        guard let weeklyHistory = weeklyHistory else { return nil }
        guard let last = weeklyHistory.last, let secondLast = weeklyHistory.dropLast().last else { return nil }
        return (last-secondLast)/secondLast
    }
    var diffPercenString: String {
        guard let diffPercent = diffPercent else { return "-" }
        return percentFormatter.string(from: NSNumber(value: diffPercent)) ?? "-"
    }
    var diffColor: UIColor {
        return diffPercent == nil ? .lightGray : (diffPercent! >= 0 ? .systemGreen : .systemRed)
    }
}

extension RateItemViewModel: CellRepresentable {
    static func registerCell(in tableView: UITableView) {}
    
    func dequeueCell(in tableView: UITableView, at indexPath: IndexPath) -> CellIdentifiable {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RateCell.reuseId, for: indexPath) as? RateCell else { fatalError() }
        cell.indexPath = indexPath
        presentingIndexPath = indexPath
        cell.set(self)
        reloadData()
        return cell
    }
    
    func isPresenting(by cell: CellIdentifiable) -> Bool {
        guard let presentingIndexPath = presentingIndexPath, let cellIndexPath = cell.indexPath else { return false }
        return presentingIndexPath == cellIndexPath
    }
    
    func didSelectCell() {
        print(#function)
    }
}
