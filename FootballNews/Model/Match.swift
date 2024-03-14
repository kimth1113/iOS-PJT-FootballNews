//
//  Match.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import Foundation

struct Match {
    
    var categoryName: String = "경기없음"
    let gameStartTime: String?
    let state: String?
    let homeTeamName: String?
    let awayTeamName: String?
    let homeTeamScore: String?
    let awayTeamScore: String?
    let homeTeamWon: String?
    let awayTeamWon: String?
    let detailUrl: String?
}

struct MatchSection {
    
    var header: String
    var items: [Match]
    
    init(header: String, items: [Match]) {
        self.header = header
        self.items = items
    }
}
