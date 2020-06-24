//
//  BPIHistory.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class BPIHistory: CustomDecodable {
  let data: [Rate]
  
  required init(with data: Data) throws {
    let df = DateFormatter.ISO8601_date
    
    let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONObject
    guard let bpiJSON = json?["bpi"] as? [String: Double] else { throw HTTPClient.ErrorType.serializationError }
    
    let decodedObjects: [Rate] = try bpiJSON.map { (key, val) in
      guard let date = df.date(from: key) else { throw HTTPClient.ErrorType.serializationError }
      return Rate(date: date, value: val)
    }
    
    self.data = decodedObjects.sorted(by: { (lhs, rhs) -> Bool in
      lhs.date < rhs.date
    })
  }
}

extension BPIHistory {
  struct Rate {
    let date: Date
    let value: Double
  }
  
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
