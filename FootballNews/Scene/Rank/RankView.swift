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
        view.backgroundColor = .black
        view.selectedSegmentIndex = 0
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rankView: RankCellView = {
        let view = RankCellView()
        view.backgroundColor = #colorLiteral(red: 0.1131431502, green: 0.1131431502, blue: 0.1131431502, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        view.rankLabel.text = "순위"
        view.rankLabel.textColor = .white
        view.rankLabel.font = .systemFont(ofSize: 17)
        view.nameLabel.text = "팀"
        view.nameLabel.textColor = .white
        view.nameLabel.font = .systemFont(ofSize: 17)
        view.playCntLabel.text = "경기"
        view.playCntLabel.textColor = .white
        view.playCntLabel.font = .systemFont(ofSize: 17)
        view.winCntLabel.text = "승"
        view.winCntLabel.textColor = .white
        view.winCntLabel.font = .systemFont(ofSize: 17)
        view.drawCntLabel.text = "무"
        view.drawCntLabel.textColor = .white
        view.drawCntLabel.font = .systemFont(ofSize: 17)
        view.lostCntLabel.text = "패"
        view.lostCntLabel.textColor = .white
        view.lostCntLabel.font = .systemFont(ofSize: 17)
        view.goalCalCntLabel.text = "득실"
        view.goalCalCntLabel.textColor = .white
        view.goalCalCntLabel.font = .systemFont(ofSize: 17)
        view.scoreLabel.text = "승점"
        view.scoreLabel.textColor = .white
        view.scoreLabel.font = .systemFont(ofSize: 17)
        return view
    }()
    
    let rankTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .black
        return view
    }()
    
    override func configureUI() {
        
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
