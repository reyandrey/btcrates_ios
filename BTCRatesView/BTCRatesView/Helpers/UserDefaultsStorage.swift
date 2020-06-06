//
//  UserDefaultsStorage.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

/// Обертка, которая позволи хранить переменные сразу в UserDefaults
@propertyWrapper public struct UserDefaultsStandart<T> {
    
    /// Ключ для хранения в UserDefaults
    private let key: String
    
    /// Значение по умолчанию
    private let defaultValue: T
    
    /// Инициализатор должен быть объявлен публичным, для доступа к нему в других модулях
    /// - Parameters:
    ///   - key: Ключ для хранения в UserDefaults
    ///   - defaultValue: Значение по умолчанию, если по данному ключу ничего нет
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    /// Процесс обертывания переменной, через переопределения геттера и сеттера
    public var wrappedValue: T {
        get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
}
