//
//  RssData.swift
//  Moti News
//
//  Created by Modestas Valauskas on 10.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import Foundation
import UIKit
class RssData {

    private var link: String!
    var img: UIImage!
    var string: String!
    var stringTitle: String!
    var cellState: CellState = .Normal
    
    init(link: String, img: UIImage!, string: String, stringTitle: String) {
        self.link = link
        self.img = img
        self.string = string
        self.stringTitle = stringTitle
        self.cellState = .Normal
    }
    
    func getLink() -> String {
        if(link != nil) {
            return link
        } else {
            return "http://www.google.de"
        }
    }

    func getImg() -> UIImage {
        if(img != nil) {
            return img
        } else {
            return UIImage(named: "zutzutzut")!
        }
    }
    
    func getString() -> String {
        if(string != nil) {
            return string
        } else {
            return "Nicht vorhanden"
        }
    }
    
    func getAttributedStringTitle() -> String {
        if(string != nil) {
            return stringTitle
        } else {
            return "Nicht Vorhanden"
        }
    }
    
}