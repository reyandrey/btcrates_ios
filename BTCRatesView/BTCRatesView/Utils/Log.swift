//
//  Log.swift
//  BTCRatesView
//
//  Created by Andrey on 12.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import os.log

public protocol OSLogging {
    func log(_ message: String, level: OSLogType)
    func log(_ message: StaticString, _ args: CVarArg..., level: OSLogType)
}

public extension OSLogging {
    func log(_ message: String, level: OSLogType = .debug) {
        OSLogger<Self>(level).log("%@", message)
    }
    func log(_ message: StaticString, _ args: CVarArg..., level: OSLogType = .debug) {
        OSLogger<Self>(level).log(message, args)
    }
}

public class OSLogger<T> {
    private let subsystem = Bundle.main.bundleIdentifier ?? "unknown"
    private let log: OSLog
    private let level: OSLogType
    
    public init(_ logLevel: OSLogType = .debug) {
        self.log = OSLog(subsystem: subsystem, category: String(describing: T.self))
        self.level = logLevel
    }
    
    public func log(_ message: StaticString, _ args: CVarArg...) {
        os_log(message, log: log, type: level, args)
    }
    
    public func log(_ message: String) {
        os_log("%@", log: log, type: level, message)
    }
}
