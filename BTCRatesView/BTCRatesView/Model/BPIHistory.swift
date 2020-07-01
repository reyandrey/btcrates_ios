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
    
    let history: [Rate] = try JSON(data: data)["bpi"].dictionaryValue.map { (key, val) in
      guard let date = df.date(from: key) else { throw HTTPClient.ErrorType.serializationError }
      return Rate(date: date, value: val.doubleValue)
    }
    
    self.data = history.sorted { $0.date < $1.date }
  }
}

extension BPIHistory {
  
  struct Rate {
    let date: Date
    let value: Double
  }
  
  enum Period: Int {
    case week, month, sixMonth, year
    
    var endDate: Date {
      return Date()
    }
    
    var startDate: Date {
      switch self {
      case .week: return Calendar.current.date(byAdding: .day, value: -7, to: self.endDate) ?? Date()
      case .month: return Calendar.current.date(byAdding: .month, value: -1, to: self.endDate) ?? Date()
      case .sixMonth: return Calendar.current.date(byAdding: .month, value: -6, to: self.endDate) ?? Date()
      case .year: return Calendar.current.date(byAdding: .year, value: -1, to: self.endDate) ?? Date()
      }
    }
  }
}
