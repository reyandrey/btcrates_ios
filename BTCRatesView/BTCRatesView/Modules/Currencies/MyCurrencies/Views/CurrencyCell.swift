//
//  CurrencyCell.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static var reuseId: String { return String(describing: Self.self) }
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var ratesLabel: UILabel!

}
