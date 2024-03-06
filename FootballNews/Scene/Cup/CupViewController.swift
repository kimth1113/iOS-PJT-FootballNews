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
        
        setBannerView()
        
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
    
    func setBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        bannerView.adUnitID = APIResouce.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
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

