//
//  BPIEndpoint.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

enum BPIEndpint: APIEndpoint {
    case currenciesNSI
    
    var path: String {
        switch self {
        case .currenciesNSI: return "/supported-currencies.json"
        }
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .currenciesNSI: return nil
        }
    }
    
}
