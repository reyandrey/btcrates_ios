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
    func didSelectCell()
    var presentingIndexPath: IndexPath? { get set }
}

class CurrencyItemViewModel: CellRepresentable {
    
    var presentingIndexPath: IndexPath?
    private let currency: Currency
    init(_ currency: Currency) {
        self.currency = currency
    }
   
    static func registerCell(in tableView: UITableView) {}
    
    func dequeueCell(in tableView: UITableView, at indexPath: IndexPath) -> CellIdentifiable {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseId, for: indexPath) as? CurrencyCell else { fatalError() }
        cell.indexPath = indexPath
        presentingIndexPath = indexPath
        cell.setup(with: self)
        return cell
    }
    
    func didSelectCell() {
        print(#function)
    }
}

extension CurrencyItemViewModel {
    
    var code: String { currency.code }
    var country: String { currency.country }
    
}
