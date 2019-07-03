//
//  SeatsViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/3.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit
import WebKit

class SeatsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func load(_ webStr:String){
        webView.loadHTMLString(webStr, baseURL: nil)
    }
}
