//
//  ManagedDecodable.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData.NSManagedObjectContext

public extension Decoder {
  var managedObjectContext: NSManagedObjectContext? {
    return userInfo[.managedObjectContext] as? NSManagedObjectContext
  }
}

public extension CodingUserInfoKey {
  static var managedObjectContext: CodingUserInfoKey {
    return CodingUserInfoKey(rawValue: "managedObjectContext")!
  }
}
