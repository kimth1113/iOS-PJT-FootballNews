//
//  NewsView.swift
//  FootballNews
//
//  Created by κΉνν on 2023/01/17.
//

import UIKit
import SnapKit

class NewsView: BaseView {
    
    let newsTableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 48
//        view.separatorStyle = .none
//        view.backgroundColor = .black
        return view
    }()
    
    override func configureUI() {
        
        [newsTableView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        newsTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
}
