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

class RankViewController: BaseViewController {
    
    let mainView = RankView()
    
    let viewModel = RankViewModel()
    
    let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "리그순위"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        bind()
        rankTableViewConfigure()
    }
    
    func bind() {
        
        let input = RankViewModel.Input(selectSegment: mainView.segmentedControl.rx.selectedSegmentIndex)
        let output = viewModel.transForm(input: input)
        
        output.selectSegment
            .withUnretained(self)
            .subscribe { (vc, index) in
                switch index {
                case 0:
                    vc.viewModel.getRank(league: .EPL)
                case 1:
                    vc.viewModel.getRank(league: .LaLiGa)
                case 2:
                    vc.viewModel.getRank(league: .Bundesliga)
                case 3:
                    vc.viewModel.getRank(league: .Serie)
                case 4:
                    vc.viewModel.getRank(league: .Ligue1)
                default:
                    print("오류")
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
            
//                cell.textLabel?.text = element.rank + element.name
                cell.rankCellView.rankLabel.text = element.rank
                cell.rankCellView.nameLabel.text = element.name
                cell.rankCellView.scoreLabel.text = element.score
                cell.rankCellView.playCntLabel.text = element.playCnt
                cell.rankCellView.winCntLabel.text = element.winCnt
                cell.rankCellView.drawCntLabel.text = element.drawCnt
                cell.rankCellView.lostCntLabel.text = element.lostCnt
                cell.rankCellView.goalCalCntLabel.text = element.goalCalCnt
            }
            .disposed(by: disposeBag)
    }
    
}
