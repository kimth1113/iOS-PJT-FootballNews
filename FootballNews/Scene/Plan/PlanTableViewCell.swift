//
//  PlanTableViewCell.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/26.
//

import UIKit
import SnapKit

class PlanTableViewCell: BaseTableViewCell {
    
    let gameStartTimeLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 28)
        return view
    }()
    
    let stateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 14)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    let derbyImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let homeTeamNameLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    
    let awayTeamNameLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    
    let homeTeamScoreLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    let awayTeamScoreLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    let homeLabel: UILabel = {
        let view = UILabel()
        view.text = "홈"
        return view
    }()
    
    let awayLabel: UILabel = {
        let view = UILabel()
        view.text = "어웨이"
        return view
    }()
    
    override func configureUI() {
        selectionStyle = .none
        
        [gameStartTimeLabel, stateLabel, derbyImageView, homeTeamNameLabel, awayTeamNameLabel, homeTeamScoreLabel, awayTeamScoreLabel, homeLabel, awayLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        gameStartTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(32)
            make.top.equalTo(self).offset(4)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(gameStartTimeLabel.snp.bottom)
            make.leading.trailing.equalTo(gameStartTimeLabel).inset(4)
        }
        
        derbyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(gameStartTimeLabel).offset(8)
            make.leading.equalTo(gameStartTimeLabel.snp.trailing).offset(12)
        }
        
        homeTeamNameLabel.snp.makeConstraints { make in
            make.top.equalTo(gameStartTimeLabel).offset(4)
            make.leading.equalTo(derbyImageView.snp.trailing).offset(16)
            make.trailing.equalTo(homeTeamScoreLabel.snp.leading).offset(-8)
        }
        
        awayTeamNameLabel.snp.makeConstraints { make in
            make.top.equalTo(homeTeamNameLabel.snp.bottom).offset(12)
            make.leading.equalTo(derbyImageView.snp.trailing).offset(16)
            make.bottom.equalTo(self).inset(12)
            make.trailing.equalTo(awayTeamScoreLabel.snp.leading).offset(-8)
        }
        
        homeTeamScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(homeTeamNameLabel)
            make.trailing.equalTo(self).inset(32)
        }
        
        awayTeamScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(awayTeamNameLabel)
            make.trailing.equalTo(self).inset(32)
        }
    }
}
