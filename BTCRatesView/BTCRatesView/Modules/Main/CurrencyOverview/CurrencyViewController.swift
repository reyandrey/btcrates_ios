//
//  CurrencyViewController.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 01.07.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import PanModal

fileprivate typealias Sections = CurrencyViewModel.Sections

class CurrencyViewController: ViewController, StoryboardObject {
  static var storyboardName: String { return "Dashboard" }
  typealias T = CurrencyViewController
  
  var viewModel: CurrencyViewModel!
  
  @IBOutlet weak var tableView: UITableView!
  
  override var activityIndicatorStyle: ViewController.ActivityIndicatorStyle { return .top }
  
  override func loadView() {
    super.loadView()
    setup()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
    viewModel.reloadData()
  }
  
}


// MARK: ViewModel

extension CurrencyViewController {
  func bindViewModel() {
    viewModel.onUpdating = { [weak self] updating in
      guard let self = self else { return }
      self.setActivityIndication(updating)
      if !updating { self.tableView.reloadData() }
    }
  }
}

// MARK: UITableViewDataSource

extension CurrencyViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allCases.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Sections(rawValue: section)! {
    case .periodSelector: return 1
    case .historicalData: return 7
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch Sections(rawValue: indexPath.section)! {
    case .periodSelector: return dequeueSelectorCell(in: tableView, at: indexPath)
    case .historicalData: return dequeueHistoricalItemCell(in: tableView, at: indexPath)
    }
  }
  
  func dequeueSelectorCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PeriodSelectorCell.reuseId, for: indexPath) as? PeriodSelectorCell else { fatalError() }
    return cell
  }
  
  func dequeueHistoricalItemCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalPriceCell.reuseId, for: indexPath) as? HistoricalPriceCell else { fatalError() }
    return cell
  }
}

// MARK: UITableViewDelegate

extension CurrencyViewController: UITableViewDelegate {
  
}

// MARK: Private
private extension CurrencyViewController {
  func setup() {
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension CurrencyViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    return tableView
  }
  
  var longFormHeight: PanModalHeight {
    return .maxHeight
  }
  
  var shortFormHeight: PanModalHeight {
    return .contentHeight(375)
  }
}
