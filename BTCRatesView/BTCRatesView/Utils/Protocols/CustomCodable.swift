//
//  DataRepresentable.swift
//  BTCRatesView
//
//  Created by Andrey on 24.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

public typealias CustomCodable = CustomEncodable&CustomDecodable

public protocol CustomDecodable {
  init(with data: Data) throws
}

public protocol CustomEncodable {
  func encode() throws -> Data
}
