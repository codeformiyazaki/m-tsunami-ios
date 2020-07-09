//
//  FirstViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/01/20.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import WebKit

class AlertsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://www.city.miyazaki.miyazaki.jp/") else {
            return
        }
        print("loaded!")
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
