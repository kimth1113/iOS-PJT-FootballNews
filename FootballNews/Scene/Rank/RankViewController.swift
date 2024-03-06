//
//  Rank.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import UIKit
import SwiftSoup
import SafariServices
import GoogleMobileAds

class RankViewController: BaseViewController {
    
    let mainView = RankView()
    var rankList: [TeamRank] = [] {
        didSet {
            self.mainView.rankTableView.reloadData()
        }
    }
    
    var bannerView: GADBannerView!
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBannerView()
        
        navigationItem.title = "5대 리그"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        setupView()
        setupSegmentedControl()
        fetchRank(forLeague: .EPL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.08201111469, green: 0.08201111469, blue: 0.08201111469, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupView() {
        // Configure your view and tableView here
        mainView.rankTableView.delegate = self
        mainView.rankTableView.dataSource = self
        mainView.rankTableView.register(RankTableViewCell.self, forCellReuseIdentifier: RankTableViewCell.reuseIdentifier)
    }
    
    func setupSegmentedControl() {
        mainView.segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    func setBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        bannerView.adUnitID = APIResouce.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }
    
    @objc 
    func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fetchRank(forLeague: .EPL)
        case 1:
            fetchRank(forLeague: .LaLiGa)
        case 2:
            fetchRank(forLeague: .Bundesliga)
        case 3:
            fetchRank(forLeague: .Serie)
        case 4:
            fetchRank(forLeague: .Ligue1)
        // Add other cases
        default:
            print("League selection error")
        }
    }
    
    func fetchRank(forLeague league: FootballAPI.League) {
        getRank(league: league)
        self.mainView.rankTableView.reloadData()
    }
    
    
    func getRank(league: FootballAPI.League) {
        DispatchQueue.global().async { [self] in
            
            let url = FootballAPI.rank(league: league).url

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
                
                DispatchQueue.main.async {
                    self.rankList = newList
                }
                
            } catch let error {
                DispatchQueue.main.sync {
        
                    let alert = UIAlertController(title: "인터넷 오류", message: "인터넷 통신에 오류가 발생하였습니다.\n잠시후 다시 시도해주십시오.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    present(alert, animated: true)
                }
            }
        }
        
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

    


extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.reuseIdentifier, for: indexPath) as? RankTableViewCell else {
                    return UITableViewCell()
                }
        let element = rankList[indexPath.row]
        cell.rankCellView.rankLabel.text = element.rank
        cell.rankCellView.nameLabel.text = element.name
        cell.rankCellView.scoreLabel.text = element.score
        cell.rankCellView.playCntLabel.text = element.playCnt
        cell.rankCellView.winCntLabel.text = element.winCnt
        cell.rankCellView.drawCntLabel.text = element.drawCnt
        cell.rankCellView.lostCntLabel.text = element.lostCnt
        cell.rankCellView.goalCalCntLabel.text = element.goalCalCnt
        // 셀 디자인 로직
        configureCellDesign(for: cell, at: indexPath.row)

        return cell
    }
    
    // 셀 디자인을 설정하는 함수
        private func configureCellDesign(for cell: RankTableViewCell, at row: Int) {
            // 여기에 switch 문을 사용한 디자인 로직을 넣습니다.
            // 예시:
            switch mainView.segmentedControl.selectedSegmentIndex {
            case 0:
                if [0, 1, 2, 3].contains(row) {
                    cell.designChams()
                } else if [4, 5].contains(row) {
                    cell.designEuropa()
                } else if [17, 18, 19].contains(row) {
                    cell.designMinor()
                } else {
                    cell.designDefault()
                }
            case 1:
                if [0, 1, 2, 3].contains(row) {
                    cell.designChams()
                } else if [4, 5].contains(row) {
                    cell.designEuropa()
                } else if [17, 18, 19].contains(row) {
                    cell.designMinor()
                } else {
                    cell.designDefault()
                }
            case 2:
                if [0, 1, 2, 3].contains(row) {
                    cell.designChams()
                } else if [4, 5].contains(row) {
                    cell.designEuropa()
                } else if [16, 17].contains(row) {
                    cell.designMinor()
                } else {
                    cell.designDefault()
                }
            case 3:
                if [0, 1, 2, 3].contains(row) {
                    cell.designChams()
                } else if [4, 5].contains(row) {
                    cell.designEuropa()
                } else if [17, 18, 19].contains(row) {
                    cell.designMinor()
                } else {
                    cell.designDefault()
                }
            case 4:
                if [0, 1, 2, 3].contains(row) {
                    cell.designChams()
                } else if [4].contains(row) {
                    cell.designEuropa()
                } else if [16, 17].contains(row) {
                    cell.designMinor()
                } else {
                    cell.designDefault()
                }
            default:
                print("error")
            }
        }
}

extension RankViewController: GADBannerViewDelegate {
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            view.addConstraints(
              [NSLayoutConstraint(item: bannerView,
                                  attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: view.safeAreaLayoutGuide,
                                  attribute: .bottom,
                                  multiplier: 1,
                                  constant: 0),
               NSLayoutConstraint(item: bannerView,
                                  attribute: .centerX,
                                  relatedBy: .equal,
                                  toItem: view,
                                  attribute: .centerX,
                                  multiplier: 1,
                                  constant: 0)
              ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        bannerView.alpha = 0
          UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
          })
        print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
