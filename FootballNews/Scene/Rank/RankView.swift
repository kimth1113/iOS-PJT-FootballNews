//
//  RankView.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import UIKit
import SnapKit

class RankView: BaseView {
    
    let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["EPL", "라리가", "분데스리가", "세리에A", "리그앙"])
        view.backgroundColor = .red
        
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rankTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func configureUI() {
        [segmentedControl, rankTableView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        
        rankTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
