//
//  UserManager.swift
//  06-earthquake
//
//  Created by koogawa on 2019/12/30.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import Foundation
import FirebaseAuth

final class UserManager: NSObject {

    static let sharedInstance = UserManager()

    var userId: String? {
        return Auth.auth().currentUser?.uid
    }

    private override init() {}

    func signInAnonymously(requestFinished: @escaping () -> Void) {
        Auth.auth().signInAnonymously { auth, error in
            guard error == nil else {
                return
            }
            requestFinished()
        }
    }
}
