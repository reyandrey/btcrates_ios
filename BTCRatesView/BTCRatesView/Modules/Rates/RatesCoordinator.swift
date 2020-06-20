//
//  CurrenciesCoordinator.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit
class RatesCoordinator: CoordinatorProtool {
    
    private var window: UIWindow? { UIApplication.shared.keyWindow }
    private var navigationController: UINavigationController!
    private var currenciesViewController: RatesViewController?
    private var profileManager = ProfileManager()
    
    func start() {
        let cvc = getRatesController()
        navigationController = UINavigationController(rootViewController: cvc)
        UINavigationBar.appearance().tintColor = .black
        window?.rootViewController = navigationController
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
        vc.viewModel = AddCurrencyViewModel()
        vc.delegate = self
        return vc
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

// MARK: AddCurrencyViewControllerDelegate

extension RatesCoordinator: AddCurrencyViewControllerDelegate {
    
    func controller(_ controller: AddCurrencyViewController, didSelect item: Currency) {
        profileManager.userCurrencies.append(item)
        navigationController.viewControllers.filter({ $0 is ReloadableContentProtocol }).forEach { ($0 as! ReloadableContentProtocol).reload() }
        controller.dismiss(animated: true, completion: nil)
    }

}

