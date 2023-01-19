//
//  Rank.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import UIKit
import RxCocoa

import RxSwift

class RankViewController: BaseViewController {
    
    
    let mainView = RankView()
    let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "리그순위"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
    }
    
}
