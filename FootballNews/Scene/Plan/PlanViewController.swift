//
//  PlanViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/24.
//

import UIKit
import SafariServices
import SwiftSoup

class PlanViewController: BaseViewController {
    
    
    let mainView = PlanView()
    
    var matchSectionList: [MatchSection] = [] {
        
        didSet {
            matchSectionList = matchSectionList.filter { !$0.items.isEmpty }
            mainView.planTableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        navigationItem.title = formatter.string(from: Date())
        
        getPlan(date: "\(yearFormatter.string(from: Date())) \(monthFormatter.string(from: Date()))\(dayFormatter.string(from: Date()))")
        
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right.circle.fill"), style: .plain, target: self, action: #selector(nextDay))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.circle.fill"), style: .plain, target: self, action: #selector(previousDay))
    }
    
    @objc private func nextDay() {
        
        matchSectionList = []
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let pre = formatter.date(from: navigationItem.title!)
        let now = Calendar.current.date(byAdding: .day, value: 1, to: pre!)
        navigationItem.title = formatter.string(from: now!)
        getPlan(date: "\(yearFormatter.string(from: now!))\(monthFormatter.string(from: now!))\(dayFormatter.string(from: now!))")
    }
    
    @objc private func previousDay() {
        
        matchSectionList = []
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let pre = formatter.date(from: navigationItem.title!)
        let now = Calendar.current.date(byAdding: .day, value: -1, to: pre!)
        navigationItem.title = formatter.string(from: now!)
        getPlan(date: "\(yearFormatter.string(from: now!))\(monthFormatter.string(from: now!))\(dayFormatter.string(from: now!))")
        
    }
    
    private func setupTableView() {
        mainView.planTableView.delegate = self
        mainView.planTableView.dataSource = self
        mainView.planTableView.register(NoPlanTableViewCell.self, forCellReuseIdentifier: NoPlanTableViewCell.reuseIdentifier)
        mainView.planTableView.register(PlanTableViewCell.self, forCellReuseIdentifier: PlanTableViewCell.reuseIdentifier)
    }
}

extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return matchSectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchSectionList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let match = matchSectionList[indexPath.section].items[indexPath.row]
        
        if match.categoryName == "경기없음" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoPlanTableViewCell.reuseIdentifier, for: indexPath) as? NoPlanTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.reuseIdentifier, for: indexPath) as? PlanTableViewCell else {
                return UITableViewCell()
            }
            
            cell.awayTeamScoreLabel.text = match.awayTeamScore
            cell.homeTeamScoreLabel.text = match.homeTeamScore
            
            if match.state == "전력비교" {
                cell.stateLabel.text = "경기예정"
                cell.stateLabel.backgroundColor = .systemBlue
                cell.awayTeamScoreLabel.text = nil
                cell.homeTeamScoreLabel.text = nil
            } else if match.state == "result" {
                cell.stateLabel.text = "경기종료"
                cell.stateLabel.backgroundColor = .darkGray
                if Int(cell.homeTeamScoreLabel.text!)! > Int(cell.awayTeamScoreLabel.text!)! {
                    cell.homeTeamScoreLabel.textColor = .systemRed
                    cell.awayTeamScoreLabel.textColor = .white
                } else if Int(cell.homeTeamScoreLabel.text!)! < Int(cell.awayTeamScoreLabel.text!)! {
                    cell.homeTeamScoreLabel.textColor = .white
                    cell.awayTeamScoreLabel.textColor = .systemRed
                } else {
                    cell.homeTeamScoreLabel.textColor = .white
                    cell.awayTeamScoreLabel.textColor = .white
                }
            } else {
                cell.stateLabel.text = "경기중"
                cell.stateLabel.backgroundColor = .systemRed
                cell.homeTeamScoreLabel.textColor = .white
                cell.awayTeamScoreLabel.textColor = .white
            }
            
            cell.gameStartTimeLabel.text = match.gameStartTime
            cell.homeTeamNameLabel.text = match.homeTeamName
            cell.awayTeamNameLabel.text = match.awayTeamName
            
            if cell.homeTeamNameLabel.text == "토트넘" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "토트넘 of Sonny"
            } else if cell.homeTeamNameLabel.text == "울버햄튼" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "울버햄튼 of Hwang"
            } else if cell.homeTeamNameLabel.text == "바이에른 뮌헨" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "뮌헨 of Monster"
            } else if cell.homeTeamNameLabel.text == "미트윌란" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "미트윌란 of Cho"
            } else if cell.homeTeamNameLabel.text == "슈투트가르트" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "슈투트가르트 of Jeong"
            } else if cell.homeTeamNameLabel.text == "마인츠" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "마인츠 of Lee"
            } else if cell.homeTeamNameLabel.text == "브렌트퍼드" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "브렌트퍼드 of Kim"
            } else if cell.homeTeamNameLabel.text == "PSG" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "PSG of Lee"
            } else if cell.homeTeamNameLabel.text == "츠르베나 즈베즈다" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "츠르베나 즈베즈다 of Hwang"
            } else if cell.homeTeamNameLabel.text == "셀틱" {
                cell.homeTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.homeTeamNameLabel.text = "셀틱 of Oh"
            } else {
                cell.homeTeamNameLabel.textColor = .white
            }
            
            if cell.homeTeamNameLabel.text == "토트넘" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "토트넘 of Sonny"
            } else if cell.homeTeamNameLabel.text == "울버햄튼" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "울버햄튼 of Hwang"
            } else if cell.homeTeamNameLabel.text == "바이에른 뮌헨" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "뮌헨 of Monster"
            } else if cell.homeTeamNameLabel.text == "미트윌란" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "미트윌란 of Cho"
            } else if cell.homeTeamNameLabel.text == "슈투트가르트" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "슈투트가르트 of Jeong"
            } else if cell.homeTeamNameLabel.text == "마인츠" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "마인츠 of Lee"
            } else if cell.homeTeamNameLabel.text == "브렌트퍼드" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "브렌트퍼드 of Kim"
            } else if cell.homeTeamNameLabel.text == "PSG" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "PSG of Lee"
            } else if cell.homeTeamNameLabel.text == "츠르베나 즈베즈다" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "츠르베나 즈베즈다 of Hwang"
            } else if cell.homeTeamNameLabel.text == "셀틱" {
                cell.awayTeamNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.awayTeamNameLabel.text = "셀틱 of Oh"
            } else {
                cell.awayTeamNameLabel.textColor = .white
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return matchSectionList[section].header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = matchSectionList[indexPath.section].items[indexPath.row]
        
        guard let url = URL(string: match.detailUrl ?? "") else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
}


extension PlanViewController {
    
    // 날짜 변경 시 마다 실행 (모든 리그 크롤링)
    func getPlan(date: String) {
        let leagues = ["epl": "프리미어리그", "primera": "라리가", "bundesliga": "분데스리가", "seria": "세리에", "ligue1": "리그앙", "champs": "챔피언스리그", "europa": "유로파리그", "uecl": "컨퍼런스리그", "facup": "FA", "carlingcup": "EFL", "copadelrey": "코파델레이"]
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let group = DispatchGroup()
        
        leagues.forEach { league, header in
            group.enter()
            getLeaguePlan(league: league, date: date, header: header) { section in
                self.matchSectionList.append(section)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    private func getLeaguePlan(league: String, date: String, header: String, completion: @escaping (MatchSection) -> Void) {
        guard let url = URL(string: "https://sports.news.naver.com/scoreboard/index?date=\(date)&category=\(league)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var section = MatchSection(header: header, items: [])
            
            if let html = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let tests: Elements = try doc.select("td")
                    
                    for test in tests.array() {
                        if [header].contains(try test.text())  {
                            
                            // 리그 카테고리
                            let league = try test.select(".game").text()
                            
                            // 시각
                            let time = try test.parent()!.select(".time").text()
                            
                            var gameList: [String] = []
                            // 팀 vs 팀
                            for t in try test.parent()!.select(".state") {
                                gameList.append(try t.text())
                            }

                            let resultList: [[String]] = gameList.map { game in
                                
                                if game.contains(":") {
                                    // 정규 표현식을 사용하여 팀 이름과 점수를 분리합니다.
                                    let regex = try! NSRegularExpression(pattern: "([가-힣a-zA-Z ]+) (\\d) : (\\d) ([가-힣a-zA-Z ]+)")
                                    let matches = regex.matches(in: game, range: NSRange(game.startIndex..., in: game))
                                    
                                    var result: [String] = []
                                    if let match = matches.first, match.numberOfRanges == 5 {
                                        // 각 그룹(팀 이름과 점수)을 추출합니다.
                                        for rangeIndex in 1..<match.numberOfRanges {
                                            let range = match.range(at: rangeIndex)
                                            if let swiftRange = Range(range, in: game) {
                                                let matchString = String(game[swiftRange])
                                                result.append(matchString)
                                            }
                                        }
                                    }
                                    return result
                                } else {
                                    // ":"를 기준으로 점수 부분과 팀 이름을 분리합니다.
                                    let parts = game.components(separatedBy: " vs ")
                                    // 분리된 부분들을 배열로 재구성합니다.
                                    var result: [String] = []
                                    for part in parts {
                                        result.append(part)
                                        result.append("")
                                        result.append("")
                                    }
                                    return result
                                }
                            }
                            
                            var stateList: [String] = []
                            var urlList: [String] = []
                            // 경기 상태
                            for t in try test.siblingElements().select("img") {
                                if try t.attr("alt") != "worldfootball" {
                                    
                                    if ["result", "진행중", "전력비교"].contains(try t.attr("alt")) {
                                        stateList.append(try t.attr("alt"))
                                        urlList.append("https://m.sports.naver.com\(try t.parent()?.attr("href") ?? "")")
                                    }
                                }
                            }
                            
                            print(urlList)
                            
                            for i in 0 ..< gameList.count {
                                
                                var homeWon: String? = nil
                                var awayWon: String? = nil
                                
                                if resultList[i][1] != "" {
                                    if resultList[i][1] > resultList[i][3] {
                                        homeWon = "win"
                                        awayWon = "lose"
                                    } else if resultList[i][1] == resultList[i][3] {
                                        homeWon = "draw"
                                        awayWon = "draw"
                                    } else {
                                        homeWon = "lose"
                                        awayWon = "win"
                                    }
                                }
                                
                                let match = Match(
                                    categoryName: league,
                                    gameStartTime: time,
                                    state: stateList[i],
                                    homeTeamName: resultList[i][0],
                                    awayTeamName: resultList[i][3],
                                    homeTeamScore: resultList[i][1],
                                    awayTeamScore: resultList[i][2],
                                    homeTeamWon: homeWon,
                                    awayTeamWon: awayWon,
                                    detailUrl: urlList[i]
                                )
                                
                                section.items.append(match)
                            }
                        }
                    }
                    
                } catch {
                    print("error: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                completion(section)
            }
            
        }
        
        task.resume()
        
    }
}
