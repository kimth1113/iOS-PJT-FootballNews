//
//  NewsViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import RxAlamofire
//import RxDataSources
import RxCocoa
import RxSwift
import SwiftSoup
import SafariServices

class NewsViewController: BaseViewController {
    
    let mainView = NewsView()
    let disposeBag = DisposeBag()
    
    let newsList = PublishSubject<[News]>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "뉴스"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        newsTableConfigure()
        getNews()
        
    }
    
    func newsTableConfigure() {
        mainView.newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
        
        newsList.bind(to: mainView.newsTableView.rx.items(cellIdentifier: NewsTableViewCell.reuseIdentifier, cellType: NewsTableViewCell.self)) { (row, element, cell) in
            
            cell.textLabel?.text = element.title
        }
        .disposed(by: disposeBag)
        
        mainView.newsTableView.rx.modelSelected(News.self)
            .subscribe { news in
                
                let safariViewController = SFSafariViewController(url: news.url)
                self.present(safariViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

    }
        
    func getNews() {
        
        let url = "https://sports.news.naver.com/wfootball/index"
        
        guard let url = URL(string: url) else { return }
            do {
                
                let html = try String(contentsOf: url, encoding: .utf8)
                
                let doc: Document = try SwiftSoup.parse(html)
                
                let newsInfoList: Elements = try doc
                    .select(".home_news_list")
                    .select("a")
                
                var list: [News] = []
                    
                for element in newsInfoList.array() {
                    let title = try element.select("span").text()
                    let urlString = "https://sports.news.naver.com" + (try element.attr("href").description)
                    
                    list.append(News(title: title, url: URL(string: urlString)!))
                }
                
                newsList.onNext(list)
//                carLabel.text = try title.text() // UI 세팅
                
            } catch let error {
                print("error: ---- \(error)")
            }
        
        
        
        
        
//        request(.get, url, headers: ["Authorization": APIKey.authorization])
//            .data()
//            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
//            .subscribe(onNext: { value in
//                print(value.results[0].likes)
//            })
//            .disposed(by: disposeBag)
    }
}
