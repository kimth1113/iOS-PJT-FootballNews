//
//  NewsViewModel.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftSoup
import Toast

class NewsViewModel {
    
    let newsList = PublishSubject<[News]>()
    
    struct Input {
        let selectCell: ControlEvent<News>
    }
    
    struct Output {
        let selectCell: ControlEvent<News>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(selectCell: input.selectCell)
    }
    
    func getNews(vc: UIViewController) {
        
        DispatchQueue.global().async { [self] in
            
            DispatchQueue.main.sync {
    
                vc.view.makeToastActivity(.center)
            }
            
            let url = FootballAPI.newsBase.url
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html)
                
                let newsInfoList: Elements = try doc
                    .select(".home_news_list")
                    .select("a")
                
                var list: [News] = []
                for element in newsInfoList.array() {
                    let title = try element.select("span").text()
                    let url = FootballAPI.news(urlString: try element.attr("href").description).url
                    list.append(News(title: title, url: url))
                }
                
                newsList.onNext(list)
                
            } catch let error {
                DispatchQueue.main.sync {
        
                    let alert = UIAlertController(title: "인터넷 오류", message: "인터넷 통신에 오류가 발생하였습니다.\n잠시후 다시 시도해주십시오.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    vc.present(alert, animated: true)
                }
            }
            
            DispatchQueue.main.sync {
    
                vc.view.hideToastActivity()
            }
        }
    }
}
