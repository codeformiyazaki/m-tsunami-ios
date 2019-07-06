//
//  IinamiViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/07/06.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import WebKit

class IinamiViewController: UIViewController{
    var webcam_title:String?
    var webcam_url:URL?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!

    @IBAction func closePushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        let t = webcam_title ?? "title not set"
        titleLabel.text = t
        guard let u = webcam_url else { return }
        webView.load(URLRequest(url: u))
    }
    
    @IBAction func iinamiPushed(_ sender: Any) {
    }
}
