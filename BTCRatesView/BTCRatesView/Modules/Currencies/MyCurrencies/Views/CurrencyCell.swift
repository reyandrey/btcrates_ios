//
//  CurrencyCell.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell, CellIdentifiable {
    static var reuseId: String { return String(describing: Self.self) }
    var indexPath: IndexPath? = nil
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var ratesLabel: UILabel!

    func setup(with itemViewModel: CurrencyItemViewModel) {
        codeLabel.text = itemViewModel.code
        countryLabel.text = itemViewModel.country
    }
}
