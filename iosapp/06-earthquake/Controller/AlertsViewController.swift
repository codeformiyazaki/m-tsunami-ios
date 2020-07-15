//
//  FirstViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/01/20.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let data = [["miyazaki.city","宮崎市役所","災害発生時にはモードが切り替わります","https://www.city.miyazaki.miyazaki.jp/"],
                ["miyazaki.pref","宮崎県","県全域に関する情報","https://www.pref.miyazaki.lg.jp/"],
                ["jma","気象庁","地震速報や台風の位置情報など","http://www.jma.go.jp/"]]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // --
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let row:[String] = data[indexPath.row] else { return cell }
        cell.imageView?.image = UIImage(named: row[0]) // 64x64 favicon
        cell.textLabel?.text = row[1]
        cell.detailTextLabel?.text = row[2]
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "防災情報が得られるサイト"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row:[String] = data[indexPath.row] else { return }
        guard let url:URL = URL(string: row[3]) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
