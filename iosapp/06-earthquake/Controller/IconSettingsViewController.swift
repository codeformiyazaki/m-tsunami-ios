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
    let keys = ["site4earthquake",
                "site4tsunami",
                "building",
                "shelter",
                "site_and_shelter4tsunami",
                "site_and_shelter4flood",
                "webcam"]
    let labels = ["地震発生時の一時避難所","津波発生時の一時避難所","津波避難ビル","指定避難所","指定避難所兼指定緊急避難場所（津波）","指定避難所兼指定緊急避難場所（洪水）","海岸線を監視するウェブカメラ"]

    weak var delegate: IconSettingsViewControllerDelegate?

    private lazy var iconSettingsRepository: IconSettingsRepository = IconSettingsRepositoryImpl()

    @IBAction func closeButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

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
        for i in 0..<keys.count {
            let index = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: index)
            cell?.accessoryType = iconSettingsRepository.fetch(key: keys[i]) ? .checkmark : .none
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: keys[indexPath.row])
        cell.textLabel?.text = labels[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        iconSettingsRepository.toggle(key: keys[indexPath.row])
        load()
    }
}
