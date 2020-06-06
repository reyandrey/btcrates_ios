//
//  AddCurrencyViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol AddCurrencyViewControllerDelegate: class {
    func controller(_ controller: AddCurrencyViewController, didSelect item: String)
}

class AddCurrencyViewController: UIViewController, Storyboardable {
    typealias T = AddCurrencyViewController
    static var storyboardName: String { return "Currencies" }

    var viewModel: AddCurrencyViewModel!
    weak var delegate: AddCurrencyViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getAddCurrencyCell(in: tableView, at: indexPath)
    }
    
}

// MARK: UITableViewDelegate

extension AddCurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.controller(self, didSelect: "\(indexPath)")
    }
    
}

// MARK: TableView Updating

private extension AddCurrencyViewController {
    
    func getAddCurrencyCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyCell.reuseId, for: indexPath) as? AddCurrencyCell else { return UITableViewCell() }
        return cell
    }

}
