//
//  BPIEndpoint.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

enum BPIEndpint: APIEndpoint {
    case currencies
    case currentPrice(code: String)
    
    var path: String {
        switch self {
        case .currencies: return "/supported-currencies.json"
        case .currentPrice(let code): return "/currentprice/\(code).json"
        }
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        default: return nil
        }
    }
    
}
