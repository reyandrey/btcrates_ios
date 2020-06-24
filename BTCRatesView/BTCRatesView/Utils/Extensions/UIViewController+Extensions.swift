//
//  Helpers.swift
//  RequestManager
//
//  Created by Andrey on 30.05.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  /**
   Presents an "Ok" alert.
   
   - Parameters:
   - title: Alert title.
   - message: Alert message.
   - completionHandler: Completion handler. *Optional*.
   */
  public func presentAlert(withTitle title: String?, message: String?, completionHandler: (() -> ())? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
      completionHandler?()
    }
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  /**
   Creates a `.keyboardWillShowNotification` observer, parses notification user info and invokes handler closure with
   parameters `keyboardHeight`: *CGFloat* and `animationDuration`: *Double*.
   
   - parameter handler: `.keyboardWillShowNotification` handler.
   - returns: Observer token.
   */
  public func addKeyboardWillShowHandler(handler handle: @escaping (CGFloat, Double) -> ()) -> NSObjectProtocol {
    return NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillShowNotification, object: nil, queue: .main) { note in
      guard let userInfo = note.userInfo,
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height,
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
      handle(keyboardHeight, animationDuration)
    }
  }
  
  /**
   Creates a `.keyboardWillHideNotification` observer, parses notification user info and invokes handler closure with
   parameter `animationDuration`: *Double*.
   
   - parameter handler: `.keyboardWillShowNotification` handler.
   - returns: Observer token.
   */
  public func addKeyboardWillHideHandler(handler handle: @escaping (Double) -> ()) -> NSObjectProtocol {
    return NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillHideNotification, object: nil, queue: .main) { note in
      guard let userInfo = note.userInfo,
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
      handle(animationDuration)
    }
  }
  
}
