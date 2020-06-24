//
//  UITableViewCell+Extensions.swift
//  BTCRatesView
//
//  Created by Andrey on 24.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

public protocol CellInstantiable {
  static var reuseId: String { get }
}

public extension CellInstantiable {
  
  static var reuseId: String {
    return String(describing: Self.self)
  }
  
}
