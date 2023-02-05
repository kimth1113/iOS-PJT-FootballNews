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
    let CupVC = CupViewController()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.backgroundColor = .orange
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let firstVC = tabBarResultController(NewsVC, vcType: .nav, title: "소식", baseImg: UIImage(systemName: "soccerball"), selectedImg: UIImage(systemName: "soccerball.inverse"))
        let secondVC = tabBarResultController(RankVC, vcType: .nav, title: "순위", baseImg: UIImage(systemName: "pyramid"), selectedImg: UIImage(systemName: "pyramid.fill"))
        let thirdVC = tabBarResultController(PlanVC, vcType: .nav, title: "일정", baseImg: UIImage(systemName: "newspaper"), selectedImg: UIImage(systemName: "newspaper.fill"))
        let fourthVC = tabBarResultController(CupVC, vcType: .nav, title: "국제대회", baseImg: UIImage(systemName: "trophy"), selectedImg: UIImage(systemName: "trophy.fill"))
        
        let vcList = [firstVC, secondVC, thirdVC, fourthVC]
        setViewControllers(vcList, animated: true)
    }

}
