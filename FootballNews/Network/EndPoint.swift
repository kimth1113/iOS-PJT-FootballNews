//
//  EndPoint.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import Foundation

enum FootballAPI {
    
    case newsBase
    case news(urlString: String)
}

extension FootballAPI {
    
    var baseURLString: String {
        switch self {
        case .news:
            return "https://sports.news.naver.com"
        default:
            return ""
        }
    }
    
    var url: URL {
        switch self {
        case .newsBase:
            return URL(string: "https://sports.news.naver.com/wfootball/index")!
        case .news(let urlString):
            return URL(string: baseURLString + urlString)!
        }
    }
}
