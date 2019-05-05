//
//  FirstViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/01/20.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, UITableViewDataSource, XMLParserDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let url = URL(string: "https://www.data.jma.go.jp/developer/xml/feed/eqvol.xml") else {
            return
        }
        guard let parser = XMLParser(contentsOf: url as URL) else {
            return
        }
        parser.delegate = self
        let result = parser.parse()
        print("parse result = \(result)")
        print(parser)
    }

    // --
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        cell.textLabel?.text = contents[indexPath.row]
        cell.detailTextLabel?.text = updates[indexPath.row]
        return cell
    }

    // --
    var currentElement :String = ""
    var shouldAdd = false
    var contents :[String] = []
    var updates :[String] = []
    var icons :[String] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let s = string.trimmingCharacters(in: .newlines)
        if (s.isEmpty) { return }
        if (currentElement == "content") {
            if shouldAdd {
                let ss = s.components(separatedBy: "】")
                let v = ss[ss.count - 1].replacingOccurrences(of: "　", with: "")
                let vv = v.replacingOccurrences(of: "\n", with: " ")
                contents += [vv]
            }
        }
        if (currentElement == "updated") {
            if shouldAdd {
                updates += [s]
            }
        }
        if (currentElement == "title") {
            shouldAdd = false
            if s.starts(with: "噴火") {
                icons += ["volcano"]
                shouldAdd = true
            } else if s.starts(with: "震源") {
                icons += ["earthquake"]
                shouldAdd = true
            }
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        tableView.reloadData()
    }
}
