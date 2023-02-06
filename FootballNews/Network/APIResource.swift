//
//  APIResouce.swift
//  FootballNews
//
//  Created by 김태현 on 2023/02/06.
//

import Foundation

enum APIResouce {
    static let adUnitID = "ca-app-pub-2896374758725729/7337305637"
    
    static let newsBase = "https://sports.news.naver.com"
    static let rankBase = "https://www.goal.com/kr/"
    static let planBase = "https://sports.news.naver.com/wfootball/schedule/index?"
    
    static let EuroSite = "https://www.uefa.com/uefaeuro/history/seasons/2020/matches/"
    static let CopaAmericaSite = "https://www.sportingnews.com/us/soccer/news/copa-america-bracket-2021-tv-schedule-channel-stream-watch/xehy346ajvt71js2fpgzn5bxo"
    static let AfricaNationsSite = "https://www.cafonline.com/total-africa-cup-of-nations/matches/"
    static let NorthAmericaSite = "https://www.ussoccer.com/competitions/concacaf-gold-cup-2019"
    static let OFCNationsSite = "https://www.oceaniafootball.com/competition/fifa-world-cup-qatar-2022-qualifiers/"
    static let AsiaSite = "https://www.the-afc.com/en/national/afc_asian_cup/fixtures__standings.html"
    static let EastAsiaSite = "https://eaff.com/competitions/eaff2022/result794_k.html"
}

extension FootballAPI {
    
    enum League: String {
        case EPL = "프리미어리그/순위/2kwbbcootiqqgmrzs6o5inle5"
        case LaLiGa = "프리메라리가/순위/34pl8szyvrbwcmfkuocjm3r6t"
        case Bundesliga = "분데스리가/순위/6by3h89i2eykc341oz7lv1ddd"
        case Serie = "세리에-a/순위/1r097lpxe0xn03ihb7wi98kao"
        case Ligue1 = "리그-1/순위/dm5ka0os1e3dxcp3vh05kmp33"
    }
}
