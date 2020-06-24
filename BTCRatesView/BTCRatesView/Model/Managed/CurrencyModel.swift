//
//  CurrencyModel.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class CurrencyModel: NSManagedObject, Decodable {
  @NSManaged private(set) var code: String
  @NSManaged private(set) var country: String
  @NSManaged var isSelected: Bool
  
  // MARK: Decodable
  
  private enum CodingKeys: String, CodingKey {
    case code = "currency", country
  }
  
  required init(from decoder: Decoder) throws {
    super.init(entity: CurrencyModel.entity(), insertInto: decoder.managedObjectContext)
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decode(String.self, forKey: .code)
    self.country = try container.decode(String.self, forKey: .country)
  }
  
  // MARK: NSManagedObject
  
  override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
  }
}

extension CurrencyModel: ManagedSyncable {
  typealias IDType = String
  static var idAttributeName: String { return "code" }
  var id: IDType { code }
  
  func update(with object: CurrencyModel) {
    self.code = object.code
    self.country = object.country
    // isSelected - stored local
  }
}
