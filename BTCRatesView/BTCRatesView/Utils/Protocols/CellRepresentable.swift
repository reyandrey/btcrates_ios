//
//  CellRepresentable.swift
//  BTCRatesView
//
//  Created by Andrey on 24.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol CellRepresentable {
    static func registerCell(in tableView: UITableView)
    
    func dequeueCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}
