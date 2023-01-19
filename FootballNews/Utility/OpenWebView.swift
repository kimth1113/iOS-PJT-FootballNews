//
//  OpenWebView.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/19.
//

import UIKit
import WebKit

class OpenWebView {
    
    enum TransitionStyle {
        case present
        case push
    }
    
    public static func transitionWebView(_ viewController: UIViewController, url: URL, transitionStyle: TransitionStyle) {
        
        let vc = WebViewController()
        vc.url = url
        
        switch transitionStyle {
        case .present:
            viewController.present(vc, animated: true)
        case .push:
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class WebViewController: UIViewController {
    
    private var webView: WKWebView!
    
    var url: URL = URL(string: "https://sports.news.naver.com/wfootball/index")!
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
