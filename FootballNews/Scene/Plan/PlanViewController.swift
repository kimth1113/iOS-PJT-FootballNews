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

class PlanViewController: BaseViewController {
    
    let mainView = PlanView()
    
    let viewModel = PlanViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<MatchSection> { dataSource, tableView, indexPath, item in
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        if item.categoryName == "경기없음" {
            cell.textLabel?.text = "경기없음"
        } else {
            cell.textLabel?.text = "\(item.homeTeamName!) vs \(item.awayTeamName!)"
        }
        
        return cell
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getPlan(date: ["2023", "01", "25"])
        designNavigationBar()
        
        planTableViewConfigure()
    }
    
    private func designNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        
        navigationItem.title = formatter.string(from: Date())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음날")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전날")
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let pre = formatter.date(from: vc.navigationItem.title!)
                let now = Calendar.current.date(byAdding: .day, value: 1, to: pre!)
                vc.navigationItem.title = formatter.string(from: now!)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let pre = formatter.date(from: vc.navigationItem.title!)
                let now = Calendar.current.date(byAdding: .day, value: -1, to: pre!)
                vc.navigationItem.title = formatter.string(from: now!)
            }
            .disposed(by: disposeBag)
        
    }
    
    func planTableViewConfigure() {
        mainView.planTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewModel.sections
            .bind(to: mainView.planTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
