//
//  EndPoint.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import Foundation

enum FootballAPI {
    
    enum League: String {
        case EPL = "프리미어리그/순위/2kwbbcootiqqgmrzs6o5inle5"
        case LaLiGa = "프리메라리가/순위/34pl8szyvrbwcmfkuocjm3r6t"
        case Bundesliga = "분데스리가/순위/6by3h89i2eykc341oz7lv1ddd"
        case Serie = "세리에-a/순위/1r097lpxe0xn03ihb7wi98kao"
        case Ligue1 = "리그-1/순위/dm5ka0os1e3dxcp3vh05kmp33"
    }
    
    case newsBase
    case news(urlString: String)
    case rank(league: League)
    case plan(league: String, date: [String])
}

extension FootballAPI {
    
    var baseURLString: String {
        switch self {
        case .news:
            return "https://sports.news.naver.com"
        case .rank:
            return "https://www.goal.com/kr/"
        case .plan:
            return "https://sports.news.naver.com/wfootball/schedule/index?"
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
        case .rank(let league):
            let urlString = (baseURLString + league.rawValue).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return URL(string: urlString)!
        case .plan(let league, let date):
            let urlString = (baseURLString + "year=\(date[0])&month=\(date[1])&category=\(league)&date=\(date[0])\(date[1])\(date[2])")
            return URL(string: urlString)!
        }
    }
}
