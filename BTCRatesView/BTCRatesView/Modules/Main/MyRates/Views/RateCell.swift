//
//  CurrencyCell.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell, CellIdentifiable, CellInstantiable {
    
    var indexPath: IndexPath? = nil
    
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var ratesLabel: UILabel!
    @IBOutlet private weak var diffView: UIView!
    @IBOutlet private weak var diffLabel: UILabel!
    @IBOutlet private weak var chartView: CompactChartView!
    @IBOutlet private weak var chartViewWidthConstraint: NSLayoutConstraint!
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        layoutIfNeeded()
        UIView.animate(withDuration: animated ? 0.33:0) {
            self.chartViewWidthConstraint.constant = editing ? 0 : 110
            self.chartView.alpha = editing ? 0 : 1
            self.layoutIfNeeded()
        }
    }
    
    func set(_ viewModel: RateItemViewModel) {
        guard viewModel.isPresenting(by: self) else { return }
        codeLabel.text = viewModel.code
        countryLabel.text = viewModel.country
        diffLabel.text = viewModel.diff.percentString
        diffView.backgroundColor = viewModel.diff.color
        if let rate = viewModel.rate {
            ratesLabel.text = rate.today
            chartView.set(rate.history)
        } else {
            ratesLabel.text = "🤔"
            chartView.setChartHidden(true)
        }
        
        viewModel.onUpdating = { [weak self] (viewModel) in
            self?.set(viewModel)
        }
        
    }
}
