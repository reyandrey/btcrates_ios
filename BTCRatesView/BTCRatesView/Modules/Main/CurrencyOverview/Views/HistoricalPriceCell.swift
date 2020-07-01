//
//  HistoricalPriceCell.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 01.07.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class HistoricalPriceCell: UITableViewCell, CellInstantiable {
  private let df: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .long
    df.locale = .current
    return df
  }()
  
  private let currencyFormatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.usesGroupingSeparator = true
    fmt.numberStyle = .currency
    fmt.allowsFloats = true
    fmt.currencySymbol = ""
    fmt.currencyGroupingSeparator = " "
    fmt.currencyDecimalSeparator = "."
    return fmt
  }()
  
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
  
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(1)
    context?.setLineDash(phase: 0, lengths: [1])
    context?.setStrokeColor( #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor)
    context?.move(to: CGPoint(x: rect.midX, y: rect.minY))
    context?.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
    context?.addLine(to: CGPoint(x: rect.minX+20, y: rect.maxY))
    context?.addLine(to: CGPoint(x: rect.maxX-20, y: rect.maxY))
    context?.strokePath()
  }
  
  func set(_ rate: BPIHistory.Rate) {
    dateLabel.text = df.string(from: rate.date)
    priceLabel.text = currencyFormatter.string(from: NSNumber(value: rate.value))
  }
}
