//
//  RatesSectionFooter.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 07.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class RatesSectionFooter: UITableViewHeaderFooterView {

    @IBOutlet private weak var datetimeLabel: UILabel!
    private let df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E, d MMM HH:mm"
        return df
    }()
    
    var updatedDateTime: Date? {
        didSet {
            guard let updatedDateTime = updatedDateTime else {
                datetimeLabel.text = "Last updated: -"
                return
            }
            let dateString = df.string(from: updatedDateTime)
            datetimeLabel.text = "Last updated: \(dateString)"
        }
    }
    
}
