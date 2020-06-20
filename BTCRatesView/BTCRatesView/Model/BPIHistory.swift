//
//  BPIHistory.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class BPIHistory {
    struct Rate {
        let date: Date
        let value: Double
    }
    
    let data: [Rate]
    
    init(from data: Data) throws {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let bpiJSON = json["bpi"] as? [String: Double] else { throw "Serialization: bpi not found" }
        let df = DateFormatter.ISO8601_date
        self.data = try bpiJSON.map { (key, val) in
            guard let date = df.date(from: key) else { throw "Serialization: invalid date format" }
            return Rate(date: date, value: val)
        }.sorted(by: { (lhs, rhs) -> Bool in
            lhs.date < rhs.date
        })
    }
}

extension BPIHistory {
    
    enum Period {
        case week, month, year
        
        var endDate: Date {
            return Date()
        }
        
        var startDate: Date {
            switch self {
            case .week: return Calendar.current.date(byAdding: .day, value: -7, to: self.endDate) ?? Date()
            case .month: return Calendar.current.date(byAdding: .month, value: -1, to: self.endDate) ?? Date()
            case .year: return Calendar.current.date(byAdding: .year, value: -1, to: self.endDate) ?? Date()
            }
        }
    }
}
