//
//  NewsViewModel.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftSoup

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
    
    func getNews() {
        
        DispatchQueue.global().async { [self] in
            
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
                print("error: ---- \(error)")
            }
        }
        
    }
}
