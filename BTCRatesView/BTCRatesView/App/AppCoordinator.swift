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
  var navigationController: NavigationController!
  
  init(window: UIWindow) {
    self.window = window
    super.init()
  }
  
  override func start() {
    navigationController = NavigationController()
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    let splashScreen = SplashViewController()
    navigationController.setViewControllers([splashScreen], animated: false)
    CoinDeskClient().syncCurrencies { error in
      DispatchQueue.main.async {
        if let error = error { self.navigationController.presentAlert(withTitle: "Error", message: "Failed to sync currencies: \(error)") }
        self.showMain()
      }
    }
  }
  
}

private extension AppCoordinator {
  
  func showMain() {
    let currenciesCoordinator = RatesCoordinator(with: navigationController)
    addChild(currenciesCoordinator)
    currenciesCoordinator.completionHandler = { [weak self] in
      self?.removeChild(currenciesCoordinator)
    }
    currenciesCoordinator.start()
  }
}
