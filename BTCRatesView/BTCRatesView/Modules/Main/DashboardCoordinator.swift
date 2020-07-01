//
//  CurrenciesCoordinator.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

class DashboardCoordinator: Coordinator {
  private let apiClient: CoinDeskClient
  private let profileManager: ProfileManager
  
  private let navigationController: UINavigationController
  private var currenciesViewController: DashboardViewController?
  
  init(with navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.profileManager = ProfileManager.shared
    self.apiClient = CoinDeskClient()
  }
  
  override func start() {
    let ratesVC = getDashboardController()
    navigationController.setViewControllers([ratesVC], animated: true)
  }
}

// MARK: CurrenciesViewControllerDelegate

extension DashboardCoordinator: DashboardViewControllerDelegate {
  func showCurrencyOverview(_ controller: DashboardViewController, currrency: CurrencyModel) {
    let vc = getCurrencyViewController(currrency)
    controller.presentPanModal(vc)
  }

  func showAddCurrency(_ controller: DashboardViewController) {
    let vc = getAddCurrencyController()
    let nc = NavigationController()
    nc.setViewControllers([vc], animated: false)
    controller.presentPanModal(nc)
  }
}

// MARK: Private

private extension DashboardCoordinator {
  func getDashboardController() -> DashboardViewController {
    let vc = DashboardViewController.instantiate()
    vc.viewModel = DashboardViewModel(profileManager: self.profileManager)
    vc.delegate = self
    currenciesViewController = vc
    return vc
  }
  
  func getAddCurrencyController() -> AddCurrencyViewController {
    let vc = AddCurrencyViewController.instantiate()
    vc.viewModel = AddCurrencyViewModel(profileManager: self.profileManager)
    return vc
  }
  
  func getCurrencyViewController(_ currency: CurrencyModel) -> CurrencyViewController {
    let vc = CurrencyViewController.instantiate()
    vc.viewModel = CurrencyViewModel(currency)
    return vc
  }
}
