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
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let select: ControlEvent<News>
    }
    
    struct Output {
        let select: ControlEvent<News>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(select: input.select)
    }
    
    func getNews() {
        
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
                    let urlString = "https://sports.news.naver.com" + (try element.attr("href").description)
                    list.append(News(title: title, url: URL(string: urlString)!))
                }
                
                newsList.onNext(list)
                
            } catch let error {
                print("error: ---- \(error)")
            }
    }
}
