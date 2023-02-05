//
//  Rank.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/20.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftSoup
import GoogleMobileAds

class RankViewController: BaseViewController {
    
    var bannerView: GADBannerView!
    
    let mainView = RankView()
    
    let viewModel = RankViewModel()
    
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
        
        navigationItem.title = "5대 리그"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        bind()
        rankTableViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.08201111469, green: 0.08201111469, blue: 0.08201111469, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

//        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func bind() {
        
        let input = RankViewModel.Input(selectSegment: mainView.segmentedControl.rx.selectedSegmentIndex)
        let output = viewModel.transForm(input: input)
        
        output.selectSegment
            .withUnretained(self)
            .subscribe { (vc, index) in
                switch index {
                case 0:
                    vc.viewModel.getRank(vc: vc, league: .EPL)
                case 1:
                    vc.viewModel.getRank(vc: vc, league: .LaLiGa)
                case 2:
                    vc.viewModel.getRank(vc: vc, league: .Bundesliga)
                case 3:
                    vc.viewModel.getRank(vc: vc, league: .Serie)
                case 4:
                    vc.viewModel.getRank(vc: vc, league: .Ligue1)
                default:
                    print("error")
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposeBag")
            }
            .disposed(by: disposeBag)
    }
    
    func rankTableViewConfigure() {

        mainView.rankTableView.register(RankTableViewCell.self, forCellReuseIdentifier: RankTableViewCell.reuseIdentifier)
        
        viewModel.rankList
            .bind(to: mainView.rankTableView.rx.items(cellIdentifier: RankTableViewCell.reuseIdentifier, cellType: RankTableViewCell.self)) { (row, element, cell) in
            
                cell.rankCellView.rankLabel.text = element.rank
                cell.rankCellView.nameLabel.text = element.name
                cell.rankCellView.scoreLabel.text = element.score
                cell.rankCellView.playCntLabel.text = element.playCnt
                cell.rankCellView.winCntLabel.text = element.winCnt
                cell.rankCellView.drawCntLabel.text = element.drawCnt
                cell.rankCellView.lostCntLabel.text = element.lostCnt
                cell.rankCellView.goalCalCntLabel.text = element.goalCalCnt
                
                switch self.mainView.segmentedControl.selectedSegmentIndex {
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
                    } else if [4, 5, 6].contains(row) {
                        cell.designEuropa()
                    } else if [17, 18, 19].contains(row) {
                        cell.designMinor()
                    } else {
                        cell.designDefault()
                    }
                case 2:
                    if [0, 1, 2, 3].contains(row) {
                        cell.designChams()
                    } else if [4, 5, 6].contains(row) {
                        cell.designEuropa()
                    } else if [16, 17].contains(row) {
                        cell.designMinor()
                    } else {
                        cell.designDefault()
                    }
                case 3:
                    if [0, 1, 2, 3].contains(row) {
                        cell.designChams()
                    } else if [4, 5, 6].contains(row) {
                        cell.designEuropa()
                    } else if [17, 18, 19].contains(row) {
                        cell.designMinor()
                    } else {
                        cell.designDefault()
                    }
                case 4:
                    if [0, 1].contains(row) {
                        cell.designChams()
                    } else if [2, 3].contains(row) {
                        cell.designEuropa()
                    } else if [18, 19].contains(row) {
                        cell.designMinor()
                    } else {
                        cell.designDefault()
                    }
                default:
                    print("error")
                }
            }
            .disposed(by: disposeBag)
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
