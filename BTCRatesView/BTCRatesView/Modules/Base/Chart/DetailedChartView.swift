//
//  DetailedChartView.swift
//  BTCRatesView
//
//  Created by Andrey on 01.07.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import SnapKit
import Charts
import UIKit

class DetailedChartView: UIView {
  
  private lazy var lineChart: LineChartView = {
    let lineChart = LineChartView()
    lineChart.translatesAutoresizingMaskIntoConstraints = false
    lineChart.legend.setCustom(entries: [])
    lineChart.setScaleEnabled(false)
    
    lineChart.xAxis.enabled = true
    lineChart.xAxis.drawGridLinesEnabled = false
    lineChart.xAxis.labelPosition = .bottom
    lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    lineChart.xAxis.labelTextColor = .black
    lineChart.xAxis.avoidFirstLastClippingEnabled = true
    
    
    lineChart.leftAxis.enabled = true
    lineChart.leftAxis.setLabelCount(3, force: true)
    lineChart.leftAxis.labelPosition = .outsideChart
    lineChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .light)
    lineChart.leftAxis.labelTextColor = .black
    lineChart.leftAxis.drawBottomYLabelEntryEnabled = true
    lineChart.leftAxis.drawGridLinesEnabled = false
    
    lineChart.rightAxis.enabled = false
    
    lineChart.dragEnabled = true
    return lineChart
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    lineChart.frame = bounds
  }
}

private extension DetailedChartView {
  func setup() {
    addSubview(lineChart)
    lineChart.data = nil
  }
  
  func chartData(with entries: [ChartDataEntry], isGrowing: Bool) -> LineChartData {
    let set = LineChartDataSet(entries: entries, label: nil)
    let chartTint: UIColor = isGrowing ? .systemGreen : .systemRed
    set.lineWidth = 1
    set.mode = .cubicBezier
    set.axisDependency = .left
    set.drawValuesEnabled = false
    set.drawCirclesEnabled = false
    set.setColor(chartTint)
    set.highlightEnabled = true
    set.highlightLineDashLengths = [5, 2.5]
    set.highlightLineWidth = 1
    set.highlightColor = .systemBlue
    set.fillAlpha = 1
    let gradientColors = [chartTint.withAlphaComponent(0).cgColor, chartTint.withAlphaComponent(1).cgColor]
    let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
    set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
    set.drawFilledEnabled = true
    
    let data = LineChartData(dataSet: set)
    return data
  }
  
}

extension DetailedChartView {
  func set(_ values: [Double]?) {
    DispatchQueue.global().async {
      guard let values = values, values.count >= 2, let minValue = values.min(), let maxValue = values.max() else { return }
      guard let last = values.last, let secondLast = values.dropLast().last else { return }
      let entries = values.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element) }
      let data = self.chartData(with: entries, isGrowing: last >= secondLast)
      let margin = max(abs(maxValue - minValue)/2, 1)
      self.lineChart.leftAxis.axisMinimum = minValue - margin
      self.lineChart.leftAxis.axisMaximum = maxValue + margin
      self.lineChart.xAxis.axisMinimum = 0
      self.lineChart.xAxis.axisMaximum = Double(values.count - 1)
      DispatchQueue.main.async {
        self.lineChart.data = data
        self.setChartHidden(false)
      }
    }
  }
  
  func setChartHidden(_ hidden: Bool, animated: Bool = true) {
    UIView.animate(withDuration: animated ? 0.33 : 0) {
      self.lineChart.layer.opacity = hidden ? 0:1
    }
  }
}
