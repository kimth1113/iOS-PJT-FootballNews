//
//  CupViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import UIKit
import SafariServices
import GoogleMobileAds

class CupViewController: BaseViewController {
    
    var bannerView: GADBannerView!
    
    let mainView = CupView()
    
    let contestList: [Contest] = [
        Contest(name: "유럽축구연맹(UEFA) 공식 홈페이지", url: URL(string: APIResouce.EuroSite)!),
        Contest(name: "남미축구연맹(CONMEBOL) 공식 홈페이지", url: URL(string: APIResouce.CopaAmericaSite)!),
        Contest(name: "아프리카축구연맹(CAF) 공식 홈페이지", url: URL(string: APIResouce.AfricaNationsSite)!),
        Contest(name: "북중미&카리브해축구연맹(CONCACAF) 공식 홈페이지", url: URL(string: APIResouce.NorthAmericaSite)!),
        Contest(name: "오세아니아축구연맹(OFC) 공식 홈페이지", url: URL(string: APIResouce.OFCNationsSite)!),
        Contest(name: "아시아축구연맹(AFC) 공식 홈페이지", url: URL(string: APIResouce.AsiaSite)!),
        Contest(name: "동아시아축구연맹(EAFF) 공식 홈페이지", url: URL(string: APIResouce.EastAsiaSite)!)
    ]

    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBannerView()
        
        navigationItem.title = "국제대회"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        mainView.cupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        mainView.cupTableView.delegate = self
        mainView.cupTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setBannerView() {
        // Banner view setup remains the same
    }
}

// MARK: - TableView DataSource & Delegate
extension CupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let contest = contestList[indexPath.row]
        cell.textLabel?.text = contest.name
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contest = contestList[indexPath.row]
        let safariViewController = SFSafariViewController(url: contest.url)
        present(safariViewController, animated: true, completion: nil)
    }
}

// GADBannerViewDelegate 구현은 동일하게 유지됩니다.


extension CupViewController: GADBannerViewDelegate {
    
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

