//
//  ChartViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 19.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import SnapKit

class ChartViewController: UIViewController {
  
  private lazy var chartView: CompactChartView = {
    let chart = CompactChartView()
    return chart
  }()
  
  override func loadView() {
    super.loadView()
    setup()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let values: [Double] = [
      648, 654, 658, 659, 656, 652, 650,
      648, 650, 652, 654, 656, 658, 659
    ]
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.chartView.set(values)
    }
  }
  
}

private extension ChartViewController {
  func setup() {
    view.backgroundColor = .white
    let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDidTap(_:)))
    doneItem.tintColor = .darkText
    navigationItem.setRightBarButton(doneItem, animated: false)
    
    view.addSubview(chartView)
    chartView.snp.makeConstraints { m in
      m.center.equalToSuperview()
      m.height.equalTo(44)
      m.width.equalTo(132)
    }
  }
  
  @objc func doneDidTap(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: Static

extension ChartViewController {
  
  class func show(from presenter: UIViewController) {
    let vc = ChartViewController()
    let nc = UINavigationController(rootViewController: vc)
    nc.modalPresentationStyle = .overFullScreen
    presenter.present(nc, animated: true, completion: nil)
  }
  
}
