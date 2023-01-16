//
//  NewsViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit

class NewsViewController: UIViewController {

    let mainView = NewsView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        mainView.newsTableView.backgroundColor = .orange
    }
    
}
