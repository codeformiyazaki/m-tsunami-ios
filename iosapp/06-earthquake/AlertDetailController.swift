//
//  AlertDetailController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/06/14.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import Foundation

import UIKit

class AlertDetailController: UIViewController, XMLParserDelegate{

    @IBOutlet weak var mainLabel: UILabel!

    func loadXml(url: String) {
        print(url)
    }
    
    @IBAction func closePushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func jmaPushed(_ sender: Any) {
        let url = URL(string: "http://www.jma.go.jp/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    // --
    var message :String = ""
    var currentElement :String = ""
    var previousElement :String = ""

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        previousElement = currentElement
        currentElement = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let s = string.trimmingCharacters(in: .newlines)
        if (s.isEmpty) { return }
        if currentElement == "Name" && previousElement == "Area" {
            message += s + "\n"
        } else if currentElement == "jmx_eb:Magnitude" {
            message += "マグニチュード: \(s)\n"
        } else if currentElement == "Text" && previousElement == "ForecastComment" {
            message += s + "\n"
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        mainLabel.text = message
    }
}
