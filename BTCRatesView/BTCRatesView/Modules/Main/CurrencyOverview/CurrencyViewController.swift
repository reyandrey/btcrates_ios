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
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var codeLabel: UILabel!
  @IBOutlet private weak var countryLabel: UILabel!
  @IBOutlet private weak var ratesLabel: UILabel!
  @IBOutlet private weak var diffView: UIView!
  @IBOutlet private weak var diffLabel: UILabel!
  @IBOutlet private weak var segmentedControl: UISegmentedControl!
  
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
      if !updating { self.viewModelDidUpdate() }
    }
    
    viewModel.onChangePeriod = { [weak self] left in
      guard let self = self else { return }
      self.tableView.reloadSections([Sections.historicalData.rawValue], with: left ? .right : .left)
    }
  }
  
  func viewModelDidUpdate() {
    codeLabel.text = viewModel.code
    countryLabel.text = viewModel.country
    diffLabel.text = viewModel.diff.percentString
    diffView.backgroundColor = viewModel.diff.color
    if let rate = viewModel.rate {
      ratesLabel.text = rate.today
    } else {
      ratesLabel.text = "-"
    }
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource

extension CurrencyViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allCases.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Sections(rawValue: section)! {
    case .historicalData: return viewModel.historyPeriod.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch Sections(rawValue: indexPath.section)! {
    case .historicalData: return dequeueHistoricalItemCell(in: tableView, at: indexPath)
    }
  }
  
  func dequeueHistoricalItemCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalPriceCell.reuseId, for: indexPath) as? HistoricalPriceCell else { fatalError() }
    let rate = viewModel.historyPeriod[indexPath.row]
    cell.setDate(rate.date)
    cell.setPrice(rate.value)
    return cell
  }
}

// MARK: UITableViewDelegate

extension CurrencyViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch Sections(rawValue: indexPath.section)! {
    case .historicalData: return 40
    }
  }
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return false
  }
}

// MARK: Private

private extension CurrencyViewController {
  func setup() {
    tableView.dataSource = self
    tableView.delegate = self
    segmentedControl.addTarget(self, action: #selector(didSelectPeriod(_:)), for: .valueChanged)
  }
  
  @objc func didSelectPeriod(_ sender: UISegmentedControl) {
    guard let p = BPIHistory.Period(rawValue: sender.selectedSegmentIndex) else { return }
    viewModel.selectedPeriod = p
  }
}

// MARK: PanModalPresentable

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
