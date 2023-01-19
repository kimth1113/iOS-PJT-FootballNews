//
//  ReusableProtocol.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/17.
//

import UIKit

protocol ReusableProtocol {
    
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocol {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
