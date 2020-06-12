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
    
    // path
    var baseURL: URL { return URL(string: "https://api.coindesk.com/v1/bpi")! }
    var path: String {
        switch self {
        case .currencies: return "/supported-currencies.json"
        case .currentPrice(let code): return "/currentprice/\(code).json"
        }
    }
    var queryItems: [URLQueryItem]? {
        return nil
    }
}

extension CoinDeskAPI: APIEndpoint {

    var method: HTTPMethod {
        switch self {
        case .currencies, .currentPrice(_): return .get
        }
    }
    
    var url: URL {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = self.queryItems
        return urlComponents!.url!
    }

}
