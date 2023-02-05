//
//  CupView.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import UIKit
import SnapKit

class CupView: BaseView {
    
    let cupTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    override func configureUI() {
        [cupTableView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        cupTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
