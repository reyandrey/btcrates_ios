//
//  AddCurrencyViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import PanModal

protocol AddCurrencyViewControllerDelegate: class {
    func controller(_ controller: AddCurrencyViewController, didSelect item: Currency)
}

class AddCurrencyViewController: UIViewController, Storyboardable {
    typealias T = AddCurrencyViewController
    static var storyboardName: String { return "Rates" }

    var viewModel: AddCurrencyViewModel!
    weak var delegate: AddCurrencyViewControllerDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
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
        title = viewModel.title
        tableView.reloadData()
    }
}

// MARK: Private Methods

private extension AddCurrencyViewController {
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search.."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDidTap(_:)))
        navigationItem.setRightBarButtonItems([doneButton], animated: false)
    }
    
    @objc func doneDidTap(_ sender: Any) {
        
    }
    
}

// MARK: Search

extension AddCurrencyViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        viewModel.filterContent(for: searchbar.text!)
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension AddCurrencyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? viewModel.filteredCurrencies.count : viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getAddCurrencyCell(in: tableView, at: indexPath)
    }
    
}

// MARK: UITableViewDelegate

extension AddCurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        #warning("fix selection")
        viewModel.currencies[indexPath.row].isSelected = true
        CoreDataStack.shared.saveChanges()
        //delegate?.controller(self, didSelect: isFiltering ? viewModel.filteredCurrencies[indexPath.row] : viewModel.currencies[indexPath.row])
    }
    
}

// MARK: TableView Updating

private extension AddCurrencyViewController {
    
    func getAddCurrencyCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCurrencyCell.reuseId, for: indexPath) as? AddCurrencyCell else { return UITableViewCell() }
        let c = isFiltering ? viewModel.filteredCurrencies[indexPath.row] : viewModel.currencies[indexPath.row]
        cell.codeLabel.text = c.code
        cell.countryLabel.text = c.country
        return cell
    }

}

extension AddCurrencyViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        tableView
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}
