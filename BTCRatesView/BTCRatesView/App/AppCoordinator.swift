//
//  AppCoordinator.swift
//  Forismatic
//
//  Created by Andrey on 05.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        let navigationController = NavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let currenciesCoordinator = RatesCoordinator(with: navigationController)
        addChild(currenciesCoordinator)
        currenciesCoordinator.completionHandler = { [weak self] in
            self?.removeChild(currenciesCoordinator)
        }
        currenciesCoordinator.start()
    }
    
}

