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

    @UserDefaultsStandart(key: Keys.currencies.rawValue, defaultValue: nil)
    private var userCurrenciesData: Data?
    private var userDefaults: UserDefaults
    
    var userCurrencies: [Currency] {
        get { getCurrencies() }
        set { setCurrencies(newValue) }
    }
    
    init(with defaults: UserDefaults = .standard) {
        self.userDefaults = defaults
    }
    
    private func getCurrencies() -> [Currency] {
        if let cachedData = userCurrenciesData, let objects = try? JSONDecoder().decode([Currency].self, from: cachedData) {
            return objects
        } else {
            return []
        }
    }
    
    private func setCurrencies(_ newValue: [Currency]) {
        userCurrenciesData = try? JSONEncoder().encode(newValue)
    }
}

