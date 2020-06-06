//
//  CurrenciesCoordinator.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit
class CurrenciesCoordinator: CoordinatorProtool {
    
    private var window: UIWindow? { UIApplication.shared.keyWindow }
    private var navigationController: UINavigationController!
    private var currenciesViewController: CurrenciesViewController?
    private var profileManager = ProfileManager()
    
    func start() {
        let cvc = getCurrenciesController()
        navigationController = UINavigationController(rootViewController: cvc)
        window?.rootViewController = navigationController
    }
    
}

// MARK: Private

private extension CurrenciesCoordinator {
    
    func getCurrenciesController() -> CurrenciesViewController {
        let vc = CurrenciesViewController.instantiate()
        vc.viewModel = CurrenciesViewModel(profileManager: self.profileManager)
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

extension CurrenciesCoordinator: CurrenciesViewControllerDelegate {
    
    func controllerShouldAddNewCurrency(_ controller: CurrenciesViewController) {
        let vc = getAddCurrencyController()
        navigationController.pushViewController(vc, animated: true)
    }
    
}

// MARK: AddCurrencyViewControllerDelegate

extension CurrenciesCoordinator: AddCurrencyViewControllerDelegate {
    
    func controller(_ controller: AddCurrencyViewController, didSelect item: String) {
        // mock objects for testing
        let current = profileManager.getCurrencies()
        profileManager.setCurrencies(current + Currency.mock())
        
        navigationController.viewControllers.filter({ $0 is ReloadableContentProtocol }).forEach { ($0 as! ReloadableContentProtocol).reload() }
        navigationController.popViewController(animated: true)
    }

}

