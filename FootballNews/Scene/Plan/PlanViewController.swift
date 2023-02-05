//
//  PlanViewController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/24.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift
import SwiftSoup
import Kingfisher
import GoogleMobileAds

class PlanViewController: BaseViewController {
    
    var bannerView: GADBannerView!
    
    let mainView = PlanView()
    
    let viewModel = PlanViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<MatchSection> { dataSource, tableView, indexPath, item in
        
        if item.categoryName == "경기없음" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoPlanTableViewCell.reuseIdentifier) as? NoPlanTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.reuseIdentifier) as? PlanTableViewCell else {
                return UITableViewCell()
            }
            
            cell.awayTeamScoreLabel.text = item.awayTeamScore
            cell.homeTeamScoreLabel.text = item.homeTeamScore
            
            if item.gameStartTime == item.state {
                cell.stateLabel.text = "경기예정"
                cell.stateLabel.backgroundColor = .systemBlue
                cell.awayTeamScoreLabel.text = nil
                cell.homeTeamScoreLabel.text = nil
            } else if item.state == "종료" {
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
            
            let homeTeamEmblemImageURL = URL(string: item.homeTeamEmblem!)!
            let awayTeamEmblemImageURL = URL(string: item.awayTeamEmblem!)!
            
            cell.gameStartTimeLabel.text = item.gameStartTime
            cell.homeTeamEmblemImageView.kf.setImage(with: homeTeamEmblemImageURL)
            cell.awayTeamEmblemImageView.kf.setImage(with: awayTeamEmblemImageURL)
            cell.homeTeamNameLabel.text = item.homeTeamName
            cell.awayTeamNameLabel.text = item.awayTeamName
            return cell
        }
        
    }
    
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
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"

        viewModel.getPlan(vc: self, date: [yearFormatter.string(from: Date()), monthFormatter.string(from: Date()), dayFormatter.string(from: Date())])
        
        designNavigationBar()
        bind()
        
        planTableViewConfigure()
    }
    
    private func bind() {
        
        let input = PlanViewModel.Input(rightBarButtonTap: navigationItem.rightBarButtonItem?.rx.tap, leftBarButtonTap: navigationItem.leftBarButtonItem?.rx.tap)
        let output = viewModel.trasform(input: input)
        
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
        
        output.rightBarButtonTap!
            .withUnretained(self)
            .bind { (vc, _) in
                let pre = formatter.date(from: vc.navigationItem.title!)
                let now = Calendar.current.date(byAdding: .day, value: 1, to: pre!)
                vc.navigationItem.title = formatter.string(from: now!)
                vc.viewModel.getPlan(vc: vc, date: [yearFormatter.string(from: now!), monthFormatter.string(from: now!), dayFormatter.string(from: now!)])
            }
            .disposed(by: disposeBag)
        
        output.leftBarButtonTap!
            .withUnretained(self)
            .bind { (vc, _) in
                let pre = formatter.date(from: vc.navigationItem.title!)
                let now = Calendar.current.date(byAdding: .day, value: -1, to: pre!)
                vc.navigationItem.title = formatter.string(from: now!)
                vc.viewModel.getPlan(vc: vc, date: [yearFormatter.string(from: now!), monthFormatter.string(from: now!), dayFormatter.string(from: now!)])
            }
            .disposed(by: disposeBag)
    }
    
    private func designNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        navigationController?.navigationBar.tintColor = .darkGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right.circle.fill"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.circle.fill"))
        
    }
    
    func planTableViewConfigure() {
        mainView.planTableView.register(NoPlanTableViewCell.self, forCellReuseIdentifier: NoPlanTableViewCell.reuseIdentifier)
        mainView.planTableView.register(PlanTableViewCell.self, forCellReuseIdentifier: PlanTableViewCell.reuseIdentifier)

        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewModel.sections
            .bind(to: mainView.planTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}

extension PlanViewController: GADBannerViewDelegate {
    
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
