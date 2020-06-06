//
//  CurrenciesCoordinator.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit
class CurrenciesCoordinator: Coordinator {
    
    private var window: UIWindow? { UIApplication.shared.keyWindow }
    private var navigationController: UINavigationController!
    
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
        vc.viewModel = CurrenciesViewModel()
        vc.delegate = self
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
        navigationController.popViewController(animated: true)
    }

}

