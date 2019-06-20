//
//  InfoViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/06/20.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController{
    @IBAction func githubPushed(_ sender: Any) {
        let url = URL(string: "https://github.com/code4miyazaki/m-tsunami-ios")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
