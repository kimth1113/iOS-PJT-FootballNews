//
//  RankTableViewCell.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/24.
//

import UIKit
import SnapKit

class RankTableViewCell: BaseTableViewCell {
    
    let rankCellView: RankCellView = {
        let view = RankCellView()
        
        return view
    }()
    
    
    override func configureUI() {
        
        selectionStyle = .none
        
        [rankCellView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        rankCellView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
