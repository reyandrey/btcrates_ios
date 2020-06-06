//
//  Currency.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class Currency: Codable {
    let code: String
    let country: String
    
    init(code: String, country: String) {
        self.code = code
        self.country = country
    }
    
    // MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
        case code = "currency", country
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.country = try container.decode(String.self, forKey: .country)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(country, forKey: .country)
    }
}

extension Currency {
    
    static func mock() -> [Currency] {
        return [Currency(code: "QWE", country: "lallalal"), Currency(code: "RTY", country: "lallalal"), Currency(code: "YUI", country: "lallalal")]
    }
    
}
