//
//  Match.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import Foundation
import RxDataSources

struct Match {
    
    let categoryName: String
    let gameStartTime: String?
    let state: String?
    let homeTeamName: String?
    let awayTeamName: String?
    let homeTeamEmblem: String?
    let awayTeamEmblem: String?
    let homeTeamScore: String?
    let awayTeamScore: String?
    let homeTeamWon: String?
    let awayTeamWon: String?
}

struct MatchSection {
    
    var header: String
    var items: [Match]
    
    init(header: String, items: [Match]) {
        self.header = header
        self.items = items
    }
}

extension MatchSection: SectionModelType {
    
    init(original: MatchSection, items: [Match]) {
        self = original
        self.items = items
    }
}
