//
//  Log.swift
//  BTCRatesView
//
//  Created by Andrey on 12.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import os.log

public class Log<T> {
  private let log: OSLog
  
  public init(){
    self.log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "unknown", category: String(describing: T.self))
  }
  
  public func debug(_ message: String) {
    //os_log("%@", log: log, type: .debug, message)
  }
  
  public func error(_ message: String) {
    os_log("%@", log: log, type: .error, message)
  }
}
