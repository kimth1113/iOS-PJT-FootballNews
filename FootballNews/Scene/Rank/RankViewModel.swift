//
//  RankViewModel.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
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
                        let alert = UIAlertController(title: "앱 데이터 오류", message: "현재 앱 내부 데이터 오류가 발생하여 웹 페이지로 이동합니다.\n취소 버튼을 누르시면 앱이 종료됩니다.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default) { _ in
                            let safariViewController = SFSafariViewController(url: url)
                            vc.present(safariViewController, animated: true, completion: nil)
                        }
                        let cancel = UIAlertAction(title: "취소", style: .destructive) { _ in
                            exit(0)
                        }
                        alert.addAction(ok)
                        alert.addAction(cancel)
                        vc.present(alert, animated: true)
                    }
                    
                    rankList.onNext([
                        TeamRank(
                        rank: "99",
                        name: "데이터 오류",
                        score: "수",
                        playCnt: "긴",
                        winCnt: "급",
                        drawCnt: "조",
                        lostCnt: "치",
                        goalCalCnt: "착")
                    ])
                } else {
                    
                    rankList.onNext(newList)
                }
            } catch let error {
                DispatchQueue.main.sync {
        
                    let alert = UIAlertController(title: "인터넷 오류", message: "인터넷 통신에 오류가 발생하였습니다.\n잠시후 다시 시도해주십시오.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
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
