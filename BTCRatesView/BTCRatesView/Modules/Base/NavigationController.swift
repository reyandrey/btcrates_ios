//
//  NavigationController.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit
import PanModal

class NavigationController: UINavigationController, PanModalPresentable {
  
  public var panScrollable: UIScrollView? {
    return (topViewController as? PanModalPresentable)?.panScrollable
  }
  
  public var longFormHeight: PanModalHeight {
    return .maxHeight
  }
  
  public var shortFormHeight: PanModalHeight {
    return longFormHeight
  }
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let vc = super.popViewController(animated: animated)
    panModalSetNeedsLayoutUpdate()
    return vc
  }
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    panModalSetNeedsLayoutUpdate()
  }
  
}
