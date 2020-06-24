//
//  CoinDeskAPI.swift
//  BTCRatesView
//
//  Created by Andrey on 12.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

enum CoinDeskAPI {
  case currencies
  case currentPrice(code: String)
  case historical(code: String, start: Date, end: Date)
  
  var baseURL: URL { return URL(string: "https://api.coindesk.com/v1/bpi")! }
  
  var path: String {
    switch self {
    case .currencies: return "/supported-currencies.json"
    case .currentPrice(let code): return "/currentprice/\(code).json"
    case .historical(_, _, _): return "/historical/close.json"
    }
  }
  var queryItems: [URLQueryItem]? {
    switch self {
    case .historical(let code, let start, let end):
      let codeItem = URLQueryItem(name: "currency", value: code)
      let startItem = URLQueryItem(name: "start", value: DateFormatter.ISO8601_date.string(from: start))
      let endItem = URLQueryItem(name: "end", value: DateFormatter.ISO8601_date.string(from: end))
      return [startItem, endItem, codeItem]
    default: return nil
    }
  }
}

extension CoinDeskAPI: APIEndpoint {
  var method: HTTPMethod {
    switch self {
    case .currencies, .currentPrice(_), .historical(_, _, _): return .get
    }
  }
  
  var url: URL {
    var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = self.queryItems
    return urlComponents!.url!
  }
}
