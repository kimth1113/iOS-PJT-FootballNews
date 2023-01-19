//
//  TabBarController.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/19.
//

import UIKit

class TabBarController: UITabBarController {

    let NewsVC = NewsViewController()
    let NewsVC2 = NewsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(#function)
        
        let firstVC = tabBarResultController(NewsVC, vcType: .nav, baseImg: UIImage(systemName: "star"), selectedImg: UIImage(systemName: "star.fill"))
        let secondVC = tabBarResultController(NewsVC2, vcType: .nav, baseImg: UIImage(systemName: "star"), selectedImg: UIImage(systemName: "star.fill"))
        
        let vcList = [firstVC, secondVC]
        setViewControllers(vcList, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(#function)
    }

}
