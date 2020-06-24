//
//  AddCurrencyCell.swift
//  BTCRatesView
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import SnapKit

class AddCurrencyCell: UITableViewCell, CellInstantiable {
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkText
        return label
    }()
    
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { m in
            m.leading.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { m in
            m.leading.equalTo(codeLabel.snp.leading)
            m.top.equalTo(codeLabel.snp.bottom).offset(5)
            m.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
