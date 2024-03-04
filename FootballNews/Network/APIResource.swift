//
//  APIResouce.swift
//  FootballNews
//
//  Created by 김태현 on 2023/02/06.
//

import Foundation

enum APIResouce {
    static let adUnitID = "ca-app-pub-4215883051450022/3064379478"
    
    static let newsBase = "https://sports.news.naver.com"
//    static let rankBase = "https://www.goal.com/kr/"
    static let rankBase = "https://sports.news.naver.com/wfootball/record/index"
    static let planBase = "https://sports.news.naver.com/scoreboard/index?"
    
    static let EuroSite = "https://www.uefa.com/euro2024/"
    static let CopaAmericaSite = "https://www.conmebol.com/"
    static let AfricaNationsSite = "https://www.cafonline.com/"
    static let NorthAmericaSite = "https://www.concacaf.com/"
    static let OFCNationsSite = "https://www.oceaniafootball.com/"
    static let AsiaSite = "https://www.the-afc.com/en/home.html"
    static let EastAsiaSite = "https://eaff.com/index_k.html"
}

extension FootballAPI {
    
    enum League: String {
        case EPL = "?category=epl&tab=team"
        case LaLiGa = "?category=primera&tab=team"
        case Bundesliga = "?category=bundesliga&tab=team"
        case Serie = "?category=seria&tab=team"
        case Ligue1 = "?category=ligue1&tab=team"
    }
}
