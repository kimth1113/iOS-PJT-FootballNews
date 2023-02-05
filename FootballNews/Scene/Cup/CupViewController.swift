//
//  CupViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices
import GoogleMobileAds

class CupViewController: BaseViewController {
    
    var bannerView: GADBannerView!
    
    let viewModel = CupViewModel()
    
    let mainView = CupView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        // 배너 사이즈
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-2896374758725729/7337305637"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        
        navigationItem.title = "국제대회"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        mainView.cupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func bind() {
        
        let input = CupViewModel.Input(selectTap: mainView.cupTableView.rx.modelSelected(Contest.self))
        let output = viewModel.transform(input: input)
        
        viewModel.contestList
            .bind(to: mainView.cupTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            
                cell.textLabel?.text = element.name
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.selectTap
            .withUnretained(self)
            .subscribe { (vc, contest) in
                let safariViewController = SFSafariViewController(url: contest.url)
                vc.present(safariViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

    }
    
}

extension CupViewController: GADBannerViewDelegate {
    
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
