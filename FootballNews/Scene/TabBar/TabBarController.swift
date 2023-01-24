//
//  TabBarController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/19.
//

import UIKit

class TabBarController: UITabBarController {

    let NewsVC = NewsViewController()
    let RankVC = RankViewController()
    let PlanVC = PlanViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = tabBarResultController(NewsVC, vcType: .nav, title: "뉴스", baseImg: UIImage(systemName: "star"), selectedImg: UIImage(systemName: "star.fill"))
        let secondVC = tabBarResultController(RankVC, vcType: .nav, title: "순위", baseImg: UIImage(systemName: "person"), selectedImg: UIImage(systemName: "person.fill"))
        let thirdVC = tabBarResultController(PlanVC, vcType: .nav, title: "일정", baseImg: UIImage(systemName: "star"), selectedImg: UIImage(systemName: "star.fill"))
        
        let vcList = [thirdVC, firstVC, secondVC]
        setViewControllers(vcList, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}
