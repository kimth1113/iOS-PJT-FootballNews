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
        view.selectedSegmentIndex = 0
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rankView: RankCellView = {
        let view = RankCellView()
        view.rankLabel.text = "순위"
        view.nameLabel.text = "팀"
        view.playCntLabel.text = "경기"
        view.winCntLabel.text = "승"
        view.drawCntLabel.text = "무"
        view.lostCntLabel.text = "패"
        view.goalCalCntLabel.text = "득실"
        view.scoreLabel.text = "승점"
        return view
    }()
    
    let rankTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        return view
    }()
    
    override func configureUI() {
        rankView.backgroundColor = .green
        
        [segmentedControl, rankView, rankTableView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        
        rankView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.leading.trailing.equalTo(self)
        }
        
        rankTableView.snp.makeConstraints { make in
            make.top.equalTo(rankView.snp.bottom)
            make.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
