//
//  BaseView.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error was caused at BaseView.")
    }
    
    func configureUI() { }
    func setConstraint() { }
}
