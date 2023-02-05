//
//  RankCellView.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/24.
//

import UIKit
import SnapKit

class RankCellView: BaseView {
    
    let rankLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let playCntLabel: UILabel = {
        let view = UILabel()
        view.textColor = .systemGray
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let winCntLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let drawCntLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let lostCntLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let goalCalCntLabel: UILabel = {
        let view = UILabel()
        view.textColor = .systemGray
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    let scoreLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    override func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0.09584122475, green: 0.09584122475, blue: 0.09584122475, alpha: 1)
        
        [rankLabel, nameLabel, scoreLabel, playCntLabel, winCntLabel, drawCntLabel, lostCntLabel, goalCalCntLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        rankLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(14)
            make.leading.equalTo(self).offset(8)
            make.centerY.equalTo(self)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing)
            make.trailing.equalTo(playCntLabel.snp.leading)
            make.centerY.equalTo(self)
        }
        
        playCntLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(12)
            make.trailing.equalTo(winCntLabel.snp.leading)
            make.centerY.equalTo(self)
        }
        
        winCntLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(12)
            make.trailing.equalTo(drawCntLabel.snp.leading)
            make.centerY.equalTo(self)
        }
        
        drawCntLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(12)
            make.trailing.equalTo(lostCntLabel.snp.leading)
            make.centerY.equalTo(self)
        }
        
        lostCntLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(12)
            make.trailing.equalTo(goalCalCntLabel.snp.leading)
            make.centerY.equalTo(self)
        }
        
        goalCalCntLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(10)
            make.trailing.equalTo(scoreLabel.snp.leading)
            make.centerY.equalTo(self)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.width.equalTo(self).dividedBy(10)
            make.trailing.equalTo(self).inset(8)
            make.centerY.equalTo(self)
        }
        
    }
}
