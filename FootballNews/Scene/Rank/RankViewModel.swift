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

// JSON 전체 구조를 담을 수 있는 최상위 모델
struct FootballTeamRecords: Codable {
    let jsonTeamRecord: TeamRecordList
}

// 팀 레코드 리스트를 담을 모델
struct TeamRecordList: Codable {
    let regularTeamRecordList: [TeamRecord]
}

// 개별 팀 레코드 정보를 담을 모델
struct TeamRecord: Codable {
    let teamName: String
    let gameCount: Int
    let gainPoint: Int
    let won: Int
    let drawn: Int
    let lost: Int
    let gainGoal: Int
    let loseGoal: Int
    let goalGap: Int
    let rank: Int
}

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
//            let url: URL = URL(string: "https://sports.news.naver.com/wfootball/record/index")!
            do {
                
                var newList: [TeamRank] = []
                
                let html = try String(contentsOf: url, encoding: .utf8)
                // HTML 문서를 파싱
                let doc: Document = try SwiftSoup.parse(html)
                
                let scriptContent = try doc.select("script[type=text/javascript]").array().first(where: { try $0.html().contains("var wfootballTeamRecord =") })
                
                
                let scriptHtml = try scriptContent?.html()
                        
                let startText = "jsonTeamRecord: "
                let endText = "},\n        sortedTeamRecord:"
                
                if let startRange = scriptHtml?.range(of: startText),
                   let endRange = scriptHtml?.range(of: endText, range: startRange.upperBound..<scriptHtml!.endIndex) {
                    let jsonStartIndex = startRange.upperBound
                    let jsonEndIndex = endRange.lowerBound
                    
                    let jsonString = String(scriptHtml![jsonStartIndex..<jsonEndIndex]) + "}"
                    
                    // jsonString을 Data 객체로 변환
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            // jsonData를 딕셔너리로 파싱
                            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                               let regularTeamRecordList = jsonDict["regularTeamRecordList"] as? [[String: Any]] {
                                // 여기서 regularTeamRecordList 배열을 사용할 수 있습니다.
                                
                                
                                print(regularTeamRecordList)
                                // 예시: 각 팀의 이름을 출력
                                for idx in 0..<regularTeamRecordList.count {
                                    let name = regularTeamRecordList[idx]["teamName"] as? String
                                    let score = regularTeamRecordList[idx]["gainPoint"] as? Int
                                    let playCnt = regularTeamRecordList[idx]["gameCount"] as? Int
                                    let winCnt = regularTeamRecordList[idx]["won"] as? Int
                                    let drawCnt = regularTeamRecordList[idx]["drawn"] as? Int
                                    let lostCnt = regularTeamRecordList[idx]["lost"] as? Int
                                    let goalCalCnt = regularTeamRecordList[idx]["goalGap"] as? Int
                                    
                                    let team = TeamRank(
                                        rank: String(idx+1),
                                        name: name!,
                                        score: String(score!),
                                        playCnt: String(playCnt!),
                                        winCnt: String(winCnt!),
                                        drawCnt: String(drawCnt!),
                                        lostCnt: String(lostCnt!),
                                        goalCalCnt: String(goalCalCnt!)
                                    )
                                    
                                    newList.append(team)
                                    
                                }
                            }
                        } catch {
                            print("JSON 파싱 실패: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("JSON 부분을 추출할 수 없습니다.")
                }
                
                if newList.count == 0 {
                    DispatchQueue.main.sync {
                        let alert = UIAlertController(title: "앱 데이터 오류", message: "현재 앱 내부 데이터 오류가 발생하여 웹 페이지로 이동합니다.\n취소 버튼을 누르시면 앱이 종료됩니다.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default) { _ in
                            let safariViewController = SFSafariViewController(url: url)
                            vc.present(safariViewController, animated: true, completion: nil)
                        }
                        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
//                            exit(0)
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
