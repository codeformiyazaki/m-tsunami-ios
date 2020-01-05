//
//  HinataViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/01/20.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import WebKit

class HinataViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // http://bit.ly/2FzKzMp
        guard let url = URL(string: "https://kenzkenz.xsrv.jp/aaa/#13/131.44455/31.92127%3FS%3D1%26L%3D%5B%5B%7B%22id%22%3A%22shinsuishin%22%2C%22o%22%3A1%7D%2C%7B%22id%22%3A1%2C%22o%22%3A1%7D%5D%2C%5B%7B%22id%22%3A2%2C%22o%22%3A1%2C%22c%22%3A%22%22%7D%5D%2C%5B%7B%22id%22%3A4%2C%22o%22%3A1%2C%22c%22%3A%22%22%7D%5D%2C%5B%7B%22id%22%3A5%2C%22o%22%3A1%2C%22c%22%3A%22%22%7D%5D%5D") else {
            return
        }
        print("loaded!")
        let request = URLRequest(url: url)
        webView.load(request)
    }


}
