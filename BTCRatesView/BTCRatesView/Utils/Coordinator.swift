//
//  Coordinator.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

protocol CoordinatorProtocol: class {
    var completionHandler: (()->())? { get set }
    
    var childCoordinators: [CoordinatorProtocol] { get set }
    
    func start()
}

extension CoordinatorProtocol {
    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

class Coordinator: CoordinatorProtocol {
    var completionHandler: (()->())? = nil
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start() {
        fatalError("should implement in child")
    }
}
