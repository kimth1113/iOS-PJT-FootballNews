//
//  NewsTableViewCell.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import SnapKit

class NewsTableViewCell: BaseTableViewCell {
    
    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    override func configureUI() {

        backgroundColor = #colorLiteral(red: 0.09051452019, green: 0.09051452019, blue: 0.09051452019, alpha: 1)
        selectionStyle = .none
        
        [cellBackgroundView].forEach {
            addSubview($0)
        }
    }

    override func setConstraints() {
        
        cellBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(4)
            make.leading.equalTo(self).inset(8)
            make.trailing.equalTo(self)
        }
    }
    
    func designZeroToFourCell() {
        cellBackgroundView.backgroundColor = #colorLiteral(red: 0.03493923611, green: 0.03493923611, blue: 0.03493923611, alpha: 1)
        cellBackgroundView.layer.borderColor = #colorLiteral(red: 0.1250986427, green: 0.1250986427, blue: 0.1250986427, alpha: 1).cgColor
    }
    
    func designFiveToNineCell() {
        cellBackgroundView.backgroundColor = #colorLiteral(red: 0.06486742427, green: 0.06486742427, blue: 0.06486742427, alpha: 1)
        cellBackgroundView.layer.borderColor = #colorLiteral(red: 0.2214922664, green: 0.2214922664, blue: 0.2214922664, alpha: 1).cgColor
    }
}
