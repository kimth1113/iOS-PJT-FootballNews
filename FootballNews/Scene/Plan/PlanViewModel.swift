//
//  PlanViewModel.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift
import SwiftSoup

class PlanViewModel {
    
    struct Input {
        let rightBarButtonTap: ControlEvent<()>?
        let leftBarButtonTap: ControlEvent<()>?
    }
    
    struct Output {
        let rightBarButtonTap: ControlEvent<()>?
        let leftBarButtonTap: ControlEvent<()>?
    }
    
    func trasform(input: Input) -> Output {
        
        return Output(rightBarButtonTap: input.rightBarButtonTap, leftBarButtonTap: input.leftBarButtonTap)
    }
    
    var sections = BehaviorSubject(value: [
        MatchSection(header: "프리미어리그", items: []),
        MatchSection(header: "라리가", items: []),
        MatchSection(header: "분데스리가", items: []),
        MatchSection(header: "세리에A", items: []),
        MatchSection(header: "리그앙", items: []),
        MatchSection(header: "챔피언스리그", items: []),
        MatchSection(header: "유로파리그", items: []),
        MatchSection(header: "컨퍼런스리그", items: []),
        MatchSection(header: "FA컵", items: []),
        MatchSection(header: "EFL컵", items: []),
        MatchSection(header: "코파델레이", items: [])
    ])
    
    // 날짜 변경 시 마다 실행 (모든 리그 크롤링)
    func getPlan(vc: UIViewController, date: [String]) {
        
        DispatchQueue.global().async { [self] in
            
            DispatchQueue.main.sync {
                vc.view.makeToastActivity(.center)
                vc.navigationItem.rightBarButtonItem?.isEnabled = false
                vc.navigationItem.leftBarButtonItem?.isEnabled = false
            }
            
            sections.onNext([
                getLeaguePlan(league: "epl", date: date),
                getLeaguePlan(league: "primera", date: date),
                getLeaguePlan(league: "bundesliga", date: date),
                getLeaguePlan(league: "seria", date: date),
                getLeaguePlan(league: "ligue1", date: date),
                getLeaguePlan(league: "champs", date: date),
                getLeaguePlan(league: "europa", date: date),
                getLeaguePlan(league: "uecl", date: date),
                getLeaguePlan(league: "facup", date: date),
                getLeaguePlan(league: "carlingcup", date: date),
                getLeaguePlan(league: "copadelrey", date: date)
            ])
            
            DispatchQueue.main.sync {
                vc.view.hideToastActivity()
                vc.navigationItem.rightBarButtonItem?.isEnabled = true
                vc.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    
    private func getLeaguePlan(league: String, date: [String]) -> MatchSection {
        
        var header: String = ""
        switch league {
            case "epl":
                header = "프리미어리그"
            case "primera":
                header = "라리가"
            case "bundesliga":
                header = "분데스리가"
            case "seria":
                header = "세리에"
            case "ligue1":
                header = "리그앙"
            case "champs":
                header = "챔피언스리그"
            case "europa":
                header = "유로파리그"
            case "uecl":
                header = "컨퍼런스리그"
            case "facup":
                header = "FA"
            case "carlingcup":
                header = "EFL"
            case "copadelrey":
                header = "코파델레이"
            default:
                print("error!")
        }

        let url = FootballAPI.plan(league: league, date: date).url
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            
            let scriptTags = try! doc.select("script")
            var jsonString: String?
            for tag: Element in scriptTags {
                for  node : DataNode in tag.dataNodes() {
                    let myText = node.getWholeData()
                    let p = Pattern.compile("\\[(.*?)\\]")
                    let m: Matcher = p.matcher(in: myText)
                    while( m.find() )
                    {
                        let json = m.group()
                        if json!.contains("\(date[0])-\(date[1])-\(date[2])") {
                            jsonString = json
                            break
                        }
                    }
                }
            }
            
            var dicData : Dictionary<String, Any> = [String : Any]()
            
            guard let jsonString = jsonString else {
                let match = Match(categoryName: "경기없음", gameStartTime: nil, state: nil, homeTeamName: nil, awayTeamName: nil, homeTeamEmblem: nil, awayTeamEmblem: nil, homeTeamScore: nil, awayTeamScore: nil, homeTeamWon: nil, awayTeamWon: nil)
                
                return MatchSection(header: header, items: [match])
            }
            
            var stringArray = ""
            var section = MatchSection(header: header, items: [])
            for word in jsonString {
                if word == "{" {
                    stringArray = ""
                    stringArray += String(word)
                } else if word == "}" {
                    stringArray += String(word)
                    
                    do {
                        // 딕셔너리에 데이터 저장 실시
                        dicData = try JSONSerialization.jsonObject(with: Data(stringArray.utf8), options: []) as! [String:Any]
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    let match = Match(
                        categoryName: dicData["categoryName"] as! String,
                        gameStartTime: dicData["gameStartTime"] as? String,
                        state: dicData["state"] as? String,
                        homeTeamName: dicData["homeTeamName"] as? String,
                        awayTeamName: dicData["awayTeamName"] as? String,
                        homeTeamEmblem: dicData["homeTeamEmblem64URI"] as? String,
                        awayTeamEmblem: dicData["awayTeamEmblem64URI"] as? String,
                        homeTeamScore: dicData["homeTeamScore"] as? String,
                        awayTeamScore: dicData["awayTeamScore"] as? String,
                        homeTeamWon: dicData["homeTeamWon"] as? String,
                        awayTeamWon: dicData["awayTeamWon"] as? String
                    )
                    
                    section.items.append(match)
                } else if word != "[" && word != "]" {
                    stringArray += String(word)
                }
            }
            
            return section

        } catch let error {
            print("error: ---- \(error)")
        }
        
        return MatchSection(header: header, items: [])
    }
}
