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
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        return cell
    }
    
    // --
    var currentElement :String = ""
    var currentTitle :String = ""
    var rows :[String] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let s = string.trimmingCharacters(in: .newlines)
        if (s.isEmpty) { return }
        if (currentElement == "content") {
            if currentTitle.starts(with: "噴火") || currentTitle.starts(with: "震源"){
            rows += [s]
            }
            print(s)
        }
        if (currentElement == "updated") {
            print("  at: "+s)
        }
        if (currentElement == "title") {
            currentTitle = s
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        tableView.reloadData()
    }
}

