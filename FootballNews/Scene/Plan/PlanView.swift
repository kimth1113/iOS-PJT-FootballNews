//
//  PlanView.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/24.
//

import UIKit
import SnapKit

class PlanView: BaseView {
    
    let planTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    override func configureUI() {
        
        [planTableView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        planTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

