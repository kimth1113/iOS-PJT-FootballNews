//
//  NewsViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices
import GoogleMobileAds

class NewsViewController: BaseViewController {
    
    var bannerView: GADBannerView!
    
    let mainView = NewsView()
    
    let viewModel = NewsViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        // 배너 사이즈
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        bannerView.adUnitID = APIResouce.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "M/d (E)"
        
        let title = formatter.string(from: Date())
        
        navigationItem.title = title
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()

        bind()
        newsTableViewConfigure()
        viewModel.getNews(vc: self)
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
    
    func bind() {
        
        let input = NewsViewModel.Input(selectCell: mainView.newsTableView.rx.modelSelected(News.self))
        let output = viewModel.transform(input: input)
        
        viewModel.newsList
            .bind(to: mainView.newsTableView.rx.items(cellIdentifier: NewsTableViewCell.reuseIdentifier, cellType: NewsTableViewCell.self)) { (row, element, cell) in
            
                cell.textLabel?.text = element.title
                cell.textLabel?.textColor = .white
                
                if [0, 1, 2, 3, 4].contains((row % 10)) {
                    cell.designZeroToFourCell()
                } else {
                    cell.designFiveToNineCell()
                }
            }
            .disposed(by: disposeBag)
        
        output.selectCell
            .withUnretained(self)
            .subscribe { (vc, news) in
                let safariViewController = SFSafariViewController(url: news.url)
                vc.present(safariViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    func newsTableViewConfigure() {
        mainView.newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
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
                              toItem: bottomLayoutGuide,
                              attribute: .top,
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
