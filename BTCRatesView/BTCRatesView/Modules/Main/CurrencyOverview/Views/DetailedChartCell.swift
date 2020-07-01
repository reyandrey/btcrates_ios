//
//  DetailedChartCell.swift
//  BTCRatesView
//
//  Created by Andrey on 01.07.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class DetailedChartCell: UITableViewCell, CellInstantiable {
  lazy var chartView: DetailedChartView = {
    let v = DetailedChartView()
    return v
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
}

private extension DetailedChartCell {
  func setup() {
    contentView.addSubview(chartView)
    chartView.snp.makeConstraints { m in
      m.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
      m.height.equalTo(220)
    }
  }
}
