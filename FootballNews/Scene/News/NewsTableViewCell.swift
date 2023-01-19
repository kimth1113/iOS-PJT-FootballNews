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
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        return view
    }()
    
//    let title: UILabel = {
//        let view = UILabel()
//        view.text = "dldldldldl"
//        view.backgroundColor = .red
//        return view
//    }()
//
    override func configureUI() {

        selectionStyle = .none
        
        [cellBackgroundView].forEach {
            addSubview($0)
        }
    }

    override func setConstraints() {

//        title.snp.makeConstraints { make in
//            make.top.equalTo(self)
//        }
        
        cellBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(4)
            
        }

    }
    
}
