//
//  ChartView.swift
//  BTCRatesView
//
//  Created by Andrey on 19.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import SnapKit
import Charts
import UIKit

class CompactChartView: UIView {
    private lazy var lineChart: LineChartView = {
        let lineChart = LineChartView()
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.isUserInteractionEnabled = false
        lineChart.legend.setCustom(entries: [])
        lineChart.setScaleEnabled(false)
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.leftAxis.enabled = false
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

private extension CompactChartView {
    func setup() {
        addSubview(lineChart)
        lineChart.data = nil
        setChartHidden(true, animated: false)
    }
    
    func chartData(with entries: [ChartDataEntry], isGrowing: Bool) -> LineChartData {
        let set = LineChartDataSet(entries: entries, label: nil)
        let chartTint: UIColor = isGrowing ? .systemGreen : .systemRed
        set.lineWidth = 2
        set.mode = .linear
        set.axisDependency = .left
        set.drawValuesEnabled = false
        set.drawCirclesEnabled = false
        set.setColor(chartTint)
        set.fillAlpha = 1
        let gradientColors = [chartTint.withAlphaComponent(0).cgColor, chartTint.withAlphaComponent(1).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        return data
    }
    
}

extension CompactChartView {
    func set(_ values: [Double]?) {
        guard let values = values, values.count >= 2, let minValue = values.min(), let maxValue = values.max() else { return }
        guard let last = values.last, let secondLast = values.dropLast().last else { return }
        let entries = values.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element) }
        let data = chartData(with: entries, isGrowing: last >= secondLast)
        let margin = max(abs(maxValue - minValue)/2, 1)
        lineChart.leftAxis.axisMinimum = minValue - margin
        lineChart.leftAxis.axisMaximum = maxValue + margin
        lineChart.xAxis.axisMinimum = 0
        lineChart.xAxis.axisMaximum = Double(values.count - 1)
        
        lineChart.data = data
        setChartHidden(false)
    }
    
    func setChartHidden(_ hidden: Bool, animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.33 : 0) {
            self.lineChart.layer.opacity = hidden ? 0:1
        }
    }
}
