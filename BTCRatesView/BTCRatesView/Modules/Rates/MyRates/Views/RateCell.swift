//
//  CurrencyCell.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell, CellIdentifiable {
    static var reuseId: String { return String(describing: Self.self) }
    var indexPath: IndexPath? = nil
    
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var ratesLabel: UILabel!
    @IBOutlet private weak var chartView: CompactChartView!
    @IBOutlet private weak var diffView: UIView!
    @IBOutlet private weak var diffLabel: UILabel!

    func set(_ viewModel: RateItemViewModel) {
        guard viewModel.isPresenting(by: self) else { return }
        codeLabel.text = viewModel.code
        countryLabel.text = viewModel.country
        ratesLabel.text = viewModel.rate ?? "🤔"
        chartView.set(viewModel.history)
        diffLabel.text = viewModel.diffPercenString
        diffView.backgroundColor = viewModel.diffColor
        
        viewModel.onUpdating = { [weak self] (isUpdating) in
            self?.setActivityIndication(isUpdating)
            self?.set(viewModel)
        }
        
    }
}

private extension RateCell {
    func setActivityIndication(_ active: Bool) {
        UIView.animate(withDuration: active ? 0 : 0.33) {
            self.chartView.alpha = active ? 0:1
            self.diffView.alpha = active ? 0:1
        }
    }
}
