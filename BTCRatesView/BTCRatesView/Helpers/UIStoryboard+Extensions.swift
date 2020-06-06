//
//  UIStoryboard+Extensions.swift
//  RequestManager
//
//  Created by Andrey on 30.05.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboardable: StoryboardIdentifiable&StoryboardInstantiable {}
protocol StoryboardIdentifiable: UIViewController {
    static var storyboardName: String { get }
}
protocol StoryboardInstantiable: UIViewController{
    associatedtype T: StoryboardIdentifiable
    static func instantiate() -> T
}
extension StoryboardInstantiable {
    static func instantiate() -> T {
        return UIStoryboard(name: T.storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
