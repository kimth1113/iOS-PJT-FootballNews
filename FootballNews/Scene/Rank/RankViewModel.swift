//
//  RankViewModel.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftSoup

class RankViewModel {
    
    let rankList = PublishSubject<[TeamRank]>()
    
    struct Input {
        let selectSegment: ControlProperty<Int>
    }
    
    struct Output {
        let selectSegment: ControlProperty<Int>
    }
    
    func transForm(input: Input) -> Output {
        return Output(selectSegment: input.selectSegment)
    }
    
    func getRank(league: FootballAPI.League) {
        
        DispatchQueue.global().async { [self] in
            
            let url = FootballAPI.rank(league: league).url
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html)
                
                let teamNameList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__team--full-name")
                
                let playCntList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__matches-played")
                
                let scoreList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__pts")
                
                let winCntList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__matches-won")
                
                let drawCntList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__matches-drawn")
                
                let lostCntList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__matches-lost")
                
                let goalCalList: Elements = try doc
                    .select("tbody")
                    .select(".widget-match-standings__goals-diff")
                
                var newList: [TeamRank] = []
                for idx in 0..<teamNameList.array().count {
                    
                    let team = TeamRank(
                        rank: String(idx+1),
                        name: try teamNameList.array()[idx].text(),
                        score: try scoreList.array()[idx].text(),
                        playCnt: try playCntList.array()[idx].text(),
                        winCnt: try winCntList.array()[idx].text(),
                        drawCnt: try drawCntList.array()[idx].text(),
                        lostCnt: try lostCntList.array()[idx].text(),
                        goalCalCnt: try goalCalList.array()[idx].text()
                    )
                    
                    newList.append(team)
                }
                
                rankList.onNext(newList)
                
            } catch let error {
                print("error: ---- \(error)")
            }
        }
        
    }
}
