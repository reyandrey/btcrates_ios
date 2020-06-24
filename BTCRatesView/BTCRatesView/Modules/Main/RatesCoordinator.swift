//
//  CurrenciesCoordinator.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

class RatesCoordinator: Coordinator {
  private let apiClient: CoinDeskClient
  private let profileManager: ProfileManager
  
  private let navigationController: UINavigationController
  private var currenciesViewController: RatesViewController?
  
  init(with navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.profileManager = ProfileManager.shared
    self.apiClient = CoinDeskClient()
  }
  
  override func start() {
    let ratesVC = getRatesController()
    navigationController.setViewControllers([ratesVC], animated: true)
  }
}

// MARK: CurrenciesViewControllerDelegate

extension RatesCoordinator: RatesViewControllerDelegate {
  func controllerShouldAddNewCurrency(_ controller: RatesViewController) {
    let vc = getAddCurrencyController()
    let nc = NavigationController()
    nc.setViewControllers([vc], animated: false)
    controller.presentPanModal(nc)
  }
}

// MARK: Private

private extension RatesCoordinator {
  func getRatesController() -> RatesViewController {
    let vc = RatesViewController.instantiate()
    vc.viewModel = RatesViewModel(profileManager: self.profileManager)
    vc.delegate = self
    currenciesViewController = vc
    return vc
  }
  
  func getAddCurrencyController() -> AddCurrencyViewController {
    let vc = AddCurrencyViewController.instantiate()
    vc.viewModel = AddCurrencyViewModel(profileManager: self.profileManager)
    return vc
  }
}
