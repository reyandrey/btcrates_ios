//
//  AppCoordinator.swift
//  Forismatic
//
//  Created by Andrey on 05.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorProtool {
    func start()
}

protocol ReloadableContentProtocol {
    func reload()
}

class AppCoordinator: CoordinatorProtool {
    
    private var window: UIWindow? { UIApplication.shared.keyWindow }
    private var currenciesCoordinator: RatesCoordinator!
    
    func start() {
        currenciesCoordinator = RatesCoordinator()
        currenciesCoordinator.start()
    }
    
}

private extension AppCoordinator {
    
}