//
//  ViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol CurrenciesViewControllerDelegate: class {
    func controllerShouldAddNewCurrency(_ controller: CurrenciesViewController)
}

class CurrenciesViewController: UIViewController, Storyboardable {
    typealias T = CurrenciesViewController
    static var storyboardName: String { return "Currencies" }
    
    var viewModel: CurrenciesViewModel!
    weak var delegate: CurrenciesViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }


}

// MARK: Private Methods

private extension CurrenciesViewController {
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addDidTap(_:)))
        navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    @objc func addDidTap(_ sender: Any) {
        delegate?.controllerShouldAddNewCurrency(self)
    }
}

// MARK: UITableViewDataSource

extension CurrenciesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCurrencyCell(in: tableView, at: indexPath)
    }
    
}

// MARK: UITableViewDelegate

extension CurrenciesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: TableView Updating

private extension CurrenciesViewController {
    
    func getCurrencyCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseId, for: indexPath) as? CurrencyCell else { return UITableViewCell() }
        return cell
    }

}
