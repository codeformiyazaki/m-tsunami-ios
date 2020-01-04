//
//  InfoViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/06/20.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController{

    @IBOutlet weak var versionLabel: UILabel!

    private lazy var appVersion: String = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }()

    @IBAction func didCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func githubPushed(_ sender: Any) {
        let url = URL(string: "https://github.com/code4miyazaki/m-tsunami-ios")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let apn = UserDefaults.standard.string(forKey: "apn") ?? ""
        versionLabel.text = "Version \(appVersion) \(apn.prefix(6))"
    }
}
