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
    private var presentingIndexPath: IndexPath?
    
    let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.allowsFloats = false
        return currencyFormatter
    }()
    
    // Events
    var didUpdate: ((RateItemViewModel) -> Void)?
    
    init(_ currency: Currency) {
        self.currency = currency
    }
   
    func reloadData() {
        apiClient.getCurrentPrice(code: currency.code) { [weak self] bpiRealTimeObject in
            guard let self = self else { return }
            self.bpiRealTime = bpiRealTimeObject
            DispatchQueue.main.async { self.didUpdate?(self) }
        }
    }
    
    
}

extension RateItemViewModel {
    
    var code: String { currency.code }
    var country: String { currency.country }
    var rate: String {
        if let r = bpiRealTime?.rateDouble { return currencyFormatter.string(from: NSNumber(value: r)) ?? "" }
        else { return "loading.." }
    }
    
}

extension RateItemViewModel: CellRepresentable {
    static func registerCell(in tableView: UITableView) {}
    
    func dequeueCell(in tableView: UITableView, at indexPath: IndexPath) -> CellIdentifiable {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RateCell.reuseId, for: indexPath) as? RateCell else { fatalError() }
        cell.indexPath = indexPath
        presentingIndexPath = indexPath
        cell.setup(with: self)
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
