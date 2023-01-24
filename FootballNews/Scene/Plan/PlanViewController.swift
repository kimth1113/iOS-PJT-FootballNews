//
//  PlanViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftSoup
import SwiftyJSON

class PlanViewController: BaseViewController {
    
    let mainView = PlanView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRank()
        designNavigationBar()
    }
    
    private func designNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        
        navigationItem.title = formatter.string(from: Date())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음날")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전날")
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let pre = formatter.date(from: vc.navigationItem.title!)
                let now = Calendar.current.date(byAdding: .day, value: 1, to: pre!)
                vc.navigationItem.title = formatter.string(from: now!)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let pre = formatter.date(from: vc.navigationItem.title!)
                let now = Calendar.current.date(byAdding: .day, value: -1, to: pre!)
                vc.navigationItem.title = formatter.string(from: now!)
            }
            .disposed(by: disposeBag)
        
    }
    
    func getRank() {
        
        DispatchQueue.global().async { [self] in

            let url = URL(string: "https://sports.news.naver.com/wfootball/schedule/index?year=2023&month=05&category=epl&date=20230507")!
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html)
                
                let scriptTags = try! doc.select("script")
                var jsonString: String?
                for tag: Element in scriptTags {
                    for  node : DataNode in tag.dataNodes() {
                        let myText = node.getWholeData()
//                        print (node.getWholeData())
                        let p = Pattern.compile("\\[(.*?)\\]")
                        let m: Matcher = p.matcher(in: myText)
                        while( m.find() )
                        {
                            let json = m.group()
                            if json!.contains("2023-05-07") {
                                jsonString = json
                                break
                            }
                        }
                    }
                }
                
//                print(jsonString)
                var stringArray = ""
                for word in jsonString ?? "" {
                    if word == "{" {
                        stringArray = ""
                        stringArray += String(word)
                    } else if word == "}" {
                        stringArray += String(word)
//                        print(stringArray)

                        var dicData : Dictionary<String, Any> = [String : Any]()
                        do {
                            // 딕셔너리에 데이터 저장 실시
                            dicData = try JSONSerialization.jsonObject(with: Data(stringArray.utf8), options: []) as! [String:Any]
                        } catch {
                            print(error.localizedDescription)
                        }

                        print(dicData["homeTeamName"]!, "vs", dicData["awayTeamName"]!)
                    } else if word != "[" && word != "]" {
                        stringArray += String(word)
                    }
                }
                
                

            } catch let error {
                print("error: ---- \(error)")
            }
        }
    }
}
