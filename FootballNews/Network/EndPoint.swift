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
    case rank(league: League)
    case plan(league: String, date: [String])
}

extension FootballAPI {
    
    var baseURLString: String {
        switch self {
        case .news:
            return APIResouce.newsBase
        case .rank:
            return APIResouce.rankBase
        case .plan:
            return APIResouce.planBase
        default:
            return ""
        }
    }

    
    var url: URL {
        switch self {
        case .newsBase:
            return URL(string: "\(APIResouce.newsBase)/wfootball/index")!
        case .news(let urlString):
            return URL(string: baseURLString + urlString)!
        case .rank(let league):
            let urlString = (baseURLString + league.rawValue).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return URL(string: urlString)!
        case .plan(let league, let date):
            let urlString = (baseURLString + "date=\(date[0])\(date[1])\(date[2])")
            return URL(string: urlString)!
        }
    }
}
