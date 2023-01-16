//
//  BaseTableViewCell.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error was caused in BaseTableViewCell.")
    }
    
    func configureUI() { }
    func setConstraints() { }
}
