//
//  UIView+Extension.swift
//  Forismatic
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(withColor color: UIColor, opacity: Float = 0.3, radius: CGFloat = 10, xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
    }
}
