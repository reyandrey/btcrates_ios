//
//  AppCoordinator.swift
//  Forismatic
//
//  Created by Andrey on 05.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    private var window: UIWindow? { UIApplication.shared.keyWindow }
    private var currenciesCoordinator: CurrenciesCoordinator!
    
    func start() {
        currenciesCoordinator = CurrenciesCoordinator()
        currenciesCoordinator.start()
    }
    
}

private extension AppCoordinator {
    
}
