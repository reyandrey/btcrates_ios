//
//  ViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol DashboardViewControllerDelegate: class {
  func controllerShouldAddNewCurrency(_ controller: DashboardViewController)
}

class DashboardViewController: UIViewController, StoryboardObject {
  typealias T = DashboardViewController
  static var storyboardName: String { return "Dashboard" }
  
  var viewModel: DashboardViewModel!
  weak var delegate: DashboardViewControllerDelegate?
  
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

extension DashboardViewController {
  
  func bindViewModel() {
    viewModel.onUpdating = { [weak self] updating in
      self?.onUpdating(updating)
    }
    viewModel.onUpdateSelected = { [weak self] updates in
      guard let self = self else { return }
      self.tableView.performBatchUpdates({
        self.tableView.deleteRows(at: updates.deleted.map { IndexPath(row: $0, section: 0) }, with: .fade)
        self.tableView.insertRows(at: updates.inserted.map { IndexPath(row: $0, section: 0) }, with: .fade)
      }, completion: nil)
    }
  }
  
  func onUpdating(_ updating: Bool) {
    title = updating ? "Updating.." : viewModel.title
    if !updating { tableView.reloadData() }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.refreshControl.endRefreshing()
    }
  }
}

// MARK: Private Methods

private extension DashboardViewController {
  @available(iOS 13.0, *)
  func setup() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 95
    
    let addImage = UIImage(systemName: "plus")
    let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addDidTap(_:)))
    navigationItem.setRightBarButtonItems([addButton], animated: false)
  }
  
  @objc func addDidTap(_ sender: Any) {
    delegate?.controllerShouldAddNewCurrency(self)
  }
  
  @objc func pullToRefresh(_ sender: Any) {
    reload()
  }
}

// MARK: UITableViewDataSource

extension DashboardViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.rateItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return viewModel.rateItems[indexPath.row].dequeueCell(in: tableView, at: indexPath)
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      viewModel.remove(at: indexPath.row)
    }
  }
  
}

// MARK: UITableViewDelegate

extension DashboardViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}