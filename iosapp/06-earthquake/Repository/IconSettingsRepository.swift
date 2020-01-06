//
//  IconSettingsRepository.swift
//  06-earthquake
//
//  Created by koogawa on 2019/10/30.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import Foundation

protocol IconSettingsRepository {
    func fetch(key: String) -> Bool
    func toggle(key: String)
}

struct IconSettingsRepositoryImpl: IconSettingsRepository {

    private let defaults = UserDefaults.standard

    func fetch(key: String) -> Bool {
        return defaults.bool(forKey: key)
    }

    func toggle(key: String) {
        var isChecked = defaults.bool(forKey: key)
        isChecked.toggle()
        defaults.set(isChecked, forKey: key)
        defaults.synchronize()
    }
}
