//
//  NewsTableViewCell.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import SnapKit

class NewsTableViewCell: UITableViewCell {
    
    let newsNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.text = "01"
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    let shadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        return view
    }()
    
    let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(shadowContainerView)
        shadowContainerView.addSubview(contentContainerView)
        [newsNumberLabel, titleLabel].forEach(contentContainerView.addSubview)
        
        shadowContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        newsNumberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.12)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(newsNumberLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with newsItem: News, at idx: Int) {
        titleLabel.text = newsItem.title
        // thumbnailImageView.image = // 이미지 로딩 로직 추가
        newsNumberLabel.text = String(idx + 1)
        
        if idx + 1 < 5 {
            newsNumberLabel.textColor = .systemRed
        } else if idx + 1 < 8 {
            newsNumberLabel.textColor = .systemBlue
        } else {
            newsNumberLabel.textColor = .systemGray
        }
    }
}
