//
//  SeatsViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/3.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit
import WebKit

class SeatsViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    func load(_ webStr:String){
        webView.loadHTMLString(webStr, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        print("start\(String(describing: webView.url))")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("comit nav:\(String(describing: webView.url))")

    }

}
