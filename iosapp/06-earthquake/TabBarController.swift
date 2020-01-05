//
//  TabBarController.swift
//  06-earthquake
//
//  Created by koogawa on 2019/12/28.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserManager.sharedInstance.userId == nil {
            UserManager.sharedInstance.signInAnonymously {}
        }
    }
}
