//
//  SplashViewController.swift
//  BTCRatesView
//
//  Created by Andrey on 20.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {

    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 28)
        lbl.textColor = .darkGray
        lbl.text = "SplashViewController"
        return lbl
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(label)
        label.snp.makeConstraints { m in
            m.center.equalToSuperview()
        }
    }
    
}
