//
//  DateFormatter+Extensions.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let ISO8601_date: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(abbreviation: "GMT+0:00")
        df.dateFormat = "yyy-MM-dd"
        return df
    }()
    
}
