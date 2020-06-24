//
//  AddCurrencyViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import PanModal

class AddCurrencyViewController: UIViewController, StoryboardObject {
  typealias T = AddCurrencyViewController
  static var storyboardName: String { return "Rates" }
  
  var viewModel: AddCurrencyViewModel!
  
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
    viewModel.onUpdating = { [weak self] updating in
      guard let self = self, !updating else { return }
      self.title = self.viewModel.title
      self.tableView.reloadData()
    }
    
    viewModel.profileManager.onUnselectedUpdate = { [weak self] updates in
      guard let self = self,
            !self.isFiltering else { return }
      self.tableView.performBatchUpdates({
        self.tableView.deleteRows(at: updates.deleted.map { IndexPath(row: $0, section: 0) }, with: .fade)
        self.tableView.insertRows(at: updates.inserted.map { IndexPath(row: $0, section: 0) }, with: .fade)
      }, completion: nil)
    }
  }
}

// MARK: Private Methods

private extension AddCurrencyViewController {
  func setup() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    tableView.register(AddCurrencyCell.self, forCellReuseIdentifier: AddCurrencyCell.reuseId)
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search.."
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
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
  
  // TODO: Via FRC
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isFiltering {
      viewModel.filteredCurrencies[indexPath.row].isSelected = true
      viewModel.filteredCurrencies.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.deselectRow(at: indexPath, animated: true)
    } else {
      viewModel.currencies[indexPath.row].isSelected = true
      tableView.deselectRow(at: indexPath, animated: true)
    }
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
