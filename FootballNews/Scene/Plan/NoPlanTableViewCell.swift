//
//  NoPlanTableViewCell.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/27.
//

import UIKit
import SnapKit

class NoPlanTableViewCell: BaseTableViewCell {
    
    let noPlanLabel: UILabel = {
        let view = UILabel()
        view.text = "경기가 없습니다."
        view.font = .boldSystemFont(ofSize: 17)
        view.textColor = .darkGray
        return view
    }()
   
    
    override func configureUI() {
        selectionStyle = .none
        
        [noPlanLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
       
        noPlanLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(32)
            make.centerY.equalTo(self)
        }
    }
}
