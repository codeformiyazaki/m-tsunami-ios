//
//  IconSettingsViewController.swift
//  06-earthquake
//
//  Created by koogawa on 2019/10/27.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

protocol IconSettingsViewControllerDelegate: class {
    func iconSettingsViewControllerDidClose()
}

class IconSettingsViewController: UITableViewController {

    enum IconSetting: Int, CaseIterable {
        case buildings
        case toilets
        case webcams
        case shelters
    }

    weak var delegate: IconSettingsViewControllerDelegate?

    private lazy var iconSettingsRepository: IconSettingsRepository = IconSettingsRepositoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.iconSettingsViewControllerDidClose()
    }

    private func load() {
        IconSetting.allCases.forEach {
            var key = ""
            switch $0 {
            case .buildings:
                key = "buildings"
            case .toilets:
                key = "toilets"
            case .webcams:
                key = "webcams"
            case .shelters:
                key = "shelters"
            }
            let index = IndexPath(row: $0.rawValue, section: 0)
            let cell = tableView.cellForRow(at: index)
            cell?.accessoryType = iconSettingsRepository.fetch(key: key) ? .checkmark : .none
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IconSetting.allCases.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch IconSetting(rawValue: indexPath.row) {
        case .buildings:
            iconSettingsRepository.toggle(key: "buildings")
        case .toilets:
            iconSettingsRepository.toggle(key: "toilets")
        case .webcams:
            iconSettingsRepository.toggle(key: "webcams")
        case .shelters:
            iconSettingsRepository.toggle(key: "shelters")
        case .none:
            break
        }
        load()
    }
}
