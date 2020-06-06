//
//  App.swift
//  RequestManager
//
//  Created by Andrey on 30.05.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol Environment {
    static var serverURL: String { get }
}

class BTEnvironment: Environment {
    private init() { }
    static var serverURL: String { return "https://api.coindesk.com/v1/bpi" }
}

