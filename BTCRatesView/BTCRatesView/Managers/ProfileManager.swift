//
//  ProfileManager.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class ProfileManager {
    private enum Keys: String {
        case currencies
    }

    private var userDefaults: UserDefaults
    
    @UserDefaultsStandart(key: Keys.currencies.rawValue, defaultValue: nil)
    private var userCurrencies: Data?
    
    init(with defaults: UserDefaults = .standard) {
        self.userDefaults = defaults
    }
    
    func getCurrencies() -> [Currency] {
        if let cachedData = userCurrencies, let objects = try? JSONDecoder().decode([Currency].self, from: cachedData) {
            return objects
        } else {
            return []
        }
    }
    
    func setCurrencies(_ newValue: [Currency]) {
        userCurrencies = try? JSONEncoder().encode(newValue)
    }
    
    func addCurrencies(_ newItems: [Currency]) {
        let current = getCurrencies()
        setCurrencies(current + newItems)
    }
    
}

