//
//  ViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol RatesViewControllerDelegate: class {
    func controllerShouldAddNewCurrency(_ controller: RatesViewController)
}

class RatesViewController: UIViewController, Storyboardable, ReloadableContentProtocol {
    typealias T = RatesViewController
    static var storyboardName: String { return "Rates" }
    
    var viewModel: RatesViewModel!
    weak var delegate: RatesViewControllerDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet private weak var seactionFooterView: RatesSectionFooter!
    @IBOutlet private weak var tableView: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        self.tableView.refreshControl = r
        r.addTarget(self, action: #selector(pullToRefresh(_:)), for: .primaryActionTriggered)
        return r
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) { setup() }
        bindViewModel()
        reload()
    }
    
    func reload() {
        viewModel.reloadData()
    }

}

//MARK: ViewModel

extension RatesViewController {
    
    func bindViewModel() {
        viewModel.didUpdate = { [weak self] viewModel in
            self?.didUpdate(viewModel)
        }
    }
    
    func didUpdate(_ viewModel: RatesViewModel) {
        title = viewModel.title
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: Private Methods

private extension RatesViewController {
    @available(iOS 13.0, *)
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 95
    
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search.."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        
        let editImage = UIImage(systemName: "list.bullet")
        let addImage = UIImage(systemName: "plus")
        let editButton = UIBarButtonItem(image: editImage, style: .plain, target: self, action: #selector(editDidTap(_:)))
        let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addDidTap(_:)))
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: false)
    }
    
    @objc func addDidTap(_ sender: Any) {
        delegate?.controllerShouldAddNewCurrency(self)
    }
    
    @objc func editDidTap(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing && !isFiltering, animated: true)
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        reload()
    }
}

// MARK: Search

extension RatesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        viewModel.filterContent(for: searchbar.text!)
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension RatesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? viewModel.filteredrateItems.count : viewModel.rateItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = isFiltering ? viewModel.filteredrateItems[indexPath.row] : viewModel.rateItems[indexPath.row]
        return item.dequeueCell(in: tableView, at: indexPath) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isFiltering
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCurrency(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.reorderCurrencies(moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
}

// MARK: UITableViewDelegate

extension RatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.rateItems[indexPath.row].didSelectCell()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = seactionFooterView
        v?.updatedDateTime = viewModel.lastUpdated
        return v
    }
    
}
