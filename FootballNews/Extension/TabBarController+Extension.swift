//
//  TabBarController+Extension.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/19.
//

import UIKit

extension UITabBarController {
    
    enum VCSType {
        
        case base
        case nav
    }
    
    func tabBarResultController(_ vc: UIViewController, vcType: VCSType, title: String, baseImg: UIImage?, selectedImg: UIImage?) -> UIViewController {
        
        let resultController: UIViewController?
        
        switch vcType {
        case .base:
            resultController = vc
        case .nav:
            resultController = UINavigationController(rootViewController: vc)
        }
        
        resultController?.tabBarItem.image = baseImg
        resultController?.tabBarItem.selectedImage = selectedImg
        resultController?.tabBarItem.title = title
        
        return resultController!
    }
    
    func getRank() {
        
    }
}
