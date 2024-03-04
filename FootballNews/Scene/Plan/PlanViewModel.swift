////
////  PlanViewModel.swift
////  FootballNews
////
////  Created by 김태현 on 2023/01/25.
////
//
//import UIKit
//import RxCocoa
//import RxDataSources
//import RxSwift
//import SwiftSoup
//
//class PlanViewModel {
//    
//    struct Input {
//        let rightBarButtonTap: ControlEvent<()>?
//        let leftBarButtonTap: ControlEvent<()>?
//    }
//    
//    struct Output {
//        let rightBarButtonTap: ControlEvent<()>?
//        let leftBarButtonTap: ControlEvent<()>?
//    }
//    
//    func trasform(input: Input) -> Output {
//        
//        return Output(rightBarButtonTap: input.rightBarButtonTap, leftBarButtonTap: input.leftBarButtonTap)
//    }
//    
//    var sections = BehaviorSubject(value: [
//        MatchSection(header: "프리미어리그", items: []),
//        MatchSection(header: "라리가", items: []),
//        MatchSection(header: "분데스리가", items: []),
//        MatchSection(header: "세리에A", items: []),
//        MatchSection(header: "리그앙", items: []),
//        MatchSection(header: "챔피언스리그", items: []),
//        MatchSection(header: "유로파리그", items: []),
//        MatchSection(header: "컨퍼런스리그", items: []),
//        MatchSection(header: "FA컵", items: []),
//        MatchSection(header: "EFL컵", items: []),
//        MatchSection(header: "코파델레이", items: [])
//    ])
//    
//    // 날짜 변경 시 마다 실행 (모든 리그 크롤링)
//    func getPlan(vc: UIViewController, date: [String]) {
//        
//        DispatchQueue.global().async { [self] in
//            
//            DispatchQueue.main.sync {
////                vc.view.makeToastActivity(.center)
//                vc.navigationItem.rightBarButtonItem?.isEnabled = false
//                vc.navigationItem.leftBarButtonItem?.isEnabled = false
//            }
//            
//            sections.onNext([
//                getLeaguePlan(league: "epl", date: date),
//                getLeaguePlan(league: "primera", date: date),
//                getLeaguePlan(league: "bundesliga", date: date),
//                getLeaguePlan(league: "seria", date: date),
//                getLeaguePlan(league: "ligue1", date: date),
//                getLeaguePlan(league: "champs", date: date),
//                getLeaguePlan(league: "europa", date: date),
//                getLeaguePlan(league: "uecl", date: date),
//                getLeaguePlan(league: "facup", date: date),
//                getLeaguePlan(league: "carlingcup", date: date),
//                getLeaguePlan(league: "copadelrey", date: date)
//            ])
//            
//            DispatchQueue.main.sync {
//                vc.navigationItem.rightBarButtonItem?.isEnabled = true
//                vc.navigationItem.leftBarButtonItem?.isEnabled = true
//            }
//        }
//    }
//    
//    private func getLeaguePlan(league: String, date: [String]) -> MatchSection {
//        
//        var header: String = ""
//        
//        switch league {
//            case "epl":
//                header = "프리미어리그"
//            case "primera":
//                header = "라리가"
//            case "bundesliga":
//                header = "분데스리가"
//            case "seria":
//                header = "세리에"
//            case "ligue1":
//                header = "리그앙"
//            case "champs":
//                header = "챔피언스리그"
//            case "europa":
//                header = "유로파리그"
//            case "uecl":
//                header = "컨퍼런스리그"
//            case "facup":
//                header = "FA"
//            case "carlingcup":
//                header = "EFL"
//            case "copadelrey":
//                header = "코파델레이"
//            default:
//                print("error!")
//        }
//
//        let url = FootballAPI.plan(league: league, date: date).url
//        
//        do {
//            
//            var section = MatchSection(header: header, items: [])
//            
//            let html = try String(contentsOf: url, encoding: .utf8)
//            let doc: Document = try SwiftSoup.parse(html)
//            
//            let tests: Elements = try doc.select("td")
//            
//            for test in tests.array() {
//                if [header].contains(try test.text())  {
//                    
//                    // 리그 카테고리
//                    let league = try test.select(".game").text()
//                    
//                    // 시각
//                    let time = try test.parent()!.select(".time").text()
//                    
//                    var gameList: [String] = []
//                    // 팀 vs 팀
//                    for t in try test.parent()!.select(".state") {
//                        gameList.append(try t.text())
//                    }
//
//                    let resultList: [[String]] = gameList.map { game in
//                        print(game)
//                        if game.contains(":") {
//                            // 정규 표현식을 사용하여 팀 이름과 점수를 분리합니다.
//                            let regex = try! NSRegularExpression(pattern: "([가-힣a-zA-Z ]+) (\\d) : (\\d) ([가-힣a-zA-Z ]+)")
//                            let matches = regex.matches(in: game, range: NSRange(game.startIndex..., in: game))
//                            
//                            var result: [String] = []
//                            if let match = matches.first, match.numberOfRanges == 5 {
//                                // 각 그룹(팀 이름과 점수)을 추출합니다.
//                                for rangeIndex in 1..<match.numberOfRanges {
//                                    let range = match.range(at: rangeIndex)
//                                    if let swiftRange = Range(range, in: game) {
//                                        let matchString = String(game[swiftRange])
//                                        result.append(matchString)
//                                    }
//                                }
//                            }
//                            return result
//                        } else {
//                            // ":"를 기준으로 점수 부분과 팀 이름을 분리합니다.
//                            let parts = game.components(separatedBy: " vs ")
//                            // 분리된 부분들을 배열로 재구성합니다.
//                            var result: [String] = []
//                            for part in parts {
//                                result.append(part)
//                                result.append("")
//                                result.append("")
//                            }
//                            return result
//                        }
//                    }
//                    
//                    var stateList: [String] = []
//                    // 경기 상태
//                    for t in try test.siblingElements().select("img") {
//                        if try t.attr("alt") != "worldfootball" {
//                            
//                            if try t.attr("alt") == "result" {
//                                
//                            }
//                            
//                            stateList.append(try t.attr("alt"))
//                        }
//                    }
//                    
//                    for i in 0 ..< gameList.count {
//                        
//                        var homeWon: String? = nil
//                        var awayWon: String? = nil
//                        
//                        if resultList[i][1] != "" {
//                            if resultList[i][1] > resultList[i][3] {
//                                homeWon = "win"
//                                awayWon = "lose"
//                            } else if resultList[i][1] == resultList[i][3] {
//                                homeWon = "draw"
//                                awayWon = "draw"
//                            } else {
//                                homeWon = "lose"
//                                awayWon = "win"
//                            }
//                        }
//                        print(resultList)
//                        let match = Match(
//                            categoryName: league,
//                            gameStartTime: time,
//                            state: stateList[i],
//                            homeTeamName: resultList[i][0],
//                            awayTeamName: resultList[i][3],
//                            homeTeamScore: resultList[i][1],
//                            awayTeamScore: resultList[i][2],
//                            homeTeamWon: homeWon,
//                            awayTeamWon: awayWon
//                        )
//                        
//                        section.items.append(match)
//                    }
//                }
//            }
//            
//            return section
//
//        } catch let error {
//            print("error: ---- \(error)")
//        }
//        
//        return MatchSection(header: header, items: [])
//    }
//}
