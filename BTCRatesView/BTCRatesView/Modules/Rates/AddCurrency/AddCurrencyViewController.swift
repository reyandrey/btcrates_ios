//
//  AddCurrencyViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol AddCurrencyViewControllerDelegate: class {
    func controller(_ controller: AddCurrencyViewController, didSelect item: Currency)
}

class AddCurrencyViewController: UIViewController, Storyboardable {
    typealias T = AddCurrencyViewController
    static var storyboardName: String { return "Rates" }

    var viewModel: AddCurrencyViewModel!
    weak var delegate: AddCurrencyViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        viewModel.reloadData()
    }
    

}

//MARK: ViewModel

extension AddCurrencyViewController {
    
    func bindViewModel() {
        viewModel.didUpdate = { [weak self] viewModel in
            DispatchQueue.main.async { self?.didUpdate(viewModel) }
        }
    }
    
    func didUpdate(_ viewModel: AddCurrencyViewModel) {
        tableView.reloadData()
    }
}

// MARK: Private Methods

private extension AddCurrencyViewController {
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
}

// MARK: UITableViewDataSource

extension AddCurrencyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getAddCurrencyCell(in: tableView, at: indexPath)
    }
    
}

// MARK: UITableViewDelegate

extension AddCurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.controller(self, didSelect: viewModel.currencies[indexPath.row])
    }
    
}

// MARK: TableView Updating

private extension AddCurrencyViewController {
    
    func getAddCurrencyCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyCell.reuseId, for: indexPath) as? AddCurrencyCell else { return UITableViewCell() }
        let c = viewModel.currencies[indexPath.row]
        cell.codeLabel.text = c.code
        cell.countryLabel.text = c.country
        return cell
    }

}
