//
//  Constants.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 29/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

enum SettingsConstant : String, CaseIterable {
    case categories = "Categories",
    tags = "Tags",
    createTags = "New Tag"
}


class Color {
    static var deepSkyBlue  = UIColor(named: "deepSkyBlue")!
    static var havelockBlue = UIColor(named: "havelockBlue")!
    static var hummingBird  = UIColor(named: "hummingBird")!
    static var newYorkPink  = UIColor(named: "newYorkPink")!
    static var lightWisteria = UIColor(named: "lightWisteria")!
    static var radicalRed   = UIColor(named: "radicalRed")!
    static var spray        = UIColor(named: "spray")!
    static var wistful      = UIColor(named: "wistful")!
    static var irisBlue      = UIColor(named: "irisBlue")!
    
    static var all : [UIColor] {
        return [ Color.deepSkyBlue,
            Color.havelockBlue,
            Color.hummingBird,
            Color.newYorkPink,
            Color.lightWisteria,
            Color.radicalRed,
            Color.spray,
            Color.wistful,
            Color.irisBlue
        ]
    }
}


