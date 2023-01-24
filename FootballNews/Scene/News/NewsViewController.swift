//
//  NewsViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices

class NewsViewController: BaseViewController {
    
    let mainView = NewsView()
    
    let viewModel = NewsViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "뉴스"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        bind()
        newsTableViewConfigure()
        viewModel.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func bind() {
        
        let input = NewsViewModel.Input(selectCell: mainView.newsTableView.rx.modelSelected(News.self))
        let output = viewModel.transform(input: input)
        
        viewModel.newsList
            .bind(to: mainView.newsTableView.rx.items(cellIdentifier: NewsTableViewCell.reuseIdentifier, cellType: NewsTableViewCell.self)) { (row, element, cell) in
            
                cell.textLabel?.text = element.title
            }
            .disposed(by: disposeBag)
        
        output.selectCell
            .withUnretained(self)
            .subscribe { (vc, news) in
                let safariViewController = SFSafariViewController(url: news.url)
                vc.present(safariViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    func newsTableViewConfigure() {
        mainView.newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
    }
        
}
