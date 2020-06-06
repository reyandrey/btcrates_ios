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

class CurrenciesViewController: UIViewController, Storyboardable, ReloadableContentProtocol {
    typealias T = CurrenciesViewController
    static var storyboardName: String { return "Currencies" }
    
    var viewModel: CurrenciesViewModel!
    weak var delegate: CurrenciesViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        reload()
    }
    
    func reload() {
        viewModel.reloadData()
    }

}

//MARK: ViewModel

extension CurrenciesViewController {
    
    func bindViewModel() {
        viewModel.didUpdate = { [weak self] viewModel in
            self?.didUpdate(viewModel)
        }
    }
    
    func didUpdate(_ viewModel: CurrenciesViewModel) {
        tableView.reloadData()
        
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
        return viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCurrencyCell(in: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCurrency(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
        cell.codeLabel.text = viewModel.currencies[indexPath.row].code
        cell.countryLabel.text = viewModel.currencies[indexPath.row].country
        cell.ratesLabel.text = "-"
        return cell
    }

}
