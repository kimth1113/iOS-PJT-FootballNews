//
//  NewsViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import SafariServices
import SnapKit
import SwiftSoup
import GoogleMobileAds

class NewsViewController: BaseViewController {
    
    let mainView = NewsView()
    
    var newsItems: [News] = [] {
        didSet {
            self.mainView.newsTableView.reloadData()
        }
    }
    
    var bannerView: GADBannerView!
    
    override func loadView() {
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBannerView()
        
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
            mainView.newsTableView.refreshControl = refreshControl
        
        newsTableViewConfigure()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "M/d (E)"
        
        let title = formatter.string(from: Date())
        
        navigationItem.title = title
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()

        getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.08201111469, green: 0.08201111469, blue: 0.08201111469, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func refreshNews() {
        // 뉴스 새로고침 로직 구현
        mainView.newsTableView.refreshControl?.endRefreshing()
    }
    
    func newsTableViewConfigure() {
        mainView.newsTableView.delegate = self
        mainView.newsTableView.dataSource = self
        mainView.newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
    }
    
    func setBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88 // 적절한 셀 높이 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let newsItem = newsItems[indexPath.row]
        cell.configure(with: newsItem, at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var newsItem = newsItems[indexPath.row]
        
        newsItem.urlString.removeFirst()
        newsItem.urlString.removeFirst()
        newsItem.urlString.removeFirst()
        newsItem.urlString.removeFirst()
        newsItem.urlString.removeFirst()
        
    
        let urlString = newsItem.urlString
        
        var newsData: [String] = []

        // oid와 aid에 해당하는 숫자 값을 추출하기 위한 정규 표현식
        let pattern = "oid=(\\d+)&aid=(\\d+)"

        // 정규 표현식 객체 생성
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        if let match = regex?.firstMatch(in: urlString, options: [], range: NSRange(urlString.startIndex..., in: urlString)) {
            // oid에 해당하는 숫자 추출
            if let oidRange = Range(match.range(at: 1), in: urlString) {
                
                let oid = String(urlString[oidRange])
                newsData.append(oid)
         
            }
            
            if let aidRange = Range(match.range(at: 2), in: urlString) {
                
                let aid = String(urlString[aidRange])
                newsData.append(aid)
         
            }
        }
        
        guard let combinedURL = URL(string: "https://n.news.naver.com/sports/wfootball/article/\(newsData[0])/\(newsData[1])") else { return }
        
        let safariViewController = SFSafariViewController(url: combinedURL)
        present(safariViewController, animated: true)
    }
}


extension NewsViewController {
    
    
    func getNews() {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                let url = FootballAPI.newsBase.url
                do {
                    let html = try String(contentsOf: url, encoding: .utf8)
                    let doc: Document = try SwiftSoup.parse(html)
                    let newsInfoList: Elements = try doc.select(".home_news_list").select("a")
                    
                    var items: [News] = []
                    for element in newsInfoList.array() {
                        let title = try element.select("span").text()
                        let urlString = try element.attr("href")
//                        guard let url = URL(string: urlString) else { continue }
                        items.append(News(title: title, urlString: urlString))
                    }
                    
                    DispatchQueue.main.async {
                        self.newsItems = items
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presentErrorAlert()
                    }
                }
            }
        }
        
        func presentErrorAlert() {
            let alert = UIAlertController(title: "인터넷 오류", message: "인터넷 통신에 오류가 발생하였습니다.\n잠시후 다시 시도해주십시오.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        }
}

extension NewsViewController: GADBannerViewDelegate {
    
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
