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

extension RatesViewController {
    
    func bindViewModel() {
        viewModel.didUpdate = { [weak self] viewModel in
            self?.didUpdate(viewModel)
        }
    }
    
    func didUpdate(_ viewModel: RatesViewModel) {
        tableView.reloadData()
        
    }
}

// MARK: Private Methods

private extension RatesViewController {
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

extension RatesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.currencies[indexPath.row].dequeueCell(in: tableView, at: indexPath) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCurrency(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: UITableViewDelegate

extension RatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.currencies[indexPath.row].didSelectCell()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
