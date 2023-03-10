//
//  RankViewModel.swift
//  FootballNews
//
//  Created by κΉνν on 2023/01/20.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftSoup
import SafariServices

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
    
    func getRank(vc: UIViewController, league: FootballAPI.League) {
        
        DispatchQueue.global().async { [self] in
            
            DispatchQueue.main.sync {
    
                vc.view.makeToastActivity(.center)
                vc.view.isUserInteractionEnabled = false
            }
            
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
                
                if newList.count == 0 {
                    DispatchQueue.main.sync {
                        let alert = UIAlertController(title: "μ± λ°μ΄ν° μ€λ₯", message: "νμ¬ μ± λ΄λΆ λ°μ΄ν° μ€λ₯κ° λ°μνμ¬ μΉ νμ΄μ§λ‘ μ΄λν©λλ€.\nμ·¨μ λ²νΌμ λλ₯΄μλ©΄ μ±μ΄ μ’λ£λ©λλ€.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "νμΈ", style: .default) { _ in
                            let safariViewController = SFSafariViewController(url: url)
                            vc.present(safariViewController, animated: true, completion: nil)
                        }
                        let cancel = UIAlertAction(title: "μ·¨μ", style: .destructive) { _ in
                            exit(0)
                        }
                        alert.addAction(ok)
                        alert.addAction(cancel)
                        vc.present(alert, animated: true)
                    }
                    
                    rankList.onNext([
                        TeamRank(
                        rank: "99",
                        name: "λ°μ΄ν° μ€λ₯",
                        score: "μ",
                        playCnt: "κΈ΄",
                        winCnt: "κΈ",
                        drawCnt: "μ‘°",
                        lostCnt: "μΉ",
                        goalCalCnt: "μ°©")
                    ])
                } else {
                    
                    rankList.onNext(newList)
                }
            } catch let error {
                DispatchQueue.main.sync {
        
                    let alert = UIAlertController(title: "μΈν°λ· μ€λ₯", message: "μΈν°λ· ν΅μ μ μ€λ₯κ° λ°μνμμ΅λλ€.\nμ μν λ€μ μλν΄μ£Όμ­μμ€.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "νμΈ", style: .default)
                    alert.addAction(ok)
                    vc.present(alert, animated: true)
                }
            }
            
            DispatchQueue.main.sync {
    
                vc.view.hideToastActivity()
                vc.view.isUserInteractionEnabled = true
            }
        }
        
    }
}
